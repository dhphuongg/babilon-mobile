import 'package:babilon/core/application/models/response/video/video.dart';
import 'package:babilon/presentation/pages/home/widgets/video_list.dart';
import 'package:flutter/material.dart';

class UserVideosScreen extends StatefulWidget {
  final List<Video> videos;
  final int initialVideoIndex;

  const UserVideosScreen({
    super.key,
    required this.videos,
    this.initialVideoIndex = 0,
  });

  @override
  State<UserVideosScreen> createState() => _UserVideosScreenState();
}

class _UserVideosScreenState extends State<UserVideosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            VideoList(
              videos: widget.videos,
              initialIndex: widget.initialVideoIndex,
            ),
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
