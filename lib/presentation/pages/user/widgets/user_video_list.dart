import 'package:babilon/core/application/models/response/video/video.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserVideoList extends StatefulWidget {
  final List<Video> videos;

  const UserVideoList({super.key, required this.videos});

  @override
  State<UserVideoList> createState() => _UserVideoListState();
}

class _UserVideoListState extends State<UserVideoList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.w,
        childAspectRatio: 9 / 16,
      ),
      itemCount: widget.videos.length,
      itemBuilder: (context, index) {
        final video = widget.videos[index];
        return _buildVideoItem(video);
      },
    );
  }

  Widget _buildVideoItem(Video video) {
    return GestureDetector(
      onTap: () {
        // Get the index of the tapped video
        final videoIndex = widget.videos.indexOf(video);

        // Navigate to user videos screen
        Navigator.of(context).pushNamed(
          RouteName.userVideos,
          arguments: {
            'videos': widget.videos,
            'initialVideoIndex': videoIndex,
          },
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2.r),
            child: CachedNetworkImage(
              imageUrl: video.thumbnail,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.error),
              ),
            ),
          ),
          // Positioned(
          //   bottom: 4.r,
          //   right: 4.r,
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(2.r),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(0.2),
          //           blurRadius: 10,
          //           offset: const Offset(0, -2),
          //         ),
          //         BoxShadow(
          //           color: Colors.black.withOpacity(0.2),
          //           blurRadius: 10,
          //           offset: const Offset(0, 2),
          //         ),
          //       ],
          //     ),
          //     child: Text(
          //       video.viewsCount.toString(),
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 12.sp,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
