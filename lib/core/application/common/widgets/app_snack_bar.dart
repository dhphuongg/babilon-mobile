import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_text_styles.dart';
import 'package:babilon/core/domain/constants/icons.dart';
import 'package:babilon/core/domain/utils/navigation_services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSnackBar {
  static void showSuccess(
    String message, {
    FlushbarPosition position = FlushbarPosition.TOP,
  }) {
    bool isPressed = false;

    Flushbar(
      icon: SvgPicture.asset(
        AppIcons.icSuccess,
        width: 20.w,
        height: 20.w,
      ),
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              message,
              style: AppStyle.medium13black,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (!isPressed) {
                NavigationService.navigatorKey.currentState!.maybePop();
                isPressed = true;
              }
            },
            child: Icon(
              Icons.clear,
              size: 20.w,
              color: AppColors.black,
            ),
          )
        ],
      ),
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: position,
      isDismissible: true,
      backgroundColor: Colors.white,
      boxShadows: [
        BoxShadow(
          color: const Color.fromRGBO(0, 0, 0, 0.08),
          blurRadius: 10.w,
        )
      ],
      duration: const Duration(seconds: 3),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      borderRadius: BorderRadius.circular(8),
    ).show(NavigationService.navigatorKey.currentContext!);
  }

  static void showError(
    String title,
    String? content, {
    FlushbarPosition position = FlushbarPosition.TOP,
  }) {
    bool isPressed = false;

    Flushbar(
      icon: SvgPicture.asset(
        AppIcons.icFailure,
        width: 20.w,
        height: 20.w,
      ),
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 230.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyle.semi14black,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 100,
                ),
                content != null
                    ? Text(
                        content,
                        style: AppStyle.medium13black,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (!isPressed) {
                NavigationService.navigatorKey.currentState!.maybePop();
                isPressed = true;
              }
            },
            child: Icon(
              Icons.clear,
              size: 20.w,
              color: AppColors.black,
            ),
          )
        ],
      ),
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: position,
      isDismissible: true,
      backgroundColor: Colors.white,
      boxShadows: [
        BoxShadow(
          color: const Color.fromRGBO(0, 0, 0, 0.08),
          blurRadius: 10.w,
        )
      ],
      duration: const Duration(seconds: 100),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      borderRadius: BorderRadius.circular(8),
    ).show(NavigationService.navigatorKey.currentContext!);
  }

  static void showWarning(
    String message, {
    FlushbarPosition position = FlushbarPosition.TOP,
  }) {
    bool isPressed = false;

    Flushbar(
      icon: SvgPicture.asset(
        AppIcons.icWarning,
        width: 20.w,
        height: 20.w,
      ),
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              message,
              style: AppStyle.medium13black,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (!isPressed) {
                NavigationService.navigatorKey.currentState!.maybePop();
                isPressed = true;
              }
            },
            child: Icon(
              Icons.clear,
              size: 20.w,
              color: AppColors.black,
            ),
          )
        ],
      ),
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: position,
      isDismissible: true,
      backgroundColor: Colors.white,
      boxShadows: [
        BoxShadow(
          color: const Color.fromRGBO(0, 0, 0, 0.08),
          blurRadius: 10.w,
        )
      ],
      duration: const Duration(seconds: 3),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      borderRadius: BorderRadius.circular(8),
    ).show(NavigationService.navigatorKey.currentContext!);
  }
}
