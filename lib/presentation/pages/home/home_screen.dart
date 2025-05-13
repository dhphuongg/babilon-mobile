import 'package:babilon/core/application/models/response/video/video.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/presentation/pages/home/cubit/video_cubit.dart';
import 'package:babilon/presentation/pages/home/widgets/video_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum TabType { trending, following }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoCubit _cubit;
  TabType _selectedView = TabType.trending;
  List<Video> _trendingVideos = [];
  List<Video> _followingVideos = [];

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<VideoCubit>(context);
    _cubit.getTrendingVideos();
    _cubit.getListVideoOfFollowing();
  }

  Widget _buildNavigationBar() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTab("Đề xuất", TabType.trending, () {
                setState(() {
                  _selectedView = TabType.trending;
                });
              }),
              const SizedBox(width: 16),
              _buildTab("Đang follow", TabType.following, () {
                setState(() {
                  _selectedView = TabType.following;
                });
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String text, TabType type, Function() onTap) {
    final isSelected = _selectedView == type;
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: BlocConsumer<VideoCubit, VideoState>(
            listenWhen: (previous, current) =>
                previous.getTrendingVideosStatus !=
                    current.getTrendingVideosStatus ||
                previous.getVideoOfFollowingStatus !=
                    current.getVideoOfFollowingStatus,
            buildWhen: (previous, current) =>
                previous.getTrendingVideosStatus !=
                    current.getTrendingVideosStatus ||
                previous.getVideoOfFollowingStatus !=
                    current.getVideoOfFollowingStatus,
            listener: (context, state) {
              if (state.getTrendingVideosStatus == LoadStatus.SUCCESS) {
                _trendingVideos = state.videos ?? [];
              }
              if (state.getVideoOfFollowingStatus == LoadStatus.SUCCESS) {
                _followingVideos = state.videoOfFollowing ?? [];
              }
            },
            builder: (context, state) {
              return _selectedView == TabType.trending
                  ? _buildListVideos(_trendingVideos)
                  : _buildListVideos(_followingVideos);
            },
          ),
        ),
        _buildNavigationBar(),
      ],
    );
  }

  Widget _buildListVideos(List<Video> videos) {
    return videos.isNotEmpty
        ? VideoList(
            videos: videos,
            onPullDownRefresh: () => _cubit.getTrendingVideos(
              isRefresh: true,
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
