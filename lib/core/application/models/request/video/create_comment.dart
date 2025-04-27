class CreateComment {
  final String comment;

  const CreateComment({
    required this.comment,
  });

  factory CreateComment.fromJson(Map<String, dynamic> json) {
    return CreateComment(
      comment: json['comment'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment': comment,
    };
  }
}
