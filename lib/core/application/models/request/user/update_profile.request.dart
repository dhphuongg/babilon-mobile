class UpdateProfileRequest {
  String? username;
  String? fullName;
  String? signature;
  String? avatar;

  UpdateProfileRequest({
    this.username,
    this.fullName,
    this.signature,
    this.avatar,
  });

  // factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
  //     _$UpdateProfileRequestFromJson(json);

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = {};
  //   if (username != null && username!.isNotEmpty) {
  //     data['username'] = username;
  //   }
  //   if (fullName != null && fullName!.isNotEmpty) {
  //     data['fullName'] = fullName;
  //   }
  //   if (signature != null && signature!.isNotEmpty) {
  //     data['signature'] = signature;
  //   }
  //   if (avatar != null && avatar!.isNotEmpty) {
  //     data['avatar'] = avatar;
  //   }
  //   return data;
  // }
}
