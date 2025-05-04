import 'package:babilon/core/application/common/widgets/app_snack_bar.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/presentation/pages/home/cubit/video_cubit.dart';
import 'package:babilon/presentation/pages/home/widgets/video_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<VideoCubit>(context);
    _cubit.getTrendingVideos();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideoCubit, VideoState>(
      buildWhen: (previous, current) =>
          previous.getTrendingVideosStatus != current.getTrendingVideosStatus,
      listenWhen: (previous, current) =>
          previous.getTrendingVideosStatus != current.getTrendingVideosStatus,
      listener: (context, state) {
        if (state.getTrendingVideosStatus == LoadStatus.FAILURE) {
          AppSnackBar.showError(state.error!);
        }
      },
      builder: (context, state) {
        return state.videos != null && state.videos!.isNotEmpty
            ? VideoList(
                videos: state.videos!,
                onPullDownRefresh: () => _cubit.getTrendingVideos(
                  isRefresh: true,
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
