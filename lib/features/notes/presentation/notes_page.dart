import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_shell.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../tags/domain/tag.dart';
import '../application/notes_controller.dart';
import '../domain/note.dart';

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesState = ref.watch(notesControllerProvider);

    return AppShell(
      title: 'Notes',
      floatingActionButton: FloatingActionButton(
        tooltip: 'New note',
        onPressed: () =>
            ref.read(notesControllerProvider.notifier).createNote(),
        child: const Icon(Icons.add),
      ),
      child: notesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Could not load notes: $error')),
        data: (state) => _NotesWorkspace(state: state),
      ),
    );
  }
}

class _NotesWorkspace extends ConsumerWidget {
  const _NotesWorkspace({required this.state});

  final NotesState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(notesControllerProvider.notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 840;
        final list = _NotesList(
          state: state,
          onCreateNote: controller.createNote,
          onSearchChanged: controller.updateSearchQuery,
          onSelectNote: controller.selectNote,
          onSelectTag: controller.selectTag,
        );
        final editor = state.selectedNote == null
            ? EmptyState(
                icon: Icons.edit_note,
                title: 'No note selected',
                message: state.notes.isEmpty
                    ? 'Create a note to start writing.'
                    : 'Select a note from the list.',
                actionLabel: 'New note',
                onActionPressed: controller.createNote,
              )
            : _NoteEditor(
                note: state.selectedNote!,
                tags: state.tags,
                assignedTagIds: state.tagIdsFor(state.selectedNote!.id),
                previewMode: state.previewMode,
                onTitleChanged: (value) =>
                    controller.updateNote(state.selectedNote!.id, title: value),
                onContentChanged: (value) => controller.updateNote(
                  state.selectedNote!.id,
                  content: value,
                ),
                onDelete: () => controller.deleteNote(state.selectedNote!.id),
                onBack: isWide ? null : controller.clearSelection,
                onPreviewModeChanged: controller.setPreviewMode,
                onCreateTag: controller.createTag,
                onToggleTag: controller.toggleTagForSelectedNote,
              );

        if (isWide) {
          return Row(
            children: [
              SizedBox(width: 320, child: list),
              const VerticalDivider(width: 1),
              Expanded(child: editor),
            ],
          );
        }

        return state.selectedNote == null || state.notes.isEmpty
            ? list
            : editor;
      },
    );
  }
}

class _NotesList extends StatefulWidget {
  const _NotesList({
    required this.state,
    required this.onCreateNote,
    required this.onSearchChanged,
    required this.onSelectNote,
    required this.onSelectTag,
  });

  final NotesState state;
  final VoidCallback onCreateNote;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSelectNote;
  final ValueChanged<String?> onSelectTag;

  @override
  State<_NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<_NotesList> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.state.searchQuery);
  }

  @override
  void didUpdateWidget(covariant _NotesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.searchQuery != _searchController.text) {
      _searchController.text = widget.state.searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.notes.isEmpty &&
        widget.state.searchQuery.isEmpty &&
        widget.state.selectedTagId == null) {
      return EmptyState(
        icon: Icons.note_add_outlined,
        title: 'No notes yet',
        message: 'Create your first Markdown note and keep your ideas close.',
        actionLabel: 'New note',
        onActionPressed: widget.onCreateNote,
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Search notes',
              border: OutlineInputBorder(),
            ),
            onChanged: widget.onSearchChanged,
          ),
        ),
        if (widget.state.tags.isNotEmpty)
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('All'),
                    selected: widget.state.selectedTagId == null,
                    onSelected: (_) => widget.onSelectTag(null),
                  ),
                ),
                for (final tag in widget.state.tags)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(tag.name),
                      selected: widget.state.selectedTagId == tag.id,
                      onSelected: (_) => widget.onSelectTag(tag.id),
                    ),
                  ),
              ],
            ),
          ),
        Expanded(
          child: widget.state.notes.isEmpty
              ? const Center(child: Text('No matching notes.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.state.notes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final note = widget.state.notes[index];
                    final selected = note.id == widget.state.selectedNoteId;
                    return Card(
                      color: selected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      child: ListTile(
                        title: Text(note.title),
                        subtitle: Text(
                          note.content.isEmpty ? 'Empty note' : note.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => widget.onSelectNote(note.id),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _NoteEditor extends StatefulWidget {
  const _NoteEditor({
    required this.note,
    required this.tags,
    required this.assignedTagIds,
    required this.previewMode,
    required this.onTitleChanged,
    required this.onContentChanged,
    required this.onDelete,
    required this.onPreviewModeChanged,
    required this.onCreateTag,
    required this.onToggleTag,
    this.onBack,
  });

  final Note note;
  final List<Tag> tags;
  final List<String> assignedTagIds;
  final bool previewMode;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onContentChanged;
  final Future<void> Function() onDelete;
  final ValueChanged<bool> onPreviewModeChanged;
  final ValueChanged<String> onCreateTag;
  final ValueChanged<String> onToggleTag;
  final VoidCallback? onBack;

  @override
  State<_NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<_NoteEditor> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _tagController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
    _tagController = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant _NoteEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.note.id != widget.note.id ||
        oldWidget.note.title != widget.note.title) {
      _titleController.text = widget.note.title;
    }
    if (oldWidget.note.id != widget.note.id ||
        oldWidget.note.content != widget.note.content) {
      _contentController.text = widget.note.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            if (widget.onBack != null) ...[
              IconButton(
                key: const Key('note-back-button'),
                tooltip: 'Back to notes',
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: TextField(
                key: const Key('note-title-field'),
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                onChanged: widget.onTitleChanged,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Delete note',
              onPressed: _confirmDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(
              value: false,
              icon: Icon(Icons.edit_outlined),
              label: Text('Edit'),
            ),
            ButtonSegment(
              value: true,
              icon: Icon(Icons.visibility_outlined),
              label: Text('Preview'),
            ),
          ],
          selected: {widget.previewMode},
          onSelectionChanged: (values) =>
              widget.onPreviewModeChanged(values.first),
        ),
        const SizedBox(height: 12),
        if (widget.previewMode)
          Container(
            key: const Key('markdown-preview'),
            constraints: const BoxConstraints(minHeight: 280),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: MarkdownBody(
              data: widget.note.content.isEmpty
                  ? '_Nothing to preview yet._'
                  : widget.note.content,
            ),
          )
        else
          TextField(
            key: const Key('note-content-field'),
            controller: _contentController,
            minLines: 12,
            maxLines: null,
            decoration: const InputDecoration(
              labelText: 'Markdown',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
            onChanged: widget.onContentChanged,
          ),
        const SizedBox(height: 16),
        Text('Tags', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tag in widget.tags)
              FilterChip(
                label: Text(tag.name),
                selected: widget.assignedTagIds.contains(tag.id),
                onSelected: (_) => widget.onToggleTag(tag.id),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                key: const Key('new-tag-field'),
                controller: _tagController,
                decoration: const InputDecoration(
                  labelText: 'New tag',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: _createTag,
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: () => _createTag(_tagController.text),
              icon: const Icon(Icons.add),
              label: const Text('Add tag'),
            ),
          ],
        ),
      ],
    );
  }

  void _createTag(String value) {
    widget.onCreateTag(value);
    _tagController.clear();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete note?'),
        content: const Text('This note will be removed from this device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }
    await widget.onDelete();
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note deleted')),
    );
  }
}
