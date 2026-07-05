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
}
