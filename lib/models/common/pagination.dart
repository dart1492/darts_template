// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

//TODO: ADJUST PAGINATION NAMES TO THE SPECIFICS OF THE PROJECT
class PaginationModel {
  int limit;
  int offset;
  PaginationModel({
    required this.limit,
    required this.offset,
  });

  PaginationModel copyWith({
    int? limit,
    int? offset,
  }) {
    return PaginationModel(
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  factory PaginationModel.initial() {
    return PaginationModel(limit: 8, offset: 0);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
  }

  factory PaginationModel.fromMap(Map<String, dynamic> map) {
    return PaginationModel(
      limit: map['limit'] as int,
      offset: map['offset'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaginationModel.fromJson(String source) =>
      PaginationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
