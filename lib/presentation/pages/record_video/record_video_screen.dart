import 'dart:async';

import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';
import 'package:babilon/core/domain/utils/date.dart';
import 'package:babilon/core/domain/utils/permission.dart';
import 'package:babilon/presentation/pages/record_video/widgets/camera_setting.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

enum CameraMode { post, live }

class RecordVideoScreen extends StatefulWidget {
  const RecordVideoScreen({super.key});

  @override
  State<RecordVideoScreen> createState() => RecordVideoScreenState();
}

class RecordVideoScreenState extends State<RecordVideoScreen>
    with WidgetsBindingObserver {
  final TextEditingController _titleController = TextEditingController();
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isStarted = false;
  bool _isRecording = false;
  bool _isBackCamera = false; // Track which camera is active
  bool _isFlashOn = false; // Track flash status

  // Recording duration options
  final List<int> _durationOptions = [15, 60]; // in seconds
  int _selectedDuration = 60; // Default option

  // For recording timer
  int _recordingTime = 0;
  int _pausedTime = 0; // Store recording time when paused
  Timer? _timer;

  // For gallery thumbnail
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    PermissionUtil.checkCameraPermission(
      () => PermissionUtil.checkMicrophonePermission(
        () => _initCamera(),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _cameraController?.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    List<CameraDescription> cameras = await availableCameras();

    if (cameras.isNotEmpty) {
      final CameraDescription cameraDescription = _isBackCamera
          ? cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back,
              orElse: () => cameras.first,
            )
          : cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.front,
              orElse: () => cameras.last,
            );

      _cameraController = CameraController(
        cameraDescription,
        ResolutionPreset.high,
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      try {
        await _cameraController!.initialize();
        if (_isFlashOn && _isBackCamera) {
          await _cameraController!.setFlashMode(FlashMode.torch);
        } else {
          await _cameraController!.setFlashMode(FlashMode.off);
        }

        setState(() {
          _isCameraInitialized = true;
        });
      } catch (e) {
        debugPrint('Error initializing camera: $e');
      }
    }
  }

  Future<void> _switchCamera() async {
    if (_cameraController == null || _isRecording) return;

    setState(() {
      _isCameraInitialized = false;
      _isBackCamera = !_isBackCamera;

      if (!_isBackCamera) {
        _isFlashOn = false;
      }
    });

    await _cameraController?.dispose();
    await _initCamera();
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || !_isBackCamera || _isRecording) return;

    try {
      _isFlashOn = !_isFlashOn;
      await _cameraController!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
      setState(() {});
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }

  void _startTimer({bool reset = true}) {
    if (reset) {
      _recordingTime = 0;
      _pausedTime = 0;
    } else {
      _recordingTime = _pausedTime;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingTime++;
      });

      if (_recordingTime >= _selectedDuration) {
        _completeRecording();
      }
    });
  }

  Future<void> _toggleRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (_isStarted) {
      if (_isRecording) {
        await _cameraController!.pauseVideoRecording();
        setState(() {
          _isRecording = false;
          _pausedTime = _recordingTime;
        });
        _timer?.cancel();
      } else {
        await _cameraController!.resumeVideoRecording();
        setState(() {
          _isRecording = true;
        });
        _startTimer(reset: false);
      }
    } else {
      try {
        await _cameraController!.startVideoRecording();
        setState(() {
          _isStarted = true;
          _isRecording = true;
          _pausedTime = 0;
        });
        _startTimer(reset: true);
      } catch (e) {
        debugPrint('Error starting video recording: $e');
      }
    }
  }

  Future<void> _completeRecording() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        !_isStarted) {
      return;
    }

    _timer?.cancel();

    try {
      final XFile videoFile = await _cameraController!.stopVideoRecording();
      final String videoPath = videoFile.path;
      setState(() {
        _isStarted = false;
        _isRecording = false;
        _pausedTime = 0;
      });

      if (mounted) {
        await Navigator.pushNamed(
          context,
          RouteName.editVideo,
          arguments: {
            'videoPath': videoPath,
            'maxDuration': _selectedDuration,
          },
        );

        _initCamera();
      }
    } catch (e) {
      debugPrint('Error stopping video recording: $e');
    }
  }

  Future<void> _cancelRecording() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        !_isStarted) {
      return;
    }

    _timer?.cancel();
    try {
      await _cameraController!.stopVideoRecording();
      setState(() {
        _isStarted = false;
        _isRecording = false;
        _recordingTime = 0;
        _pausedTime = 0;
      });
    } catch (e) {
      debugPrint('Error canceling video recording: $e');
    }
  }

  Future<void> _pickVideoFromGallery() async {
    try {
      final video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        final bool wasInitialized =
            _cameraController?.value.isInitialized ?? false;
        if (wasInitialized) {
          await _cameraController?.dispose();
          setState(() {
            _isCameraInitialized = false;
          });
        }

        if (mounted) {
          await Navigator.pushNamed(
            context,
            RouteName.editVideo,
            arguments: {
              'videoPath': video.path,
              'maxDuration': _selectedDuration,
            },
          );

          if (mounted && wasInitialized) {
            _initCamera();
          }
        }
      }
    } catch (e) {
      debugPrint('Error picking video: $e');
    }
  }

  Widget _buildModePicker() {
    return Container(
      color: AppColors.black,
      padding: EdgeInsets.symmetric(vertical: AppPadding.vertical),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            child: Text(
              'Bài đăng',
              style: TextStyle(
                color: AppColors.main,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: AppPadding.horizontal),
          GestureDetector(
            onTap: () async {
              if (!_isRecording && mounted) {
                await Navigator.pushNamed(context, RouteName.live);
                // await _cameraController?.dispose();
                await _initCamera();
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              child: Text(
                'Live',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationOption(int duration) {
    final isSelected = _selectedDuration == duration;
    return GestureDetector(
      onTap: () {
        if (!_isRecording) {
          setState(() {
            _selectedDuration = duration;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.main : Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${duration}s',
          style: TextStyle(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildRecordButton() {
    final double buttonSize = 70.w;
    final double progressSize = buttonSize + 10.w;

    return Stack(
      alignment: Alignment.center,
      children: [
        if (_isStarted)
          SizedBox(
            width: progressSize,
            height: progressSize,
            child: CircularProgressIndicator(
              value: _recordingTime / _selectedDuration,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.main),
              backgroundColor: Colors.white.withOpacity(0.3),
              strokeWidth: 5.0,
            ),
          ),
        GestureDetector(
          onTap: _toggleRecording,
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isStarted ? Colors.red : Colors.white,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
            ),
            child: Center(
              child: _isStarted
                  ? Icon(
                      _isRecording
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 30,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGalleryButton() {
    return Center(
      child: GestureDetector(
        onTap: _pickVideoFromGallery,
        child: Container(
          width: 50.w,
          height: 60.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(
            Icons.photo_library,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildPostControl() {
    return Column(
      children: [
        if (_isStarted)
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              formatDuration(_recordingTime),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _durationOptions
                .map((duration) => Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: _buildDurationOption(duration),
                    ))
                .toList(),
          ),
        SizedBox(height: AppPadding.input),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(),
            ),
            _buildRecordButton(),
            Expanded(
              flex: 1,
              child: _isStarted
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _cancelRecording,
                          child: Container(
                            width: 35.w,
                            height: 35.w,
                            decoration: const BoxDecoration(
                              color: AppColors.gray,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        SizedBox(width: AppPadding.input),
                        GestureDetector(
                          onTap: _completeRecording,
                          child: Container(
                            width: 35.w,
                            height: 35.w,
                            decoration: const BoxDecoration(
                              color: AppColors.main,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    )
                  : _buildGalleryButton(),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _isCameraInitialized
                        ? AspectRatio(
                            aspectRatio: _cameraController!.value.aspectRatio,
                            child: CameraPreview(_cameraController!),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                  Positioned(
                    top: 20.h,
                    left: 20.w,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: AppColors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  if (!_isStarted)
                    Positioned(
                      top: 20.h,
                      right: 20.w,
                      child: CameraSetting(
                        isLiveMode: false,
                        isBackCamera: _isBackCamera,
                        isFlashOn: _isFlashOn,
                        onSwitchCamera: _switchCamera,
                        onToggleFlash: _toggleFlash,
                      ),
                    ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 40.h,
                    child: _buildPostControl(),
                  ),
                ],
              ),
            ),
            _buildModePicker(),
          ],
        ),
      ),
    );
  }
}
