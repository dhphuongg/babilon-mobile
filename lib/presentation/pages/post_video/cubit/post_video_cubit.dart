import 'package:babilon/core/application/models/request/video/post_video.dart';
import 'package:babilon/core/application/models/response/video/video.dart';
import 'package:babilon/core/application/repositories/video_repository.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';

part 'post_video_state.dart';

class PostVideoCubit extends Cubit<PostVideoState> {
  final VideoRepository _videoRepository;

  PostVideoCubit({
    required VideoRepository videoRepository,
  })  : _videoRepository = videoRepository,
        super(PostVideoState());

  Future<void> postVideo(PostVideoRequest body) async {
    emit(state.copyWith(postVideoStatus: LoadStatus.LOADING, error: ''));

    try {
      FormData formData = FormData();
      formData.files.add(
        MapEntry(
          'video',
          await MultipartFile.fromFile(
            body.video,
            filename: body.video.split('/').last,
            contentType: MediaType('video', 'mp4'),
          ),
        ),
      );
      formData.fields.add(MapEntry('title', body.title));
      // if (body.isPrivate != null) {
      //   formData.fields.add(MapEntry('isPrivate', body.isPrivate));
      // }
      // if (body.commentable != null) {
      //   formData.fields.add(MapEntry('commentable', body.commentable));
      // }

      final response = await _videoRepository.postVideo(formData);
      if (response.statusCode == 201) {
        emit(state.copyWith(
          postVideoStatus: LoadStatus.SUCCESS,
          error: '',
          postedVideo: response.data,
        ));
      } else {
        emit(state.copyWith(
          postVideoStatus: LoadStatus.FAILURE,
          error: response.error ?? 'Failed to post video',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        postVideoStatus: LoadStatus.FAILURE,
        error: e.toString(),
      ));
    }
  }
}
