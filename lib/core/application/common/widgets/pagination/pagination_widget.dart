import 'package:babilon/core/application/common/widgets/button/app_button.dart';
import 'package:babilon/core/application/common/widgets/input/app_text_field.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';

class Pagination extends StatefulWidget {
  final int currentPage;
  final int lastPage;
  final bool hasNextPage;
  final Function(int) onJumpPage;

  const Pagination({
    super.key,
    required this.currentPage,
    required this.lastPage,
    required this.hasNextPage,
    required this.onJumpPage,
  });

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  late TextEditingController pageController;

  @override
  void initState() {
    // TODO: implement initState
    pageController = TextEditingController(text: widget.currentPage.toString());
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Pagination oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentPage != oldWidget.currentPage) {
      pageController.text = widget.currentPage.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
              blurRadius: 8.r,
              offset: const Offset(3, 0),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: AppPadding.horizontal, vertical: 8.h),
            child: SizedBox(
              // height: 50.h,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 0.h),
                      child: AppButton(
                        text: '',
                        icon: Icons.arrow_back_ios_outlined,
                        disable: widget.currentPage == 1,
                        color: AppColors.main,
                        onPressed: () => {
                          if (widget.currentPage > 1)
                            widget.onJumpPage(widget.currentPage - 1),
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    flex: 1,
                    child: AppTextField(
                      controller: pageController,
                      onFieldSubmitted: (value) {
                        if (value == '' || int.parse(value) < 1) {
                          widget.onJumpPage(1);
                          pageController.text = '1';
                          return;
                        }
                        if (int.parse(value) > widget.lastPage) {
                          widget.onJumpPage(widget.lastPage);
                          pageController.text = widget.lastPage.toString();
                          return;
                        }
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: false),
                      textAlign: TextAlign.right,
                      suffixText: '/${widget.lastPage}',
                      contentPadding: EdgeInsets.only(
                          left: 4.w,
                          right: (42 - widget.lastPage.toString().length * 2).w,
                          top: 14.h,
                          bottom: 14.h),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 0.h),
                      child: AppButton(
                        text: '',
                        icon: Icons.arrow_forward_ios_outlined,
                        textStyle: AppStyle.medium16black,
                        disable: !widget.hasNextPage,
                        color: AppColors.main,
                        onPressed: () => {
                          if (widget.hasNextPage)
                            widget.onJumpPage(widget.currentPage + 1),
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
