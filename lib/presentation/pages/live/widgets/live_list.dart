import 'package:babilon/core/application/models/response/live/live.dart';
import 'package:babilon/presentation/pages/live/widgets/live.dart';
import 'package:flutter/material.dart';

class LiveList extends StatefulWidget {
  final List<Live> lives;
  final int initialIndex;

  const LiveList({
    super.key,
    required this.lives,
    this.initialIndex = 0,
  });

  @override
  State<LiveList> createState() => _LiveListState();
}

class _LiveListState extends State<LiveList> {
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
    return _buildPageView();
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: widget.lives.length,
      itemBuilder: (context, index) {
        return AppLive(
          live: widget.lives[index],
        );
      },
    );
  }
}
