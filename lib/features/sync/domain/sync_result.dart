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
}
