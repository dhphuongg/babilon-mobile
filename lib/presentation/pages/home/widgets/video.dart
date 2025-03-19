import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/presentation/pages/home/widgets/video_side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AppVideo extends StatefulWidget {
  final String videoUrl;
  final String videoId;
  const AppVideo({Key? key, required this.videoUrl, required this.videoId})
      : super(key: key);

  @override
  State<AppVideo> createState() => _AppVideoState();
}

class _AppVideoState extends State<AppVideo>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _vidController;
  bool _isVisible = false;
  bool _showPlayIcon = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _vidController =
        VideoPlayerController.network(Uri.parse(widget.videoUrl).toString())
          ..initialize().then((_) {
            setState(() {});
          }).catchError((error) {
            print('Failed to initialize video player: $error');
          });

    _vidController.setVolume(1.0);
    _vidController.setLooping(true);
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.8) {
      if (!_isVisible) {
        setState(() {
          _isVisible = true;
          _showPlayIcon = false;
        });
        _vidController.seekTo(Duration.zero);
        _vidController.play();
      }
    } else {
      if (_isVisible) {
        setState(() {
          _isVisible = false;
        });
        _vidController.pause();
      }
    }
  }

  @override
  void dispose() {
    _vidController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_vidController.value.isPlaying) {
        _vidController.pause();
        _showPlayIcon = true;
      } else {
        _vidController.play();
        _showPlayIcon = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return VisibilityDetector(
      key: Key(widget.videoId),
      onVisibilityChanged: _handleVisibilityChanged,
      child: Container(
        height: 1.sh - kBottomNavigationBarHeight,
        color: AppColors.black,
        child: _vidController.value.isInitialized
            ? Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: _togglePlayPause,
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      // child: _vidController.value.aspectRatio == 9 / 16
                      // ? SizedBox.expand(
                      //     child: AspectRatio(
                      //       aspectRatio: _vidController.value.aspectRatio,
                      //       child: VideoPlayer(_vidController),
                      //     ),
                      //   )
                      // : AspectRatio(
                      //     aspectRatio: _vidController.value.aspectRatio,
                      //     child: VideoPlayer(_vidController),
                      //   ),
                      child: AspectRatio(
                        aspectRatio: _vidController.value.aspectRatio,
                        child: VideoPlayer(_vidController),
                      )
                    ),
                  ),
                  if (_showPlayIcon)
                    Center(
                      child: GestureDetector(
                        onTap: _togglePlayPause,
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white.withOpacity(0.75),
                          size: 50,
                        ),
                      ),
                    ),
                  const VideoSideButton(),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
