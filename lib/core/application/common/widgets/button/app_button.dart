import 'package:flutter/material.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final String text;
  final bool disable;
  final VoidCallback? onPressed;
  final Color color;
  final Color? borderColor;
  final TextStyle? textStyle;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;

  const AppButton({
    Key? key,
    this.disable = false,
    required this.text,
    required this.onPressed,
    this.color = AppColors.main,
    this.borderColor,
    this.textStyle,
    this.icon,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disable ? 0.4 : 1,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: padding ?? EdgeInsets.all(4.w),
            side: borderColor != null
                ? BorderSide(color: borderColor ?? AppColors.main, width: 2)
                : null),
        onPressed: () {
          if (onPressed == null || disable) return;
          onPressed!();
        },
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color: Colors.white,
                  size: 16.sp,
                ),
              if (text.isNotEmpty)
                SizedBox(width: 4.w), // Add space between icon and text
              Text(
                text,
                style: textStyle ?? AppStyle.semiBold16white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
