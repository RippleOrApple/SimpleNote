import '../../notes/domain/note.dart';
import '../../settings/domain/theme_scheme.dart';
import '../../tags/domain/tag.dart';
import '../../todos/domain/todo.dart';
import 'device_info.dart';

class SyncSnapshot {
  const SyncSnapshot({
    required this.device,
    required this.exportedAt,
    required this.notes,
    required this.todos,
    required this.tags,
    required this.themeSchemes,
  });

  final DeviceInfo device;
  final int exportedAt;
  final List<Note> notes;
  final List<Todo> todos;
  final List<Tag> tags;
  final List<AppThemeScheme> themeSchemes;

  Map<String, Object?> toJson() => {
        'device': device.toJson(),
        'exportedAt': exportedAt,
        'notes': notes.map((note) => note.toJson()).toList(),
        'todos': todos.map((todo) => todo.toJson()).toList(),
        'tags': tags.map((tag) => tag.toJson()).toList(),
        'themeSchemes':
            themeSchemes.map((themeScheme) => themeScheme.toJson()).toList(),
      };

  factory SyncSnapshot.fromJson(Map<String, Object?> json) {
    return SyncSnapshot(
      device: DeviceInfo.fromJson(
        Map<String, Object?>.from(json['device']! as Map),
      ),
      exportedAt: json['exportedAt']! as int,
      notes: _listOfMaps(json['notes'])
          .map((note) => Note.fromJson(note))
          .toList(),
      todos: _listOfMaps(json['todos'])
          .map((todo) => Todo.fromJson(todo))
          .toList(),
      tags: _listOfMaps(json['tags']).map((tag) => Tag.fromJson(tag)).toList(),
      themeSchemes: _listOfMaps(json['themeSchemes'])
          .map((themeScheme) => AppThemeScheme.fromJson(themeScheme))
          .toList(),
    );
  }
}

List<Map<String, Object?>> _listOfMaps(Object? value) {
  return (value as List? ?? const [])
      .map((item) => Map<String, Object?>.from(item as Map))
      .toList();
}
