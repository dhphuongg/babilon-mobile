import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:video_editor/video_editor.dart';

class CropPage extends StatelessWidget {
  const CropPage({super.key, required this.controller});

  final VideoEditorController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: IconButton(
                    onPressed: () => controller.rotate90Degrees(
                      RotateDirection.left,
                    ),
                    icon: const Icon(Icons.rotate_left),
                    color: AppColors.white,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () => controller.rotate90Degrees(
                      RotateDirection.right,
                    ),
                    icon: const Icon(Icons.rotate_right),
                    color: AppColors.white,
                  ),
                )
              ],
            ),
            SizedBox(height: AppPadding.input),
            Expanded(
              child: CropGridViewer.edit(
                controller: controller,
                rotateCropArea: false,
                margin: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            SizedBox(height: AppPadding.input),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 2,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Center(
                      child: Text(
                        "Hủy",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (_, __) => Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () =>
                                  controller.preferredCropAspectRatio =
                                      controller.preferredCropAspectRatio
                                          ?.toFraction()
                                          .inverse()
                                          .toDouble(),
                              icon: controller.preferredCropAspectRatio !=
                                          null &&
                                      controller.preferredCropAspectRatio! < 1
                                  ? const Icon(
                                      Icons.panorama_vertical_select_rounded)
                                  : const Icon(Icons.panorama_vertical_rounded),
                            ),
                            IconButton(
                              onPressed: () =>
                                  controller.preferredCropAspectRatio =
                                      controller.preferredCropAspectRatio
                                          ?.toFraction()
                                          .inverse()
                                          .toDouble(),
                              icon: controller.preferredCropAspectRatio !=
                                          null &&
                                      controller.preferredCropAspectRatio! > 1
                                  ? const Icon(
                                      Icons.panorama_horizontal_select_rounded)
                                  : const Icon(
                                      Icons.panorama_horizontal_rounded),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _buildCropButton(context, null),
                            _buildCropButton(context, 1.toFraction()),
                            _buildCropButton(
                                context, Fraction.fromString("9/16")),
                            _buildCropButton(
                                context, Fraction.fromString("3/4")),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    onPressed: () {
                      // WAY 1: validate crop parameters set in the crop view
                      controller.applyCacheCrop();
                      // WAY 2: update manually with Offset values
                      // controller.updateCrop(const Offset(0.2, 0.2), const Offset(0.8, 0.8));

                      // Go back and ensure proper state rebuild with navigation bar
                      Navigator.pop(context, true);
                    },
                    icon: Center(
                      child: Text(
                        "Xong",
                        style: TextStyle(
                          color: const CropGridStyle().selectedBoundariesColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCropButton(BuildContext context, Fraction? f) {
    if (controller.preferredCropAspectRatio != null &&
        controller.preferredCropAspectRatio! > 1) {
      f = f?.inverse();
    }

    return Flexible(
      child: TextButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: controller.preferredCropAspectRatio == f?.toDouble()
              ? Colors.grey.shade800
              : null,
          foregroundColor: controller.preferredCropAspectRatio == f?.toDouble()
              ? AppColors.white
              : null,
          textStyle: Theme.of(context).textTheme.bodySmall,
        ),
        onPressed: () => controller.preferredCropAspectRatio = f?.toDouble(),
        child: Text(f == null ? 'free' : '${f.numerator}:${f.denominator}'),
      ),
    );
  }
}
