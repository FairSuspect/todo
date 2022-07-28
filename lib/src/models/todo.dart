// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// required: associates our `main.dart` with the code generated by Freezed
part 'todo.freezed.dart';
// optional: Since our Person class is serializable, we must add this line.
// But if Person was not serializable, we could skip it.
part 'todo.g.dart';

@Freezed()
class Todo with _$Todo {
  const factory Todo({
    String? id,
    required String text,
    @Default(Importance.low) Importance importance,
    @Default(false) bool done,
    @JsonKey(name: 'created_at') int? createdAt,
    @JsonKey(name: 'changed_at') int? changedAt,
    @JsonKey(name: 'last_updated_by') String? lastUpdatedBy,
  }) = _Todo;

  factory Todo.fromJson(Map<String, Object?> json) => _$TodoFromJson(json);
  static List<Todo> listFromJson(List<dynamic> list) =>
      list.map((json) => Todo.fromJson(json)).toList();
}

enum Importance {
  @JsonValue("low")
  low,
  @JsonValue("basic")
  basic,
  @JsonValue("inportant")
  important;
}
