import 'package:babilon/core/application/common/widgets/app_snack_bar.dart';
import 'package:babilon/core/application/common/widgets/button/app_button.dart';
import 'package:babilon/core/application/common/widgets/input/app_text_field.dart';
import 'package:babilon/core/application/models/request/video/post_video.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/presentation/pages/post_video/cubit/post_video_cubit.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostVideoScreen extends StatefulWidget {
  final String videoPath;

  const PostVideoScreen({
    super.key,
    required this.videoPath,
  });

  @override
  State<PostVideoScreen> createState() => _PostVideoScreenState();
}

class _PostVideoScreenState extends State<PostVideoScreen> {
  late PostVideoCubit _postVideoCubit;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  bool _isPrivate = false;
  bool _allowComments = true;

  @override
  void initState() {
    super.initState();
    _postVideoCubit = BlocProvider.of<PostVideoCubit>(context);
  }

  @override
  void dispose() {
    _postVideoCubit.close();
    _titleController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  void _postVideo() {
    if (_formKey.currentState!.validate()) {
      final request = PostVideoRequest(
        title: _titleController.text,
        video: widget.videoPath,
        isPrivate: _isPrivate,
        commentable: _allowComments,
      );

      _postVideoCubit.postVideo(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          'Đăng video',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<PostVideoCubit, PostVideoState>(
          buildWhen: (previous, current) =>
              previous.postVideoStatus != current.postVideoStatus,
          listenWhen: (previous, current) =>
              previous.postVideoStatus != current.postVideoStatus,
          listener: (context, state) {
            if (state.postVideoStatus == LoadStatus.SUCCESS) {
              if (state.postedVideo != null) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteName.userVideos,
                  (route) => route.settings.name == RouteName.app,
                  arguments: {
                    'videos': [state.postedVideo!],
                    'initialVideoIndex': 0,
                  },
                );
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteName.app,
                  (route) => false,
                );
              }
              AppSnackBar.showSuccess('Đăng video thành công');
            } else if (state.postVideoStatus == LoadStatus.FAILURE) {
              AppSnackBar.showError(state.error ?? 'Đăng video thất bại');
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(AppPadding.horizontal),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: 'Tiêu đề',
                      controller: _titleController,
                      hintText: 'Nhập tiêu đề video',
                      isRequired: true,
                    ),
                    SizedBox(height: AppPadding.input),
                    // Privacy Toggle
                    Row(
                      children: [
                        const Text(
                          'Video riêng tư',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: AppColors.black,
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: _isPrivate,
                          onChanged: (value) {
                            setState(() {
                              _isPrivate = value;
                            });
                          },
                        ),
                      ],
                    ),

                    // Comments Toggle
                    Row(
                      children: [
                        const Text(
                          'Cho phép bình luận',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: AppColors.black,
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: _allowComments,
                          onChanged: (value) {
                            setState(() {
                              _allowComments = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Post Button
                    AppButton(
                      disable: state.postVideoStatus == LoadStatus.LOADING,
                      text: 'Đăng',
                      onPressed: _postVideo,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
