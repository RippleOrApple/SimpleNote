# Findings & Decisions

## Requirements

- Complete Phase 4 from `GOAL.md`: Todos MVP.
- Support todo create, edit title, edit description, complete/uncomplete, delete, due date, priority, and filtering.
- Persist todos through the Phase 2 Drift database.
- Preserve Phase 1 navigation, Phase 2 database, and Phase 3 notes behavior.
- Add/update relevant tests.
- `flutter analyze` and `flutter test` must pass.
- If interrupted, leave `P4_STATUS.md` documenting completed and remaining work.

## Research Findings

- `TodosController` currently stores an in-memory `List<Todo>` and does not use `TodosRepository`.
- `TodosPage` currently renders a simple checkbox list and does not provide editing, filtering, due date, or priority controls beyond display.
- `TodosRepository` supports active todos, upsert, and soft delete but does not expose filtered queries.
- `TodosDao` already sorts active todos and stores `completed`, `dueAt`, `priority`, `updatedAt`, and `deletedAt`.
- Existing tests cover database repository basics, notes controller behavior, and shell navigation.

## Technical Decisions

| Decision | Rationale |
|----------|-----------|
| Use `AsyncNotifier<TodosState>` for todos | Matches Notes MVP architecture and handles database loading naturally |
| Keep `TodosPage` as list/detail editor | Good MVP shape for mobile and desktop without new routes |
| Add filter in controller state, not database query initially | Keeps repository small and allows fast in-memory filtering of active todo rows |
| Use Material `showDatePicker` | Avoids new dependency while satisfying due date editing |
| Keep todo filters in controller state | Satisfies filter UX without expanding DAO API in this phase |

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| Todos widget test attempted to interact before async page render finished | Waited for page render and used stable route/test interactions |
| Navigation by rail label was unstable in the todos feature test | Navigated directly to `/todos` for the feature-focused widget test |

## Resources

- `GOAL.md`
- `docs/DEVELOPMENT_PHASES.md`
- `lib/features/todos/application/todos_controller.dart`
- `lib/features/todos/presentation/todos_page.dart`
- `lib/features/todos/data/todos_repository.dart`
- `lib/database/daos/todos_dao.dart`

## Visual/Browser Findings

- No browser or image findings for this implementation step.
