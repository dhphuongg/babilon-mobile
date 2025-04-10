import 'package:babilon/core/application/common/widgets/app_page_widget.dart';
import 'package:babilon/core/application/common/widgets/app_snack_bar.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/presentation/pages/user/cubit/user_cubit.dart';
import 'package:babilon/presentation/pages/user/widgets/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserScreen extends StatefulWidget {
  final String userId;

  const UserScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late UserCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<UserCubit>(context);
    _cubit.getUserById(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      buildWhen: (previous, current) =>
          previous.getUserStatus != current.getUserStatus,
      listenWhen: (previous, current) =>
          previous.getUserStatus != current.getUserStatus,
      listener: (context, state) {
        if (state.getUserStatus == LoadStatus.FAILURE) {
          AppSnackBar.showError(state.error!);
        }
      },
      builder: (context, state) {
        return AppPageWidget(
          isLoading: state.getUserStatus == LoadStatus.LOADING,
          appbar: AppBar(
            backgroundColor: AppColors.white,
            leading: IconButton(
              icon: const Icon(
                Icons.chevron_left_rounded,
                size: 36,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.horizontal,
              ),
              child: _cubit.state.user != null
                  ? Profile(cubit: _cubit, user: _cubit.state.user!)
                  : const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }
}
