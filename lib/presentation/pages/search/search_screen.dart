import 'package:babilon/core/application/common/widgets/app_page_widget.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/presentation/pages/search/cubit/search_cubit.dart';
import 'package:babilon/presentation/pages/user/widgets/profile_avatar.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SearchTab { video, user }

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late SearchCubit _cubit;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  bool _showClear = false;

  @override
  void initState() {
    _cubit = BlocProvider.of<SearchCubit>(context);
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _showClear = _searchController.text.isNotEmpty;
    });
  }

  void _clearSearch() {
    setState(() {
      _cubit.clearSearchResult();
      _searchController.clear();
      _showClear = false;
      FocusScope.of(context).requestFocus();
    });
  }

  Future<void> _onSearch(String query) async {
    if (_formKey.currentState == null ||
        _formKey.currentState!.validate() == false) {
      return;
    }

    await _cubit.searchVideos(query.trim());
    await _cubit.searchUsers(query.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AppPageWidget(
      appbar: AppBar(
        backgroundColor: AppColors.white,
        title: Form(
          key: _formKey,
          child: TextFormField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm',
              border: InputBorder.none,
              suffixIcon: _showClear
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _clearSearch,
                    )
                  : IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _onSearch(_searchController.text),
                    ),
            ),
            onFieldSubmitted: _onSearch,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Video'),
            Tab(text: 'Người dùng'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVideoGrid(),
          _buildUserList(),
        ],
      ),
    );
  }

  Widget _buildVideoGrid() {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state.getVideosStatus == null ||
            state.getVideosStatus == LoadStatus.INITIAL) {
          return Container();
        }
        if (state.getVideosStatus == LoadStatus.LOADING) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.videos?.isEmpty ?? true) {
          return const Center(child: Text('Không có kết quả'));
        }

        return GridView.builder(
          padding: EdgeInsets.all(AppPadding.horizontal),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisExtent: 430,
          ),
          itemCount: state.videos?.length ?? 0,
          itemBuilder: (context, index) {
            final video = state.videos![index];
            return GestureDetector(
              onTap: () {
                // Navigate to user videos screen
                Navigator.of(context).pushNamed(
                  RouteName.userVideos,
                  arguments: {
                    'videos': state.videos,
                    'initialVideoIndex': index,
                  },
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 9 / 16,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2.r),
                      child: Container(
                        color: Colors.grey[300],
                        child: CachedNetworkImage(
                          imageUrl: video.thumbnail,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          placeholder: (context, url) => const SizedBox(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ProfileAvatar(
                        userId: video.user.id,
                        isLiving: video.user.isLiving,
                        avatar: video.user.avatar,
                        size: 15,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          video.user.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Text(
                        video.likesCount.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Icon(Icons.favorite, size: 12),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUserList() {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state.getUsersStatus == null ||
            state.getUsersStatus == LoadStatus.INITIAL) {
          return Container();
        }
        if (state.getUsersStatus == LoadStatus.LOADING) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.users?.isEmpty ?? true) {
          return const Center(child: Text('Không có kết quả'));
        }

        return ListView.separated(
          padding: EdgeInsets.all(AppPadding.horizontal),
          itemCount: state.users?.length ?? 0,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final user = state.users![index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RouteName.user,
                  arguments: user.id,
                );
              },
              child: Row(
                children: [
                  ProfileAvatar(
                    userId: user.id,
                    isLiving: user.isLiving,
                    avatar: user.avatar,
                    size: 25.r,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.fullName,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            )),
                        Text(user.username,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.gray,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
