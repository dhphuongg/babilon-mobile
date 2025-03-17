import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  int? userId;
  String? companyName;
  int? projectId;
  int? prospectId;
  String? firstName;
  String? lastName;

  UserProfile({
    this.userId,
    this.companyName,
    this.projectId,
    this.prospectId,
    this.firstName,
    this.lastName,
  });

  UserProfile copyWith({
    int? userId,
    String? companyName,
    int? projectId,
    int? prospectId,
    String? firstName,
    String? lastName,
  }) =>
      UserProfile(
        userId: userId ?? this.userId,
        companyName: companyName ?? this.companyName,
        projectId: projectId ?? this.projectId,
        prospectId: prospectId ?? this.prospectId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
      );

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        userId: json["userId"],
        companyName: json["companyName"],
        projectId: json["projectId"],
        prospectId: json["prospectId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "companyName": companyName,
        "projectId": projectId,
        "prospectId": prospectId,
        "firstName": firstName,
        "lastName": lastName,
      };
}
