import 'package:babilon/core/application/models/response/video/video.dart';
import 'package:babilon/presentation/pages/home/widgets/video.dart';
import 'package:flutter/material.dart';

class VideoList extends StatefulWidget {
  final List<Video> videos;
  final int initialIndex;

  const VideoList({
    super.key,
    required this.videos,
    this.initialIndex = 0,
  });

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: widget.videos.length,
      itemBuilder: (context, index) {
        return AppVideo(
          video: widget.videos[index],
        );
      },
    );
  }
}
