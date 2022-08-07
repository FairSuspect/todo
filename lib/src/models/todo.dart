// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

@Freezed()
class Todo with _$Todo {
  @HiveType(typeId: 0, adapterName: "TodoAdapter")
  const factory Todo({
    @HiveField(0) String? id,
    @HiveField(1) required String text,
    @Default(Importance.low) @HiveField(2) Importance importance,
    @JsonKey(fromJson: _dateTimefromJson, toJson: _dateTimeToJson)
    @HiveField(3)
        DateTime? deadline,
    @Default(false) @HiveField(4) bool done,
    @JsonKey(name: 'created_at') @HiveField(5) int? createdAt,
    @JsonKey(name: 'changed_at') @HiveField(6) int? changedAt,
    @JsonKey(name: 'last_updated_by') @HiveField(7) String? lastUpdatedBy,
  }) = _Todo;

  factory Todo.fromJson(Map<String, Object?> json) => _$TodoFromJson(json);
  static List<Todo> listFromJson(List<dynamic> list) =>
      list.map((json) => Todo.fromJson(json)).toList();
}

DateTime? _dateTimefromJson(int? int) =>
    int == null ? null : DateTime.fromMillisecondsSinceEpoch(int);
int? _dateTimeToJson(DateTime? time) => time?.millisecondsSinceEpoch;

@HiveType(typeId: 2, adapterName: "ImportanceAdapter")
enum Importance {
  @JsonValue("low")
  @HiveField(0)
  low("low"),

  @HiveField(1)
  @JsonValue("basic")
  basic("basic"),

  @HiveField(2)
  @JsonValue("important")
  important("important");

  final String importance;
  const Importance(this.importance);
}
