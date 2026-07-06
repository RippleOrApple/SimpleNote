# Findings & Decisions

## Requirements

- Complete Phase 7 from `GOAL.md`: experience polish and basic error handling.
- Add mobile-friendly editor back actions.
- Protect note/todo deletion with confirmation.
- Show lightweight feedback after deletion.
- Clean visible copy/separators.
- Preserve prior phase behavior and tests.

## Research Findings

- Compact notes/todos layouts currently replace the list with the editor after selecting an item.
- There is no explicit back-to-list action in compact editors.
- Notes and todos currently delete immediately from editor icon buttons.
- `TodosPage._todoSubtitle` contains an odd visible separator character.
- Existing widget tests already cover notes, todos, settings, theme, and LAN sync flows.

## Technical Decisions

| Decision | Rationale |
|----------|-----------|
| Add `clearSelection` to controllers | Simple state-level way to return compact editors to lists |
| Show confirmation dialogs from editor widgets | Keeps destructive-action UX close to the action |
| Show SnackBars after confirmed deletes | Gives clear feedback without adding undo scope |
| Use ASCII separator in todo subtitles | Avoids encoding/display oddities |

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| None yet | - |
