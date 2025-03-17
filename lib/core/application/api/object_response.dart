import 'package:json_annotation/json_annotation.dart';

import 'error_response.dart';

part 'object_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ObjectResponse<T> {
  final bool? success;
  final ErrorResponse? error;
  final T? result;

  factory ObjectResponse.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$ObjectResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ObjectResponseToJson(this, toJsonT);

  ObjectResponse copyWith({
    final bool? success,
    final ErrorResponse? error,
    final T? result,
  }) {
    return ObjectResponse(
      success: success ?? this.success,
      error: error ?? this.error,
      result: result ?? this.result,
    );
  }

  const ObjectResponse({
    this.success,
    this.error,
    this.result,
  });
}
