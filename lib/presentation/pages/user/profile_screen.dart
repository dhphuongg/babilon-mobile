import 'package:babilon/core/application/common/widgets/app_page_widget.dart';
import 'package:babilon/core/application/common/widgets/app_snack_bar.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/presentation/pages/user/cubit/user_cubit.dart';
import 'package:babilon/presentation/pages/user/widgets/profile.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<UserCubit>(context);
    _cubit.loadUserProfile();
    _cubit.loadUserVideos();
    _cubit.loadListLikedVideo();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      buildWhen: (previous, current) =>
          previous.getUserStatus != current.getUserStatus ||
          previous.getListVideoStatus != current.getListVideoStatus ||
          previous.getListLikedVideoStatus != current.getListLikedVideoStatus,
      listenWhen: (previous, current) =>
          previous.getUserStatus != current.getUserStatus ||
          previous.getListVideoStatus != current.getListVideoStatus ||
          previous.getListLikedVideoStatus != current.getListLikedVideoStatus,
      listener: (context, state) {
        if (state.getUserStatus == LoadStatus.FAILURE) {
          AppSnackBar.showError(state.error!);
        }
      },
      builder: (context, state) {
        return AppPageWidget(
          isLoading: state.getUserStatus == LoadStatus.LOADING,
          appbar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.setting);
                },
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
            child: state.user != null &&
                    state.videos != null &&
                    state.likedVideos != null
                ? Profile(
                    cubit: _cubit,
                    user: state.user!,
                    videos: state.videos!,
                    likedVideos: state.likedVideos!,
                  )
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
