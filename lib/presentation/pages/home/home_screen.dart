import 'package:babilon/presentation/pages/home/widgets/video.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> videoUrls = [
    'https://www.viivue.com/wp-content/uploads/2022/05/ViiVue-ShowReel-thumbnail-1.mp4',
    'https://www.viivue.com/wp-content/uploads/2022/05/ViiVue-ShowReel-thumbnail-1.mp4',
    'https://www.viivue.com/wp-content/uploads/2022/05/ViiVue-ShowReel-thumbnail-1.mp4',
    // 'https://res.cloudinary.com/dhp1xcch9/video/upload/v1742291900/test.mp4',
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: videoUrls.length,
      itemBuilder: (context, index) {
        return AppVideo(
          videoUrl: videoUrls[index],
          videoId: 'video_$index',
        );
      },
    );
  }
}
