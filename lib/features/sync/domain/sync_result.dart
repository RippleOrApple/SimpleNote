class SyncResult {
  const SyncResult({
    required this.success,
    this.notesCreated = 0,
    this.notesUpdated = 0,
    this.notesDeleted = 0,
    this.todosCreated = 0,
    this.todosUpdated = 0,
    this.todosDeleted = 0,
    this.errorMessage,
  });

  final bool success;
  final int notesCreated;
  final int notesUpdated;
  final int notesDeleted;
  final int todosCreated;
  final int todosUpdated;
  final int todosDeleted;
  final String? errorMessage;

  Map<String, Object?> toJson() => {
        'success': success,
        'notesCreated': notesCreated,
        'notesUpdated': notesUpdated,
        'notesDeleted': notesDeleted,
        'todosCreated': todosCreated,
        'todosUpdated': todosUpdated,
        'todosDeleted': todosDeleted,
        'errorMessage': errorMessage,
      };

  factory SyncResult.fromJson(Map<String, Object?> json) {
    return SyncResult(
      success: json['success']! as bool,
      notesCreated: json['notesCreated'] as int? ?? 0,
      notesUpdated: json['notesUpdated'] as int? ?? 0,
      notesDeleted: json['notesDeleted'] as int? ?? 0,
      todosCreated: json['todosCreated'] as int? ?? 0,
      todosUpdated: json['todosUpdated'] as int? ?? 0,
      todosDeleted: json['todosDeleted'] as int? ?? 0,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}
