import 'package:flutter/material.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class DropdownItemEntry {
  final String label;
  final String value;

  DropdownItemEntry({
    required this.label,
    required this.value,
  });
}

class AppDropDownMultipleWidget extends StatefulWidget {
  final MultiSelectController<String> controller;
  final List<DropdownItem<String>> items;
  final String? hintText;
  final String? label;
  final bool enabled;
  final Function(List<String>?) onChanged;
  final String? validator;
  final bool? isRequired;
  final List<int>? initValue;
  final bool? singleSelect;
  final bool? showClearIcon;

  const AppDropDownMultipleWidget({
    super.key,
    required this.controller,
    required this.items,
    this.hintText,
    this.label,
    this.enabled = true,
    required this.onChanged,
    this.validator,
    this.isRequired = false,
    this.initValue,
    this.singleSelect = false,
    this.showClearIcon = false,
  });

  @override
  State<AppDropDownMultipleWidget> createState() =>
      _AppDropDownMultipleWidgetState();
}

class _AppDropDownMultipleWidgetState extends State<AppDropDownMultipleWidget> {
  late List<DropdownItem<String>> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.initValue != null) {
      items = widget.items.map((e) {
        return DropdownItem<String>(
          value: e.value,
          label: e.label,
          selected: widget.initValue!.contains(int.parse(e.value)),
        );
      }).toList();
    } else {
      items = widget.items;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
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
        MultiDropdown(
          items: items,
          controller: widget.controller,
          enabled: widget.enabled,
          singleSelect: widget.singleSelect ?? false,
          maxSelections: 1,
          chipDecoration: ChipDecoration(
            labelStyle: AppStyle.regular14black,
            backgroundColor: AppColors.secondary,
            runSpacing: 10,
            spacing: 10,
            padding:
                EdgeInsets.only(left: 10.w, right: 10.w, top: 6.h, bottom: 6.h),
          ),
          fieldDecoration: FieldDecoration(
            labelStyle: AppStyle.regular14black,
            backgroundColor: widget.enabled ? null : AppColors.disable,
            padding: EdgeInsets.only(
                left: 10.w, right: 10.w, top: 14.h, bottom: 14.h),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.gray,
              size: 16.sp,
            ),
            hintText: widget.hintText,
            hintStyle: AppStyle.regular14gray,
            showClearIcon: widget.showClearIcon ?? false,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.gray),
            ),
            disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.gray),
                borderRadius: BorderRadius.circular(8.w)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: (widget.validator?.isNotEmpty ?? false)
                      ? AppColors.red
                      : AppColors.main),
              borderRadius: BorderRadius.circular(8.w),
            ),
          ),
          dropdownDecoration: const DropdownDecoration(
            elevation: 2,
            marginTop: 6,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          // dropdownItemDecoration: const DropdownItemDecoration(
          //   selectedIcon: Icon(Icons.check_box, color: AppColors.main),
          //   disabledIcon: Icon(Icons.lock, color: AppColors.gray),
          // ),
          validator: (value) {
            return null;
          },
          itemBuilder: (items, index, onTap) {
            return GestureDetector(
              onTap: onTap,
              child: Container(
                width: 20,
                padding: EdgeInsets.only(
                    left: 10.w, right: 10.w, top: 8.h, bottom: 8.h),
                decoration: BoxDecoration(
                    color: items.selected ? AppColors.secondary : Colors.white),
                child: Text(
                  items.label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Visby',
                    color: items.selected ? AppColors.iconButton : Colors.black,
                    fontWeight:
                        items.selected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
          onSelectionChange: (selectedItems) {
            widget.onChanged(selectedItems);
          },
        )
      ],
    );
  }
}
