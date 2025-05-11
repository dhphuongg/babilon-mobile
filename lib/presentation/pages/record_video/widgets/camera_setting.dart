import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CameraSetting extends StatelessWidget {
  final bool isLiveMode;
  final bool isBackCamera;
  final bool isFlashOn;
  final VoidCallback onSwitchCamera;
  final VoidCallback onToggleFlash;

  const CameraSetting({
    super.key,
    required this.isLiveMode,
    required this.isBackCamera,
    required this.isFlashOn,
    required this.onSwitchCamera,
    required this.onToggleFlash,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Switch camera button
        GestureDetector(
          onTap: onSwitchCamera,
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
        if (isBackCamera && !isLiveMode)
          GestureDetector(
            onTap: onToggleFlash,
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppColors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFlashOn ? Icons.flash_on : Icons.flash_off,
                color: isFlashOn ? AppColors.main : Colors.white,
                size: 20,
              ),
            ),
          ),
      ],
    );
  }
}
