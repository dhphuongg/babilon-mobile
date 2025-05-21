import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/presentation/pages/live/cubit/live_cubit.dart';
import 'package:babilon/presentation/pages/live/widgets/live_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveTrendingScreen extends StatefulWidget {
  const LiveTrendingScreen({super.key});

  @override
  State<LiveTrendingScreen> createState() => _LiveTrendingScreenState();
}

class _LiveTrendingScreenState extends State<LiveTrendingScreen> {
  late LiveCubit _cubit;

  @override
  void initState() {
    _cubit = BlocProvider.of<LiveCubit>(context);
    _cubit.getLiveTrending();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: BlocConsumer<LiveCubit, LiveState>(
          listenWhen: (previous, current) =>
              previous.getLiveTrendingStatus != current.getLiveTrendingStatus,
          buildWhen: (previous, current) =>
              previous.getLiveTrendingStatus != current.getLiveTrendingStatus,
          listener: (context, state) {
            if (state.getLiveTrendingStatus == LoadStatus.SUCCESS) {}
          },
          builder: (context, state) {
            return Stack(
              children: [
                state.liveTrending != null && state.liveTrending!.isNotEmpty
                    ? LiveList(
                        lives: state.liveTrending!,
                        initialIndex: 0,
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
