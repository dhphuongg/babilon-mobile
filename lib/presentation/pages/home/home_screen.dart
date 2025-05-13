import 'package:babilon/core/application/models/response/video/video.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/presentation/pages/home/cubit/video_cubit.dart';
import 'package:babilon/presentation/pages/home/widgets/video_list.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  }

  Widget _buildNavigationBar() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16.w,
      right: 16.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(RouteName.liveTrending);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5],
                    ),
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.live_tv,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
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
                _buildTab("Đang follow", TabType.following, () async {
                  await _cubit.getListVideoOfFollowing();
                  setState(() {
                    _selectedView = TabType.following;
                  });
                }),
              ],
            ),
          ),
          Expanded(flex: 1, child: Container()),
        ],
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
