# Task Plan: SimpleNote Phase 7 Experience Polish

## Goal

Improve day-to-day usability with compact editor back actions, delete confirmations, success feedback, cleaner visible text, and tests.

## Current Phase

Complete

## Phases

### Phase 1: Requirements & Discovery

- [x] Read `GOAL.md`
- [x] Inspect notes/todos presentation and controller patterns
- [x] Inspect existing widget tests
- **Status:** complete

### Phase 2: Planning & Structure

- [x] Choose compact editor back action approach
- [x] Choose delete confirmation flow
- [x] Choose test coverage
- **Status:** complete

### Phase 3: Implementation

- [x] Add clear selection actions to notes and todos controllers
- [x] Add compact back buttons to note and todo editors
- [x] Add note delete confirmation and success snackbar
- [x] Add todo delete confirmation and success snackbar
- [x] Clean todo subtitle separator text
- **Status:** complete

### Phase 4: Testing & Verification

- [x] Add/update widget tests for polish behavior
- [x] Run `flutter analyze`
- [x] Run `flutter test`
- [x] Verify acceptance criteria against `GOAL.md`
- **Status:** complete

### Phase 5: Delivery

- [x] Update `GOAL.md` acceptance checkboxes
- [x] Update planning files with final results
- [x] Submit PR with `scripts/update_pr.ps1`
- **Status:** complete

## Decisions Made

| Decision | Rationale |
|----------|-----------|
| Add controller `clearSelection` methods | Keeps compact back navigation in state instead of route hacks |
| Use Material confirmation dialogs | Native, dependency-free, and easy to test |
| Use SnackBar for success feedback | Lightweight and familiar |
| Keep undo out of scope | P7 is polish, not full history/restore |

## Errors Encountered

| Error | Attempt | Resolution |
|-------|---------|------------|
| Compact back action did not really clear selected item because selected getters returned the first item when no id was selected | 1 | Updated selected getters to return null when no selected id exists |
| Todo compact delete test could not find the edit tooltip before the selected getter fix | 1 | Fixed selected state behavior, then reran widget tests |
