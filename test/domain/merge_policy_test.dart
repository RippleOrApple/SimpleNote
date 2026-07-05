import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/features/notes/domain/note.dart';
import 'package:simple_note/features/sync/domain/merge_policy.dart';

void main() {
  test('chooseLatest returns the entity with the latest change time', () {
    const local = Note(
      id: '1',
      title: 'Local',
      content: '',
      createdAt: 1,
      updatedAt: 10,
      deviceId: 'a',
    );
    const remote = Note(
      id: '1',
      title: 'Remote',
      content: '',
      createdAt: 1,
      updatedAt: 20,
      deviceId: 'b',
    );

    expect(MergePolicy.chooseLatest(local, remote).title, 'Remote');
  });
}
