import 'package:json_annotation/json_annotation.dart';

import 'error_response.dart';

part 'array_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ArrayResponse<T> {
  final bool? success;
  final ErrorResponse? error;
  final List<T>? result;

  factory ArrayResponse.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$ArrayResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ArrayResponseToJson(this, toJsonT);

  ArrayResponse copyWith({
    final bool? success,
    final ErrorResponse? error,
    final List<T>? result,
  }) {
    return ArrayResponse(
      success: success ?? this.success,
      error: error ?? this.error,
      result: result ?? this.result,
    );
  }

  const ArrayResponse({
    this.success,
    this.error,
    this.result,
  });
}
