import 'package:babilon/core/application/models/response/video/comment.dart';
import 'package:babilon/core/application/models/response/video/video.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/core/domain/utils/date.dart';
import 'package:babilon/presentation/pages/home/cubit/video_cubit.dart';
import 'package:babilon/presentation/pages/user/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentInput extends StatefulWidget {
  final String avatar;
  final String videoId;
  final VideoCubit videoCubit;

  const CommentInput({
    Key? key,
    required this.avatar,
    required this.videoId,
    required this.videoCubit,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  late TextEditingController _commentController;
  late FocusNode _focusNode;

  Future<void> _submitComment(String comment) async {
    _commentController.clear();
    _focusNode.unfocus(); // Đóng bàn phím sau khi gửi bình luận
    Navigator.pop(context); // Đóng bottom sheet sau khi gửi bình luận
    await widget.videoCubit.createComment(widget.videoId, comment);
    await widget.videoCubit.getCommentsByVideoId(widget.videoId);
  }

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _focusNode = FocusNode();
    // Auto focus khi widget được khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.only(
          left: AppPadding.horizontal,
          right: AppPadding.horizontal,
          top: AppPadding.vertical,
          bottom: 8.h + MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
        ),
        child: Row(
          children: [
            ProfileAvatar(
              avatar: widget.avatar,
              size: 20.r,
            ),
            SizedBox(width: 8.w),
            // Text field
            Expanded(
              child: TextField(
                controller: _commentController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Thêm bình luận...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.1),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppPadding.horizontal,
                    vertical: 8.h,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.newline,
              ),
            ),
            SizedBox(width: 8.w),
            // Send button
            GestureDetector(
              onTap: () {
                final String commentText = _commentController.text.trim();
                if (commentText.isNotEmpty) {
                  _submitComment(commentText);
                }
              },
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.main,
                ),
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20.r,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoComments extends StatefulWidget {
  final Video video;

  const VideoComments({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  State<VideoComments> createState() => _VideoCommentsState();
}

class _VideoCommentsState extends State<VideoComments> {
  late TextEditingController _commentController;
  late VideoCubit _videoCubit;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _videoCubit = BlocProvider.of<VideoCubit>(context);
    _videoCubit.getCommentsByVideoId(widget.video.id);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          // Header with comment count and close button
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppPadding.vertical,
              horizontal: AppPadding.horizontal,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bình luận',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    child: Icon(
                      Icons.close,
                      size: 24.r,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Comment list
          Expanded(child: _buildCommentList(ScrollController())),

          // Comment input
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: AppColors.transparent,
                useSafeArea: true,
                isDismissible: true,
                enableDrag: true,
                builder: (context) {
                  return CommentInput(
                    videoId: widget.video.id,
                    videoCubit: _videoCubit,
                    avatar:
                        widget.video.user.avatar ?? 'https://picsum.photos/200',
                  );
                },
              );
            },
            child: Container(
                padding: EdgeInsets.only(
                  left: AppPadding.horizontal,
                  right: AppPadding.horizontal,
                  top: 8.h,
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProfileAvatar(
                      avatar: widget.video.user.avatar ??
                          'https://picsum.photos/200',
                      size: 20.r,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppPadding.horizontal,
                          vertical: 8.h,
                        ),
                        child: const Text(
                          'Thêm bình luận...',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  ],
                )),
          ),

          // Add padding for bottom inset (keyboard)
          SizedBox(
            height: 8.h + MediaQuery.of(context).viewInsets.bottom,
          ),
        ],
      ),
    );
  }

  Widget _buildCommentList(ScrollController scrollController) {
    return BlocBuilder<VideoCubit, VideoState>(
      bloc: _videoCubit,
      buildWhen: (previous, current) =>
          previous.getCommentsStatus != current.getCommentsStatus,
      builder: (context, state) {
        if (state.getCommentsStatus == LoadStatus.LOADING) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.getCommentsStatus == LoadStatus.FAILURE) {
          return const Center(
            child: Text(
              'Có lỗi xảy ra, vui lòng thử lại sau',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (state.comments == null || state.comments!.isEmpty) {
          return const Center(
            child: Text(
              'Chưa có bình luận nào',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          controller: scrollController,
          padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
          itemCount: state.comments!.length,
          itemBuilder: (context, index) {
            final comment = state.comments![index];
            return _buildCommentItem(comment);
          },
        );
      },
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppPadding.vertical),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar
          ProfileAvatar(
            avatar: comment.user.avatar ?? 'https://picsum.photos/200',
            size: 18.r,
          ),
          SizedBox(width: 12.w),

          // Comment content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username
                Text(
                  comment.user.username,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),

                // Comment text
                Text(
                  comment.comment,
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 4.h),

                // Timestamp
                Text(
                  getTimeAgo(comment.createdAt),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
