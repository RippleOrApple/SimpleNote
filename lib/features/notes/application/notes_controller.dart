import 'dart:async';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/id_generator.dart';
import '../../../core/utils/time.dart';
import '../../../shared/models/markdown_edit.dart';
import '../../attachments/application/attachment_import_service.dart';
import '../../attachments/domain/content_attachment.dart';
import '../../attachments/infrastructure/attachment_picker.dart';
import '../../tags/data/tags_repository.dart';
import '../../tags/domain/tag.dart';
import '../data/notes_repository.dart';
import '../domain/note.dart';

final notesControllerProvider =
    AsyncNotifierProvider<NotesController, NotesState>(NotesController.new);

enum NoteSaveStatus { idle, saving, saved, failed }

class NotesState {
  const NotesState({
    required this.notes,
    required this.tags,
    required this.tagIdsByNoteId,
    this.selectedNoteId,
    this.searchQuery = '',
    this.selectedTagId,
    this.previewMode = false,
    this.saveStatus = NoteSaveStatus.idle,
    this.errorMessage,
  });

  final List<Note> notes;
  final List<Tag> tags;
  final Map<String, List<String>> tagIdsByNoteId;
  final String? selectedNoteId;
  final String searchQuery;
  final String? selectedTagId;
  final bool previewMode;
  final NoteSaveStatus saveStatus;
  final String? errorMessage;

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
    NoteSaveStatus? saveStatus,
    String? errorMessage,
    bool clearErrorMessage = false,
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
      saveStatus: saveStatus ?? this.saveStatus,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class NotesController extends AsyncNotifier<NotesState> {
  late final NotesRepository _notesRepository;
  late final TagsRepository _tagsRepository;
  Timer? _editDebounce;
  Completer<void>? _editCompleter;
  _PendingNoteEdit? _pendingEdit;

  @override
  Future<NotesState> build() async {
    _notesRepository = ref.watch(notesRepositoryProvider);
    _tagsRepository = ref.watch(tagsRepositoryProvider);
    ref.onDispose(() {
      _editDebounce?.cancel();
      if (!(_editCompleter?.isCompleted ?? true)) {
        _editCompleter!.complete();
      }
    });
    return _load();
  }

  Future<NotesState> _load({
    String searchQuery = '',
    String? selectedTagId,
    String? selectedNoteId,
    bool previewMode = false,
    NoteSaveStatus saveStatus = NoteSaveStatus.idle,
    String? errorMessage,
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
      saveStatus: saveStatus,
      errorMessage: errorMessage,
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
    if (_pendingEdit != null && _pendingEdit!.id != id) {
      await _flushPendingEdit();
    }
    final current = state.valueOrNull;
    final note = _firstOrNull(current?.notes.where((note) => note.id == id));
    if (note == null) {
      return;
    }
    final pending =
        _pendingEdit?.id == id ? _pendingEdit! : _PendingNoteEdit(id: id);
    _pendingEdit = pending.merge(title: title, content: content);
    final completer = _editCompleter == null || _editCompleter!.isCompleted
        ? (_editCompleter = Completer<void>())
        : _editCompleter!;
    state = AsyncData(current!.copyWith(
      saveStatus: NoteSaveStatus.saving,
      clearErrorMessage: true,
    ));
    _editDebounce?.cancel();
    _editDebounce = Timer(
      const Duration(milliseconds: 350),
      _commitPendingEdit,
    );
    await completer.future;
  }

  Future<void> _commitPendingEdit() async {
    final pending = _pendingEdit;
    final completer = _editCompleter;
    _pendingEdit = null;
    _editCompleter = null;
    _editDebounce = null;
    if (pending == null) {
      if (!(completer?.isCompleted ?? true)) completer!.complete();
      return;
    }
    final current = state.valueOrNull;
    if (current == null) {
      if (!(completer?.isCompleted ?? true)) completer!.complete();
      return;
    }
    final note = await _notesRepository.findById(pending.id);
    if (note == null || note.isDeleted) {
      if (!(completer?.isCompleted ?? true)) completer!.complete();
      return;
    }
    try {
      await _notesRepository.upsert(note.copyWith(
        title: pending.hasTitle ? pending.title : null,
        content: pending.hasContent ? pending.content : null,
        updatedAt: Clock.nowMillis(),
        version: note.version + 1,
      ));
      state = AsyncData(await _load(
        searchQuery: current.searchQuery,
        selectedTagId: current.selectedTagId,
        selectedNoteId: pending.id,
        previewMode: current.previewMode,
        saveStatus: NoteSaveStatus.saved,
      ));
    } catch (error) {
      state = AsyncData(current.copyWith(
        saveStatus: NoteSaveStatus.failed,
        errorMessage: error.toString(),
      ));
    } finally {
      if (!(completer?.isCompleted ?? true)) completer!.complete();
    }
  }

  Future<void> _flushPendingEdit() async {
    _editDebounce?.cancel();
    if (_pendingEdit != null) {
      await _commitPendingEdit();
    }
  }

  Future<MarkdownEditResult?> insertImage(
    AttachmentPickSource source,
    MarkdownSelection selection, {
    required String altText,
  }) async {
    await _flushPendingEdit();
    final current = state.valueOrNull;
    final note = current?.selectedNote;
    if (current == null || note == null) return null;
    final picked = await ref.read(attachmentPickerProvider).pick(source);
    if (picked == null) return null;
    return _attachImage(
      picked,
      selection,
      altText: altText,
    );
  }

  Future<void> importRecoveredImages(List<XFile> files) async {
    await _flushPendingEdit();
    for (final file in files) {
      final note = state.valueOrNull?.selectedNote;
      if (note == null) return;
      final result = await _attachImage(
        file,
        MarkdownSelection(
          baseOffset: note.content.length,
          extentOffset: note.content.length,
        ),
        altText: _recoveredImageAlt(file),
      );
      if (result == null) return;
    }
  }

  Future<MarkdownEditResult?> _attachImage(
    XFile picked,
    MarkdownSelection selection, {
    required String altText,
  }) async {
    final current = state.valueOrNull;
    final note = current?.selectedNote;
    if (current == null || note == null) return null;
    state = AsyncData(current.copyWith(
      saveStatus: NoteSaveStatus.saving,
      clearErrorMessage: true,
    ));
    try {
      final service = await ref.read(attachmentImportServiceProvider.future);
      final result = await service.importAndAttach(
        owner: AttachmentOwner(AttachmentOwnerType.note, note.id),
        input: XFileAttachmentInput(picked),
        currentMarkdown: note.content,
        selection: selection,
        altText: altText,
      );
      state = AsyncData(await _load(
        searchQuery: current.searchQuery,
        selectedTagId: current.selectedTagId,
        selectedNoteId: note.id,
        previewMode: current.previewMode,
        saveStatus: NoteSaveStatus.saved,
      ));
      return result.edit;
    } catch (error) {
      state = AsyncData(current.copyWith(
        saveStatus: NoteSaveStatus.failed,
        errorMessage: error.toString(),
      ));
      return null;
    }
  }

  Future<void> deleteImage(String attachmentId) async {
    await _flushPendingEdit();
    final current = state.valueOrNull;
    final note = current?.selectedNote;
    if (current == null || note == null) return;
    state = AsyncData(current.copyWith(
      saveStatus: NoteSaveStatus.saving,
      clearErrorMessage: true,
    ));
    try {
      final service = await ref.read(attachmentImportServiceProvider.future);
      await service.deleteAndDetach(
        owner: AttachmentOwner(AttachmentOwnerType.note, note.id),
        attachmentId: attachmentId,
        currentMarkdown: note.content,
        selection: MarkdownSelection(
          baseOffset: note.content.length,
          extentOffset: note.content.length,
        ),
      );
      state = AsyncData(await _load(
        searchQuery: current.searchQuery,
        selectedTagId: current.selectedTagId,
        selectedNoteId: note.id,
        previewMode: current.previewMode,
        saveStatus: NoteSaveStatus.saved,
      ));
    } catch (error) {
      state = AsyncData(current.copyWith(
        saveStatus: NoteSaveStatus.failed,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<ContentAttachment?> resolveAttachment(String id) async {
    final service = await ref.read(attachmentImportServiceProvider.future);
    return service.resolveAttachment(id);
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

String _recoveredImageAlt(XFile file) {
  final name = file.name.trim();
  return name.isEmpty ? 'recovered image' : name;
}

T? _firstOrNull<T>(Iterable<T>? values) {
  if (values == null || values.isEmpty) {
    return null;
  }
  return values.first;
}

final class _PendingNoteEdit {
  const _PendingNoteEdit({
    required this.id,
    this.title,
    this.content,
    this.hasTitle = false,
    this.hasContent = false,
  });

  final String id;
  final String? title;
  final String? content;
  final bool hasTitle;
  final bool hasContent;

  _PendingNoteEdit merge({String? title, String? content}) {
    return _PendingNoteEdit(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      hasTitle: hasTitle || title != null,
      hasContent: hasContent || content != null,
    );
  }
}
