import 'package:babilon/presentation/pages/home/widgets/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String url1 =
      'https://www.viivue.com/wp-content/uploads/2022/05/ViiVue-ShowReel-thumbnail-1.mp4';
  final String url2 =
      'https://res.cloudinary.com/dhp1xcch9/video/upload/v1742291900/test.mp4';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return AppVideo(videoUrl: url2);
      },
    );
  }
}
