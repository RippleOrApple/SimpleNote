import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/id_generator.dart';
import '../../../core/utils/time.dart';
import '../../tags/data/tags_repository.dart';
import '../../tags/domain/tag.dart';
import '../data/notes_repository.dart';
import '../domain/note.dart';

final notesControllerProvider =
    AsyncNotifierProvider<NotesController, NotesState>(NotesController.new);

class NotesState {
  const NotesState({
    required this.notes,
    required this.tags,
    required this.tagIdsByNoteId,
    this.selectedNoteId,
    this.searchQuery = '',
    this.selectedTagId,
    this.previewMode = false,
  });

  final List<Note> notes;
  final List<Tag> tags;
  final Map<String, List<String>> tagIdsByNoteId;
  final String? selectedNoteId;
  final String searchQuery;
  final String? selectedTagId;
  final bool previewMode;

  Note? get selectedNote {
    if (selectedNoteId == null) {
      return null;
    }
    for (final note in notes) {
      if (note.id == selectedNoteId) {
        return note;
      }
    }
    return null;
  }

  List<String> tagIdsFor(String noteId) => tagIdsByNoteId[noteId] ?? const [];

  NotesState copyWith({
    List<Note>? notes,
    List<Tag>? tags,
    Map<String, List<String>>? tagIdsByNoteId,
    String? selectedNoteId,
    bool clearSelectedNoteId = false,
    String? searchQuery,
    String? selectedTagId,
    bool clearSelectedTagId = false,
    bool? previewMode,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      tagIdsByNoteId: tagIdsByNoteId ?? this.tagIdsByNoteId,
      selectedNoteId:
          clearSelectedNoteId ? null : selectedNoteId ?? this.selectedNoteId,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTagId:
          clearSelectedTagId ? null : selectedTagId ?? this.selectedTagId,
      previewMode: previewMode ?? this.previewMode,
    );
  }
}

class NotesController extends AsyncNotifier<NotesState> {
  late final NotesRepository _notesRepository;
  late final TagsRepository _tagsRepository;

  @override
  Future<NotesState> build() async {
    _notesRepository = ref.watch(notesRepositoryProvider);
    _tagsRepository = ref.watch(tagsRepositoryProvider);
    return _load();
  }

  Future<NotesState> _load({
    String searchQuery = '',
    String? selectedTagId,
    String? selectedNoteId,
    bool previewMode = false,
  }) async {
    final notes = searchQuery.trim().isEmpty
        ? await _notesRepository.watchActiveNotes()
        : await _notesRepository.search(searchQuery.trim());
    final tagIdsByNoteId = await _notesRepository.tagIdsByNoteId();
    final tagFilteredNotes = selectedTagId == null
        ? notes
        : notes
            .where(
              (note) => (tagIdsByNoteId[note.id] ?? const []).contains(
                selectedTagId,
              ),
            )
            .toList();
    final tags = await _tagsRepository.watchActiveTags();
    final nextSelectedId = selectedNoteId != null &&
            tagFilteredNotes.any((note) => note.id == selectedNoteId)
        ? selectedNoteId
        : _firstOrNull(tagFilteredNotes)?.id;

    return NotesState(
      notes: tagFilteredNotes,
      tags: tags,
      tagIdsByNoteId: tagIdsByNoteId,
      selectedNoteId: nextSelectedId,
      searchQuery: searchQuery,
      selectedTagId: selectedTagId,
      previewMode: previewMode,
    );
  }

  Future<void> reload() async {
    final current = state.valueOrNull;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _load(
        searchQuery: current?.searchQuery ?? '',
        selectedTagId: current?.selectedTagId,
        selectedNoteId: current?.selectedNoteId,
        previewMode: current?.previewMode ?? false,
      ),
    );
  }

  Future<void> createNote({String deviceId = 'local-device'}) async {
    final now = Clock.nowMillis();
    final note = Note(
      id: IdGenerator.create(),
      title: 'Untitled note',
      content: '',
      createdAt: now,
      updatedAt: now,
      deviceId: deviceId,
    );
    await _notesRepository.upsert(note);
    state = await AsyncValue.guard(
      () => _load(selectedNoteId: note.id),
    );
  }

  Future<void> updateNote(String id, {String? title, String? content}) async {
    final current = state.valueOrNull;
    final note = _firstOrNull(current?.notes.where((note) => note.id == id));
    if (note == null) {
      return;
    }
    final updated = note.copyWith(
      title: title,
      content: content,
      updatedAt: Clock.nowMillis(),
      version: note.version + 1,
    );
    await _notesRepository.upsert(updated);
    state = await AsyncValue.guard(
      () => _load(
        searchQuery: current?.searchQuery ?? '',
        selectedTagId: current?.selectedTagId,
        selectedNoteId: id,
        previewMode: current?.previewMode ?? false,
      ),
    );
  }

  Future<void> deleteNote(String id) async {
    final current = state.valueOrNull;
    await _notesRepository.softDelete(id, Clock.nowMillis());
    state = await AsyncValue.guard(
      () => _load(
        searchQuery: current?.searchQuery ?? '',
        selectedTagId: current?.selectedTagId,
        previewMode: current?.previewMode ?? false,
      ),
    );
  }

  Future<void> updateSearchQuery(String query) async {
    final current = state.valueOrNull;
    state = await AsyncValue.guard(
      () => _load(
        searchQuery: query,
        selectedTagId: current?.selectedTagId,
        previewMode: current?.previewMode ?? false,
      ),
    );
  }

  Future<void> selectTag(String? tagId) async {
    final current = state.valueOrNull;
    state = await AsyncValue.guard(
      () => _load(
        searchQuery: current?.searchQuery ?? '',
        selectedTagId: tagId,
        previewMode: current?.previewMode ?? false,
      ),
    );
  }

  void selectNote(String id) {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    state = AsyncData(current.copyWith(selectedNoteId: id));
  }

  void clearSelection() {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    state = AsyncData(current.copyWith(clearSelectedNoteId: true));
  }

  void setPreviewMode(bool value) {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    state = AsyncData(current.copyWith(previewMode: value));
  }

  Future<void> createTag(String name,
      {String deviceId = 'local-device'}) async {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      return;
    }
    final existing = await _tagsRepository.findByName(normalizedName);
    if (existing != null) {
      return;
    }
    final now = Clock.nowMillis();
    await _tagsRepository.upsert(
      Tag(
        id: IdGenerator.create(),
        name: normalizedName,
        createdAt: now,
        updatedAt: now,
        deviceId: deviceId,
      ),
    );
    await reload();
  }

  Future<void> toggleTagForSelectedNote(String tagId) async {
    final current = state.valueOrNull;
    final note = current?.selectedNote;
    if (current == null || note == null) {
      return;
    }
    final currentTagIds = [...current.tagIdsFor(note.id)];
    if (currentTagIds.contains(tagId)) {
      currentTagIds.remove(tagId);
    } else {
      currentTagIds.add(tagId);
    }
    final now = Clock.nowMillis();
    await _notesRepository.setNoteTags(note.id, currentTagIds, now);
    state = await AsyncValue.guard(
      () => _load(
        searchQuery: current.searchQuery,
        selectedTagId: current.selectedTagId,
        selectedNoteId: note.id,
        previewMode: current.previewMode,
      ),
    );
  }
}

T? _firstOrNull<T>(Iterable<T>? values) {
  if (values == null || values.isEmpty) {
    return null;
  }
  return values.first;
}
