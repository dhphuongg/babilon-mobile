import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final bool disable;
  final IconData? icon;
  final VoidCallback onPressed;
  final double? size;
  final Color? color;

  const AppIconButton({
    Key? key,
    required this.disable,
    this.icon,
    required this.onPressed,
    this.size,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disable ? 0.5 : 1,
      child: GestureDetector(
        onTap: () {
          if (disable) return;
          onPressed();
        },
        child: Icon(
          icon,
          size: size,
          color: color ?? AppColors.black,
        ),
      ),
    );
  }
}
