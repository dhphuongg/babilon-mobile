import 'package:babilon/core/application/common/widgets/loading/shimmer_skeleton.dart';
import 'package:babilon/core/domain/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';

class InputLoading extends StatelessWidget {
  final String? label;

  const InputLoading({
    Key? key,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label ?? '', style: AppStyle.medium14black),
          SizedBox(height: 4.h),
        ],
        ShimmerSkeleton(height: 48.h),
        if (label != null) ...[
          SizedBox(height: AppPadding.input),
        ],
      ],
    );
  }
}
