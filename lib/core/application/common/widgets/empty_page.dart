import 'package:babilon/core/domain/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';

class EmptyPage extends StatelessWidget {
  final String? message;
  const EmptyPage({
    this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
          child: SizedBox(
        width: 200,
        height: 200,
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 80.w),
            SizedBox(height: AppPadding.input),
            Text(
              message ?? 'No data found !',
              style: AppStyle.regular16black,
            ),
          ],
        ),
      )),
    );
  }
}
