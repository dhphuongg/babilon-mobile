import 'dart:async';
import 'dart:io';

import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';
import 'package:babilon/core/domain/utils/permission.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class RecordVideoScreen extends StatefulWidget {
  const RecordVideoScreen({super.key});

  @override
  State<RecordVideoScreen> createState() => RecordVideoScreenState();
}

class RecordVideoScreenState extends State<RecordVideoScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isStarted = false;
  bool _isRecording = false;
  bool _isPaused = false;
  bool _isBackCamera = true; // Track which camera is active
  bool _isFlashOn = false; // Track flash status

  // Recording duration options
  final List<int> _durationOptions = [15, 60]; // in seconds
  int _selectedDuration = 60; // Default option

  // For recording timer
  int _recordingTime = 0;
  int _pausedTime = 0; // Store recording time when paused
  Timer? _timer;

  // For gallery thumbnail
  File? _latestVideoThumbnail;
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
    // _loadLatestVideoThumbnail();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes
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
          // Flash only works on back camera
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

      // Turn off flash when switching to front camera
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
      // Resume from the saved paused time
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

    if (_isRecording) {
      if (_isPaused) {
        // Resume recording
        await _cameraController!.resumeVideoRecording();
        setState(() {
          _isPaused = false;
        });
        // Resume timer without resetting
        _startTimer(reset: false);
      } else {
        // Pause recording
        await _cameraController!.pauseVideoRecording();
        setState(() {
          _isPaused = true;
          _pausedTime = _recordingTime; // Store current recording time
        });
        _timer?.cancel(); // Pause timer
      }
    } else {
      try {
        // Start new recording
        await _cameraController!.startVideoRecording();
        setState(() {
          _isStarted = true;
          _isRecording = true;
          _isPaused = false;
          _pausedTime = 0; // Reset paused time for new recording
        });
        _startTimer(reset: true); // Explicitly reset timer for new recording
      } catch (e) {
        debugPrint('Error starting video recording: $e');
      }
    }
  }

  Future<void> _completeRecording() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        !_isRecording) {
      return;
    }

    _timer?.cancel();

    try {
      final XFile videoFile = await _cameraController!.stopVideoRecording();
      final String videoPath = videoFile.path;
      setState(() {
        _isStarted = false;
        _isRecording = false;
        _isPaused = false;
        _pausedTime = 0; // Reset paused time when recording stops
      });

      // Set thumbnail
      _latestVideoThumbnail = File(videoPath);
      debugPrint('Video saved to: ${videoFile.path}');

      // For now, we'll just update the thumbnail
      _latestVideoThumbnail = File(videoFile.path);
      if (mounted) {
        await Navigator.pushNamed(
          context,
          RouteName.editVideo,
          arguments: {
            'videoPath': videoPath,
            'maxDuration': _selectedDuration,
          },
        );

        // Reinitialize camera when returning from edit screen
        if (mounted) {
          _initCamera();
        }
      }
    } catch (e) {
      debugPrint('Error stopping video recording: $e');
    }
  }

  Future<void> _cancelRecording() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        !_isRecording) {
      return;
    }

    _timer?.cancel();
    try {
      await _cameraController!.stopVideoRecording();
      setState(() {
        _isStarted = false;
        _isRecording = false;
        _isPaused = false;
        _recordingTime = 0;
        _pausedTime = 0; // Reset paused time when recording is cancelled
      });
    } catch (e) {
      debugPrint('Error canceling video recording: $e');
    }
  }

  Future<void> _loadLatestVideoThumbnail() async {
    try {
      final video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          _latestVideoThumbnail = File(video.path);
        });
      }
    } catch (e) {
      debugPrint('Error loading latest video: $e');
    }
  }

  Future<void> _pickVideoFromGallery() async {
    try {
      final video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        // Navigate to video editing screen with the selected video
        debugPrint('Selected video: ${video.path}');
        setState(() {
          _latestVideoThumbnail = File(video.path);
        });

        // Temporarily dispose camera controller before navigation
        final bool wasInitialized =
            _cameraController?.value.isInitialized ?? false;
        if (wasInitialized) {
          await _cameraController?.dispose();
          setState(() {
            _isCameraInitialized = false;
          });
        }

        // Navigate to edit video screen
        if (mounted) {
          await Navigator.pushNamed(
            context,
            RouteName.editVideo,
            arguments: {
              'videoPath': video.path,
              'maxDuration': _selectedDuration,
            },
          );

          // Reinitialize camera controller when returning from edit screen
          if (mounted && wasInitialized) {
            _initCamera();
          }
        }
      }
    } catch (e) {
      debugPrint('Error picking video: $e');
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera preview
            Positioned.fill(
              child: AspectRatio(
                aspectRatio: _cameraController!.value.aspectRatio,
                child: CameraPreview(_cameraController!),
              ),
            ),

            // Close button (X) in the top-left corner
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

            // Vertical toolbar in the top-right corner
            Positioned(
              top: 20.h,
              right: 20.w,
              child: Column(
                children: [
                  // Switch camera button
                  GestureDetector(
                    onTap: _switchCamera,
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.flip_camera_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Flash toggle button
                  GestureDetector(
                    onTap: _toggleFlash,
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isFlashOn ? Icons.flash_on : Icons.flash_off,
                        color: _isFlashOn ? AppColors.main : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom controls
            Positioned(
              left: 0,
              right: 0,
              bottom: 40.h,
              child: Column(
                children: [
                  // Duration selection or Recording time display
                  _isRecording
                      ? Container(
                          decoration: BoxDecoration(
                            // shadow in center
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
                            _formatDuration(_recordingTime),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _durationOptions
                              .map((duration) => Padding(
                                    padding: EdgeInsets.only(left: 8.w),
                                    child: _buildDurationOption(duration),
                                  ))
                              .toList(),
                        ),
                  SizedBox(height: AppPadding.input),
                  // Recording button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(), // Empty space for alignment
                      ),

                      // Recording button
                      _buildRecordButton(),

                      // Gallery access or other controls based on recording state
                      Expanded(
                        flex: 1,
                        child: _isPaused
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Cancel recording button
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
                                  // Complete recording button
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
              ),
            ),
          ],
        ),
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
    final double progressSize = buttonSize + 10;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Circular progress indicator for recording time
        if (_isRecording && !_isPaused)
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

        // Recording button
        GestureDetector(
          onTap: _toggleRecording,
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isRecording ? Colors.red : Colors.white,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
            ),
            child: Center(
              child: _isRecording
                  ? Icon(
                      _isPaused ? null : Icons.stop_rounded,
                      color: Colors.white,
                      size: 30,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),

        // Space holder when recording (moved timer display to top)
        if (_isRecording) SizedBox(height: progressSize + 10),

        // Selected duration text when not recording
        if (!_isRecording)
          Positioned(
            top: progressSize + 10,
            child: Text(
              '${_selectedDuration}s',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGalleryButton() {
    if (!_isStarted) {
      return Center(
        child: GestureDetector(
          onTap: _pickVideoFromGallery,
          child: Container(
            width: 50.w,
            height: 60.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white, width: 2),
              image: _latestVideoThumbnail != null
                  ? DecorationImage(
                      image: FileImage(_latestVideoThumbnail!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _latestVideoThumbnail == null
                ? const Icon(
                    Icons.photo_library,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
      );
    }

    return Center(
      child: GestureDetector(
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
    );
  }
}
