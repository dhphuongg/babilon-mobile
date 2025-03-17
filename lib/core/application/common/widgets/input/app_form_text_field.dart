import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppFormTextField extends StatefulWidget {
  final String? label;
  final String defaultValue;
  final String? hintText;
  final Function(String value)? onChanged;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final bool enabled;
  final bool obscureText;
  final String? Function(String)? validator;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  final Function(String)? onFieldSubmitted;
  final Widget? prefixIcon;

  const AppFormTextField({
    required this.label,
    this.defaultValue = '',
    this.hintText,
    this.onChanged,
    this.maxLines,
    this.maxLength,
    this.keyboardType,
    this.enabled = true,
    this.obscureText = false,
    this.validator,
    this.textInputAction,
    this.autoFocus = false,
    this.onFieldSubmitted,
    this.prefixIcon,
    super.key,
  });

  @override
  State<AppFormTextField> createState() => _AppFormTextFieldState();
}

class _AppFormTextFieldState extends State<AppFormTextField> {
  final _focusNode = FocusNode();
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.defaultValue);

    _controller.addListener(() {
      widget.onChanged?.call(_controller.text);
    });

    if (widget.autoFocus) {
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = 8.r;
    final textStyle = AppStyle.regular14black;
    final borderColor = AppColors.gray.withOpacity(0.2);

    return Form(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // if (widget.label?.isNotEmpty ?? false) ...[
            //   Text(
            //     widget.label!,
            //     style: AppStyle.regular14black,
            //   ),
            // ],
            Container(
              color: AppColors.transparent,
              child: TextFormField(
                cursorColor: AppColors.main,
                textAlignVertical: TextAlignVertical.center,
                controller: _controller,
                focusNode: _focusNode,
                maxLength: widget.maxLength,
                maxLines: widget.maxLines,
                enabled: widget.enabled,
                obscureText: widget.obscureText,
                enableSuggestions: false,
                autocorrect: false,
                style: textStyle.copyWith(fontWeight: FontWeight.w700),
                decoration: InputDecoration(
                  filled: widget.textInputAction == TextInputAction.search,
                  fillColor: borderColor,
                  contentPadding:
                      EdgeInsets.only(right: 12.w, top: 10.h, bottom: 10.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: const BorderSide(color: AppColors.main),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: const BorderSide(color: AppColors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: const BorderSide(color: AppColors.red),
                  ),
                  hintText: widget.hintText,
                  hintStyle: textStyle.copyWith(color: AppColors.gray),
                  errorStyle: AppStyle.medium14red,
                  isDense: true,
                  prefix: SizedBox(width: 8.w),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: widget.prefixIcon != null ? 20.r : 0,
                    minHeight: widget.prefixIcon != null ? 20.r : 0,
                  ),
                  prefixIcon: widget.prefixIcon != null
                      ? Padding(
                          padding: EdgeInsets.only(left: 12.w),
                          child: widget.prefixIcon)
                      : SizedBox(width: 4.w),
                ),
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                validator: (value) => widget.validator?.call(value ?? ''),
                // onTapOutside: (event) => AppUtils.dismissKeyboard(),
                onFieldSubmitted: (value) =>
                    widget.onFieldSubmitted?.call(value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
