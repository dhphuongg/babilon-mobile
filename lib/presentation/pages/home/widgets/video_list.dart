import 'package:babilon/core/application/models/response/video/video.dart';
import 'package:babilon/presentation/pages/home/widgets/video.dart';
import 'package:flutter/material.dart';

class VideoList extends StatefulWidget {
  final List<Video> videos;

  const VideoList({super.key, required this.videos});

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
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
