import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class AppVideo extends StatefulWidget {
  final String videoUrl;
  const AppVideo({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<AppVideo> createState() => _AppVideoState();
}

class _AppVideoState extends State<AppVideo>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _vidController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _vidController =
        VideoPlayerController.network(Uri.parse(widget.videoUrl).toString())
          ..initialize().then((_) {
            setState(() {});
          }).catchError((error) {
            print('Failed to initialize video player: $error');
          });

    _vidController.setVolume(0);
    _vidController.setLooping(true);
    _vidController.play();
    _vidController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _vidController.dispose();
  }

  void _togglePlayPause() {
    if (_vidController.value.isPlaying) {
      _vidController.pause();
    } else {
      _vidController.play();
    }
  }

  // pause video when user leaves the screen

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _vidController.value.isInitialized
        ? Container(
            height: MediaQuery.of(context).size.height.h - 180.h,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: AspectRatio(
                    aspectRatio: _vidController.value.aspectRatio,
                    child: VideoPlayer(_vidController),
                  ),
                ),
                if (!_vidController.value.isPlaying)
                  const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 50,
                  )
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
