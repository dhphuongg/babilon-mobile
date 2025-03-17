import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:babilon/core/application/common/widgets/input/app_text_field.dart';
import 'package:babilon/core/application/common/widgets/color_picker/app_color_picker.dart';
import 'package:babilon/core/application/common/widgets/dialog/custom_dialog.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputColorPicker extends StatefulWidget {
  final String? label;
  final bool? isRequired;
  final TextEditingController colorController;
  final Color initColor;
  final bool enabled;

  final Function(String) onChanged;

  const InputColorPicker(
      {super.key,
      this.label,
      this.isRequired,
      required this.onChanged,
      required this.colorController,
      required this.initColor,
      required this.enabled});

  @override
  State<InputColorPicker> createState() => _InputColorPickerState();
}

class _InputColorPickerState extends State<InputColorPicker> {
  late Color currentColor;
  @override
  void initState() {
    super.initState();
    currentColor = widget.initColor;
  }

  String colorToHex(Color color) {
    // Ensure the color is in ARGB format
    String hexColor = color.value.toRadixString(16).padLeft(8, '0');
    return '#${hexColor.substring(2)}'; // Remove the alpha channel
  }

  void _showDialogColorPicker() {
    if (!widget.enabled) return;
    showCustomDialog(
      context,
      content: CustomColorPicker(
        color: currentColor,
        onChanged: (color) {
          widget.onChanged(colorToHex(color));
          setState(() {
            currentColor = color;
          });
        },
      ),
      hideNegativeButton: true,
      hidePositiveButton: true,
    );
  }

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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: AppTextField(
                enable: false,
                hintText: 'Color',
                // isRequired: true,
                controller: widget.colorController,
                onChanged: (value) => {},
                keyboardType: TextInputType.text,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: _showDialogColorPicker,
                child: Container(
                  height: 48.h,
                  width: 48.h,
                  decoration: BoxDecoration(
                    color: currentColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.gray),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
