import 'package:babilon/core/application/models/response/video/video.dart';
import 'package:babilon/presentation/pages/home/widgets/video.dart';
import 'package:flutter/material.dart';

class VideoList extends StatefulWidget {
  final List<Video> videos;
  final int initialIndex;
  final Function? onPullDownRefresh;

  const VideoList({
    super.key,
    required this.videos,
    this.initialIndex = 0,
    this.onPullDownRefresh,
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
    // Only enable pull-to-refresh when on the first page
    int currentPage =
        _pageController.hasClients ? _pageController.page?.round() ?? 0 : 0;
    if (currentPage == 0 && widget.onPullDownRefresh != null) {
      return RefreshIndicator(
        onRefresh: () async {
          if (widget.onPullDownRefresh != null) {
            await widget.onPullDownRefresh!();
          }
        },
        child: _buildPageView(),
      );
    }

    return _buildPageView();
  }

  Widget _buildPageView() {
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
