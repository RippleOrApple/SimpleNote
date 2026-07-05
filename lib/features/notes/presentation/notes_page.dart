import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_shell.dart';
import '../application/notes_controller.dart';

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesControllerProvider);

    return AppShell(
      title: 'Notes',
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            ref.read(notesControllerProvider.notifier).createNote(),
        child: const Icon(Icons.add),
      ),
      child: notes.isEmpty
          ? const Center(child: Text('Create your first Markdown note.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: MarkdownBody(
                      data:
                          note.content.isEmpty ? '_Empty note_' : note.content,
                    ),
                    trailing: IconButton(
                      tooltip: 'Delete',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => ref
                          .read(notesControllerProvider.notifier)
                          .deleteNote(note.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
