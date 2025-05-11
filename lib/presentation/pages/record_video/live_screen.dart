import 'dart:async';

import 'package:babilon/core/application/common/widgets/button/app_button.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/utils/share_preferences.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';
import 'package:babilon/core/domain/utils/permission.dart';
import 'package:babilon/presentation/pages/record_video/widgets/camera_setting.dart';
import 'package:babilon/presentation/pages/user/widgets/profile_avatar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => LiveScreenState();
}

class LiveScreenState extends State<LiveScreen> with WidgetsBindingObserver {
  final TextEditingController _titleController = TextEditingController();
  String _avatarUrl = '';
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isBackCamera = false; // Track which camera is active
  bool _isFlashOn = false; // Track flash status

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadAvatar();
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

  Future<void> _loadAvatar() async {
    final avatar = await SharedPreferencesHelper.getStringValue(
      SharedPreferencesHelper.AVATAR,
    );
    setState(() {
      _avatarUrl = avatar;
    });
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
    _cameraController?.dispose();
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
    if (_cameraController == null) return;

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
    if (_cameraController == null || !_isBackCamera) return;

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
                      onTap: () async {
                        await _cameraController?.dispose();
                        Navigator.pop(context);
                      },
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
                  Positioned(
                    top: 20.h,
                    right: 20.w,
                    child: CameraSetting(
                      isLiveMode: true,
                      isBackCamera: _isBackCamera,
                      isFlashOn: _isFlashOn,
                      onSwitchCamera: _switchCamera,
                      onToggleFlash: _toggleFlash,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 75.h,
                    bottom: 40.h,
                    child: _buildLiveControl(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 65.h)
          ],
        ),
      ),
    );
  }

  Widget _buildLiveControl() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileAvatar(
                avatar: _avatarUrl,
                size: 25.r,
              ),
              SizedBox(width: AppPadding.input),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: TextField(
                    controller: _titleController,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Nhập tiêu đề của buổi live...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16.sp,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 10.h,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppPadding.input),
          AppButton(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            text: 'Bắt đầu live',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
