import 'package:babilon/core/application/common/widgets/app_page_widget.dart';
import 'package:babilon/core/application/common/widgets/app_snack_bar.dart';
import 'package:babilon/core/application/models/response/user/user.entity.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/core/domain/enum/user.dart';
import 'package:babilon/presentation/pages/user/cubit/user_cubit.dart';
import 'package:babilon/presentation/pages/user/widgets/user_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialGraphScreen extends StatefulWidget {
  final UserEntity user;
  final int initialTabIndex;

  const SocialGraphScreen({
    super.key,
    this.initialTabIndex = 0,
    required this.user,
  });

  @override
  State<SocialGraphScreen> createState() => _SocialGraphScreenState();
}

class _SocialGraphScreenState extends State<SocialGraphScreen>
    with SingleTickerProviderStateMixin {
  late UserCubit _cubit;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<UserCubit>(context);
    _cubit.loadSocialGraph(widget.user.id);
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(_loadSocialGraph);
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _cubit.clearSocialGraph();
  //   _cubit.close();
  //   _tabController.dispose();
  //   _tabController.removeListener(_loadSocialGraph);
  // }

  Future<void> _loadSocialGraph() async {
    _cubit.clearSocialGraph();
    await _cubit.loadSocialGraph(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      buildWhen: (previous, current) =>
          previous.getSocialGraphStatus != current.getSocialGraphStatus,
      listenWhen: (previous, current) =>
          previous.getSocialGraphStatus != current.getSocialGraphStatus,
      listener: (context, state) {
        if (state.getSocialGraphStatus == LoadStatus.FAILURE) {
          AppSnackBar.showError(state.error!);
        }
      },
      builder: (context, state) {
        return AppPageWidget(
          isLoading: state.getSocialGraphStatus == LoadStatus.LOADING,
          appbar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.chevron_left_rounded,
                size: 36,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            title: Text(
              widget.user.username,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.black,
              tabs: const <Widget>[
                Tab(text: 'Đã follow'),
                Tab(text: 'Follower'),
                // Tab(text: 'Bạn bè'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              state.followings != null
                  ? _UserList(
                      type: SocialGraphType.following,
                      users: state.followings!,
                      total: state.followings!.length,
                    )
                  : const SizedBox.shrink(),
              state.followers != null
                  ? _UserList(
                      type: SocialGraphType.followers,
                      users: state.followers!,
                      total: state.followers!.length,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }
}

class _UserList extends StatefulWidget {
  final int total;
  final List<UserEntity> users;
  final SocialGraphType type;

  const _UserList({
    Key? key,
    required this.type,
    required this.users,
    required this.total,
  }) : super(key: key);

  @override
  State<_UserList> createState() => _UserListState();
}

class _UserListState extends State<_UserList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.total,
      itemBuilder: (context, index) {
        return UserListItem(user: widget.users[index]);
      },
    );
  }
}
