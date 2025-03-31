import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_spacing.dart';
import 'package:babilon/core/domain/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final int? maxLine;
  final TextInputType? keyboardType;
  final bool isRequired;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final String? validator;
  final bool enable;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final String? label;
  final TextAlign? textAlign;
  final void Function(String)? onFieldSubmitted;
  final String? suffixText;
  final EdgeInsets? contentPadding;
  final FocusNode? focusNode;
  final int maxLength;
  final Widget? prefix;
  final String? Function(String?)? validateFunction;

  const AppTextField({
    Key? key,
    this.controller,
    this.initialValue,
    this.hintText,
    this.maxLine = 1,
    this.keyboardType,
    this.isRequired = false,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.enable = true,
    this.inputFormatters,
    this.obscureText = false,
    this.label = "",
    this.textAlign,
    this.onFieldSubmitted,
    this.suffixText,
    this.contentPadding,
    this.focusNode,
    this.maxLength = 255,
    this.prefix,
    this.validateFunction,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label?.isNotEmpty == true) ...[
          Text.rich(
            TextSpan(
              text: widget.label,
              style: AppStyle.medium14black,
              children: <InlineSpan>[
                TextSpan(
                  text: widget.isRequired == true ? " *" : "",
                  style: AppStyle.medium14red,
                )
              ],
            ),
          ),
          SizedBox(height: 4.h),
        ],
        TextFormField(
          maxLength: widget.maxLength,
          textInputAction: TextInputAction.done,
          initialValue: widget.initialValue,
          controller: widget.controller,
          obscuringCharacter: "●",
          obscureText: widget.obscureText,
          maxLines: widget.maxLine,
          enabled: widget.enable,
          inputFormatters: widget.inputFormatters,
          textAlign: widget.textAlign ?? TextAlign.start,
          focusNode: widget.focusNode,
          decoration: InputDecoration(
            counterText: '',
            suffixText: widget.suffixText,
            filled: widget.enable ? null : true,
            fillColor: widget.enable ? null : AppColors.disable,
            contentPadding: widget.contentPadding ??
                EdgeInsets.only(right: 10.w, top: 14.h, bottom: 14.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
              borderSide: const BorderSide(color: AppColors.gray),
            ),
            disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.gray),
                borderRadius: BorderRadius.circular(AppSpacing.borderRadius)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: (widget.validator?.isNotEmpty ?? false)
                      ? AppColors.red
                      : AppColors.gray),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: (widget.validator?.isNotEmpty ?? false)
                      ? AppColors.red
                      : AppColors.main),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.red),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
            ),
            errorStyle: AppStyle.regular12red,
            hintText: widget.hintText,
            suffixStyle: AppStyle.regular12gray,
            hintStyle: AppStyle.regular14gray,
            suffixIcon: widget.suffixIcon != null
                ? Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: widget.suffixIcon)
                : null,
            suffixIconConstraints:
                BoxConstraints(minWidth: 15.w, minHeight: 15.h),
            isDense: true,
            prefix: widget.prefix ?? SizedBox(width: 10.w),
          ),
          cursorColor: AppColors.main,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          style: AppStyle.regular14black,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.trim().isEmpty && widget.isRequired) {
              return "Vui lòng nhập ${widget.label}";
            }
            if (widget.validateFunction != null) {
              return widget.validateFunction!(value);
            }
            return null;
          },
          onFieldSubmitted: widget.onFieldSubmitted ?? (_) {},
        ),
        if (widget.validator?.isNotEmpty ?? false) ...{
          Container(
            color: AppColors.white,
            margin: EdgeInsets.only(top: 2.h),
            child: Text(
              widget.validator!,
              style: AppStyle.regular12red,
            ),
          )
        }
      ],
    );
  }
}
