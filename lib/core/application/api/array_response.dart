import 'package:json_annotation/json_annotation.dart';

part 'array_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ArrayResponse<T> {
  final List<T>? items;
  final int? total;
  final int? page;
  final int? limit;

  factory ArrayResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ArrayResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(
    Object? Function(T value) toJsonT,
  ) =>
      _$ArrayResponseToJson(
        this,
        toJsonT,
      );

  ArrayResponse copyWith({
    final List<T>? items,
    final int? total,
    final int? page,
    final int? limit,
  }) {
    return ArrayResponse(
      items: items ?? this.items,
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  const ArrayResponse({
    this.items,
    this.total,
    this.page,
    this.limit,
  });
}
