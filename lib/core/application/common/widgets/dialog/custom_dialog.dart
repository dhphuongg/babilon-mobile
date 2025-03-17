import 'package:flutter/material.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_text_styles.dart';
import 'package:babilon/core/domain/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';

Future showCustomDialog(
  BuildContext context, {
  Function? onPressNegative,
  Function? onPressPositive,
  Function? onHide,
  String? title,
  double? widthIcon,
  double? heightIcon,
  Widget? content,
  bool? hideNegativeButton = false,
  bool? hidePositiveButton = false,
  Color? backgroundPositiveButton,
  Color? borderNegativeButton,
  Color? colorTitle,
  String? textNegative,
  String? textPositive,
  double? marginButton,
  bool? barrierDismissible = true,
  bool? preventBack,
}) async {
  final result = await showDialog(
    barrierDismissible: barrierDismissible!,
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.transparent,
      //   scrollable: true,
      insetPadding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
      contentPadding: EdgeInsets.zero,
      content: WillPopScope(
        onWillPop: preventBack != null ? () async => !preventBack : null,
        child: DialogWidget(
          title: title ?? '',
          textNegative: textNegative,
          textPositive: textPositive,
          content: content,
          colorTitle: colorTitle,
          widthIcon: widthIcon,
          marginButton: marginButton,
          heightIcon: heightIcon,
          hidePositiveButton: hidePositiveButton,
          backgroundPositiveButton: backgroundPositiveButton,
          borderNegativeButton: borderNegativeButton,
          onPressNegative: onPressNegative,
          hideNegativeButton: hideNegativeButton,
          onPressPositive: onPressPositive,
        ),
      ),
    ),
  );
  onHide?.call();
  return result;
}

class DialogWidget extends StatelessWidget {
  final String title;
  final Widget? content;
  final double? widthIcon;
  final double? heightIcon;
  final String? textNegative;
  final String? textPositive;
  final Color? colorTitle;
  final bool? hideNegativeButton;
  final Function? onPressNegative;
  final bool? hidePositiveButton;
  final double? marginButton;
  final Function? onPressPositive;
  final Color? backgroundPositiveButton;
  final Color? borderNegativeButton;

  const DialogWidget({
    Key? key,
    required this.title,
    this.content,
    this.marginButton,
    this.hidePositiveButton,
    this.textNegative,
    this.colorTitle,
    this.widthIcon,
    this.heightIcon,
    this.textPositive,
    this.hideNegativeButton = false,
    this.backgroundPositiveButton,
    this.borderNegativeButton,
    this.onPressNegative,
    this.onPressPositive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: Utils.getScreenWidth(context),
        decoration: BoxDecoration(
            color: AppColors.white, borderRadius: BorderRadius.circular(8.w)),
        child: Stack(
          children: [
            // icon close
            Positioned(
              right: 4,
              top: 4,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.close,
                    color: AppColors.buttonCancel,
                    size: 24.w,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 20.w),
                title != ''
                    ? Padding(
                        padding: EdgeInsets.only(
                            left: AppPadding.horizontal,
                            right: AppPadding.horizontal,
                            bottom: AppPadding.horizontal),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                              color: colorTitle ?? AppColors.black),
                        ),
                      )
                    : const SizedBox.shrink(),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
                  child: content ?? Container(),
                ),
                hidePositiveButton ?? false
                    ? Container()
                    : SizedBox(
                        height: 24.w,
                      ),
                hidePositiveButton ?? false
                    ? Container()
                    : ButtonDialog(
                        marginButton: marginButton,
                        title: textPositive ?? '',
                        backgroundColor: backgroundPositiveButton,
                        onPressed: () {
                          onPressPositive?.call();
                        },
                      ),
                !(hideNegativeButton ?? false)
                    ? Column(
                        children: [
                          SizedBox(
                            height: 12.w,
                          ),
                          ButtonDialog(
                            marginButton: marginButton,
                            title: textNegative ?? '',
                            borderColor: AppColors.buttonCancel,
                            backgroundColor: AppColors.buttonCancel,
                            onPressed: () {
                              onPressNegative?.call();
                            },
                          )
                        ],
                      )
                    : const SizedBox(),
                SizedBox(height: 20.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonDialog extends StatelessWidget {
  final Function? onPressed;
  final String title;
  final Color? titleColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? marginButton;

  const ButtonDialog(
      {Key? key,
      required this.title,
      this.borderColor,
      this.onPressed,
      this.marginButton,
      this.titleColor,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPressed != null) {
          onPressed!();
        }
      },
      child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: marginButton ?? AppPadding.horizontal),
          padding: EdgeInsets.symmetric(vertical: 10.w),
          decoration: BoxDecoration(
            border: Border.all(
                color: borderColor != null
                    ? borderColor!
                    : backgroundColor != null
                        ? backgroundColor!
                        : AppColors.main),
            color: backgroundColor ?? AppColors.main,
            borderRadius: BorderRadius.all(Radius.circular(10.w)),
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyle.semiBold16white,
            ),
          )),
    );
  }
}
