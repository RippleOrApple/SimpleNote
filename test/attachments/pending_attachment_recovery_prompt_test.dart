import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/attachments/application/attachment_import_service.dart';
import 'package:simple_note/features/attachments/data/attachments_repository.dart';
import 'package:simple_note/features/attachments/infrastructure/attachment_file_store.dart';
import 'package:simple_note/features/attachments/infrastructure/attachment_picker.dart';
import 'package:simple_note/features/attachments/presentation/pending_attachment_recovery_prompt.dart';
import 'package:simple_note/features/sync/data/sync_repository.dart';
import 'package:simple_note/features/sync/domain/device_info.dart';
import 'package:simple_note/features/tasks/application/tasks_controller.dart';

void main() {
  testWidgets('recovered images expose current targets without auto import',
      (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final root = Directory.systemTemp.createTempSync('pending-recovery-');
    addTearDown(() async {
      await database.close();
      if (root.existsSync()) root.deleteSync(recursive: true);
    });
    await database.notesDao.upsertNote(NotesCompanion.insert(
      id: 'note-1',
      title: 'Current note',
      content: 'Note body',
      createdAt: 1,
      updatedAt: 1,
      deviceId: 'recovery-device',
    ));
    await database.tasksV2Dao.upsertTask(TasksV2Companion.insert(
      id: 'task-1',
      title: 'Current task',
      dueAt: Value(DateTime.now().millisecondsSinceEpoch),
      createdAt: 1,
      updatedAt: 1,
      deviceId: 'recovery-device',
    ));
    final repository = DriftAttachmentsRepository(
      database: database,
      rootDirectory: root,
    );
    final service = AttachmentImportService(
      repository: repository,
      fileStore: AttachmentFileStore(rootDirectory: root),
      deviceId: 'recovery-device',
    );
    final recovered = XFile.fromData(
      Uint8List.fromList(
        img.encodePng(img.Image(width: 32, height: 24)),
      ),
      name: 'recovered.png',
      mimeType: 'image/png',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          deviceInfoProvider.overrideWithValue(_device),
          pendingAttachmentRecoveryProvider.overrideWith(
            (ref) async => [recovered],
          ),
          attachmentImportServiceProvider.overrideWith(
            (ref) async => service,
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: PendingAttachmentRecoveryPrompt(
              child: SizedBox.expand(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('pending-attachment-recovery-prompt')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('recover-images-to-note')), findsOneWidget);

    final context = tester.element(
      find.byType(PendingAttachmentRecoveryPrompt),
    );
    final container = ProviderScope.containerOf(context);
    await container.read(tasksControllerProvider.future);
    container.read(tasksControllerProvider.notifier).selectTask('task-1');
    await tester.pumpAndSettle();
    expect(
      container.read(tasksControllerProvider).valueOrNull?.selectedTaskId,
      'task-1',
    );
    expect(find.byKey(const Key('recover-images-to-task')), findsOneWidget);
    expect((await database.notesDao.findById('note-1'))!.content, 'Note body');
    expect(
      (await database.tasksV2Dao.findById('task-1'))!.descriptionMarkdown,
      isEmpty,
    );

    await tester.tap(find.byKey(const Key('dismiss-recovered-images')));
    await tester.pumpAndSettle();

    expect((await database.notesDao.findById('note-1'))!.content, 'Note body');
    expect(
      (await database.tasksV2Dao.findById('task-1'))!.descriptionMarkdown,
      isEmpty,
    );
    expect(
      find.byKey(const Key('pending-attachment-recovery-prompt')),
      findsNothing,
    );
  });
}

const _device = DeviceInfo(
  deviceId: 'recovery-device',
  deviceName: 'Android test device',
  platform: 'android',
  appVersion: '1.0.0',
);
