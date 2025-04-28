import 'dart:io';

import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/presentation/pages/edit_video/widgets/crop_page.dart';
import 'package:flutter/material.dart';
import 'package:video_editor/video_editor.dart';

class EditVideoScreen extends StatefulWidget {
  const EditVideoScreen({
    super.key,
    required this.videoPath,
    required this.maxDuration,
  });

  final String videoPath;
  final int maxDuration;

  @override
  State<EditVideoScreen> createState() => _EditVideoScreenState();
}

class _EditVideoScreenState extends State<EditVideoScreen> {
  final _exportingProgress = ValueNotifier<double>(0.0);
  final double height = 60;

  late final VideoEditorController _controller = VideoEditorController.file(
    File(widget.videoPath),
    minDuration: const Duration(seconds: 1),
    maxDuration: Duration(seconds: widget.maxDuration),
  );

  @override
  void initState() {
    super.initState();
    _controller
        .initialize(aspectRatio: 9 / 16)
        .then((_) => setState(() {}))
        .catchError((error) {
      // handle minumum duration bigger than video duration error
      Navigator.pop(context);
    }, test: (e) => e is VideoMinDurationError);
  }

  @override
  void dispose() async {
    _exportingProgress.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_controller.isTrimmed ||
        _controller.isRotated ||
        _controller.isCropping) {
      final shouldPop = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Huỷ bỏ chỉnh sửa'),
            content: const Text(
              'Bạn có chắc chắn muốn huỷ bỏ chỉnh sửa không? Tất cả thay đổi sẽ không được lưu.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Huỷ bỏ chỉnh sửa',
                  style: TextStyle(color: AppColors.red),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Tiếp tục'),
              ),
            ],
          );
        },
      );

      return shouldPop ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _controller.initialized
            ? SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        _topNavBar(),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CropGridViewer.preview(
                                      controller: _controller,
                                    ),
                                    AnimatedBuilder(
                                      animation: _controller.video,
                                      builder: (_, __) => AnimatedOpacity(
                                        opacity: _controller.isPlaying ? 0 : 1,
                                        duration: kThemeAnimationDuration,
                                        child: GestureDetector(
                                          onTap: _controller.video.play,
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              color: AppColors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.play_arrow,
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: _trimSlider(),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _topNavBar() {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: IconButton(
              onPressed: () async {
                // Check the same conditions as in _onWillPop
                final shouldPop = await _onWillPop();
                if (shouldPop) {
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.chevron_left_outlined),
              tooltip: 'Leave editor',
              style: ButtonStyle(
                iconColor: MaterialStateProperty.all<Color>(
                  AppColors.white,
                ),
              ),
            ),
          ),
          const VerticalDivider(endIndent: 22, indent: 22),
          Expanded(
            child: IconButton(
              onPressed: () => _controller.rotate90Degrees(
                RotateDirection.left,
              ),
              icon: const Icon(Icons.rotate_left),
              tooltip: 'Rotate unclockwise',
              style: ButtonStyle(
                iconColor: MaterialStateProperty.all<Color>(
                  AppColors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () => _controller.rotate90Degrees(
                RotateDirection.right,
              ),
              icon: const Icon(Icons.rotate_right),
              tooltip: 'Rotate clockwise',
              style: ButtonStyle(
                iconColor: MaterialStateProperty.all<Color>(
                  AppColors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute<bool>(
                    builder: (context) => CropPage(controller: _controller),
                  ),
                );
                // Force rebuild if returning from crop page
                if (result == true) {
                  setState(() {});
                }
              },
              icon: const Icon(Icons.crop),
              tooltip: 'Open crop screen',
              style: ButtonStyle(
                iconColor: MaterialStateProperty.all<Color>(
                  AppColors.white,
                ),
              ),
            ),
          ),
          const VerticalDivider(endIndent: 22, indent: 22),
          Expanded(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.save),
              tooltip: 'Save',
              style: ButtonStyle(
                iconColor: MaterialStateProperty.all<Color>(
                  AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatter(Duration duration) => [
        duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
        duration.inSeconds.remainder(60).toString().padLeft(2, '0')
      ].join(":");

  List<Widget> _trimSlider() {
    return [
      AnimatedBuilder(
        animation: Listenable.merge([
          _controller,
          _controller.video,
        ]),
        builder: (_, __) {
          final int duration = _controller.videoDuration.inSeconds;
          final double pos = _controller.trimPosition * duration;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: height / 4),
            child: Row(children: [
              Text(
                formatter(
                  Duration(seconds: pos.toInt()),
                ),
                style: const TextStyle(color: AppColors.white),
              ),
              const Expanded(child: SizedBox()),
              AnimatedOpacity(
                opacity: _controller.isTrimming ? 1 : 0,
                duration: kThemeAnimationDuration,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    formatter(_controller.startTrim),
                    style: const TextStyle(color: AppColors.white),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    formatter(_controller.endTrim),
                    style: const TextStyle(color: AppColors.white),
                  ),
                ]),
              ),
            ]),
          );
        },
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: height / 4),
        child: TrimSlider(
          controller: _controller,
          height: height,
          horizontalMargin: height / 4,
          child: TrimTimeline(
            controller: _controller,
            padding: const EdgeInsets.only(top: 10),
            textStyle: const TextStyle(
              color: AppColors.white,
            ),
          ),
        ),
      )
    ];
  }
}
