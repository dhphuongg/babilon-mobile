import 'package:flutter/material.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.main),
        strokeWidth: 6.0,
      ),
    );
  }
}
