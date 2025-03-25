import 'package:json_annotation/json_annotation.dart';

part 'array_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseArrayResponse<T, E extends String> {
  final bool success;
  final int statusCode;
  final E? error;
  final List<T>? result;

  factory BaseArrayResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
    E Function(Object?) fromJsonE,
  ) =>
      _$BaseArrayResponseFromJson(json, fromJsonT, fromJsonE);

  Map<String, dynamic> toJson(
          Object? Function(T value) toJsonT, Object? Function(E) toJsonE) =>
      _$BaseArrayResponseToJson(this, toJsonT, toJsonE);

  BaseArrayResponse copyWith({
    final bool? success,
    final int? statusCode,
    final E? error,
    final List<T>? result,
  }) {
    return BaseArrayResponse(
      success: success ?? this.success,
      statusCode: statusCode ?? this.statusCode,
      error: error ?? this.error,
      result: result ?? this.result,
    );
  }

  const BaseArrayResponse({
    required this.success,
    required this.statusCode,
    this.error,
    this.result,
  });
}

typedef ArrayResponse<T> = BaseArrayResponse<T, String>;
