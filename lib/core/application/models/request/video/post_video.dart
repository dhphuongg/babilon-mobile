class PostVideoRequest {
  String title;
  String video;
  bool? isPrivate;
  bool? commentable;

  PostVideoRequest({
    required this.title,
    required this.video,
    this.isPrivate,
    this.commentable,
  });
}
