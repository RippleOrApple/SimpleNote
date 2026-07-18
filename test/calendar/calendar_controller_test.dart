import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/features/calendar/application/calendar_controller.dart';
import 'package:simple_note/features/calendar/data/calendar_repository.dart';
import 'package:simple_note/features/calendar/domain/calendar_entry.dart';

void main() {
  test('loads and replaces the requested calendar range', () async {
    final repository = _FakeCalendarRepository();
    final container = ProviderContainer(overrides: [
      calendarRepositoryProvider.overrideWithValue(repository),
    ]);
    addTearDown(container.dispose);

    final controller = container.read(calendarControllerProvider.notifier);
    await container.read(calendarControllerProvider.future);

    await controller.loadRange(from: 1000, before: 2000);
    var state = await container.read(calendarControllerProvider.future);
    expect(state.from, 1000);
    expect(state.before, 2000);
    expect(state.days.single.entries.single.title, '1000-2000');

    await controller.loadRange(from: 3000, before: 4000);
    state = await container.read(calendarControllerProvider.future);
    expect(state.from, 3000);
    expect(state.before, 4000);
    expect(state.days.single.entries.single.title, '3000-4000');
  });
}

class _FakeCalendarRepository implements CalendarRepository {
  @override
  Future<List<CalendarEntry>> queryEntries({
    required int from,
    required int before,
  }) async {
    return [
      CalendarEntry(
        id: 'entry-$from-$before',
        sourceId: 'source',
        source: CalendarEntrySource.note,
        kind: CalendarEntryKind.noteCreated,
        title: '$from-$before',
        scheduledAt: from,
        dayStart: from,
      ),
    ];
  }

  @override
  Future<List<CalendarDay>> queryDays({
    required int from,
    required int before,
  }) async {
    return [
      CalendarDay(
        dayStart: from,
        entries: await queryEntries(from: from, before: before),
      ),
    ];
  }
}
