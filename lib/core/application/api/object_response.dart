import 'package:json_annotation/json_annotation.dart';

part 'object_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseObjectResponse<T, E extends String> {
  final bool success;
  final int statusCode;
  final T? data;
  final E? error;

  factory BaseObjectResponse.fromJson(Map<String, dynamic> json,
          T Function(Object? json) fromJsonT, E Function(Object?) fromJsonE) =>
      _$BaseObjectResponseFromJson(json, fromJsonT, fromJsonE);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT,
          Object? Function(E value) toJsonE) =>
      _$BaseObjectResponseToJson(this, toJsonT, toJsonE);

  BaseObjectResponse copyWith({
    final bool? success,
    final int? statusCode,
    final E? error,
    final T? data,
  }) {
    return BaseObjectResponse(
      success: success ?? this.success,
      statusCode: statusCode ?? this.statusCode,
      error: error ?? this.error,
      data: data ?? this.data,
    );
  }

  const BaseObjectResponse({
    required this.statusCode,
    required this.success,
    E? error,
    this.data,
  }) : error = error ?? '' as E;
}

typedef ObjectResponse<T> = BaseObjectResponse<T, String>;
