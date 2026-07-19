# Goal

## Objective

完成 V2 Phase 3 Task 23：习惯仓库与统计计算基础。

Task 22 已经建立 schema 4 与习惯领域模型。本任务在其上实现习惯数据访问闭环：习惯 CRUD、今日计划查询、打卡/取消打卡/补卡，以及完成率和连续周期计算。

## Scope

- 新增 `HabitsRepository` 抽象与 Drift 实现。
- 新增 `habitsRepositoryProvider`。
- 支持创建、更新、归档、软删除习惯。
- 支持查询 active 习惯、归档习惯、指定日期计划习惯。
- 支持指定日期打卡、取消打卡、补卡。
- 同一天重复打卡不得产生重复 active checkin。
- 取消打卡使用软删除，不物理删除历史记录。
- 新增 `HabitStatistics` 领域模型。
- 统计完成率、计划天数、完成天数、当前连续周期、最长连续周期。
- 覆盖 daily、weekdays、weekly、interval 计划的统计边界。
- 更新 `task_plan.md`、`findings.md` 和 `progress.md`。

## Non-goals

- 不实现习惯 controller。
- 不实现习惯 UI。
- 不接入 Calendar。
- 不实现 Statistics 页面。
- 不实现习惯提醒。
- 不修改同步协议。
- 不新增 schema 5。

## Acceptance Criteria

- [x] `HabitsRepository` 可以 upsert、查询、归档和软删除习惯。
- [x] 指定日期计划查询只返回未删除、未归档且当天应执行的习惯。
- [x] 打卡会创建 active `HabitCheckin`。
- [x] 同一习惯同一天重复打卡不会产生重复 active 记录。
- [x] 取消打卡会写软删除，并提升记录版本。
- [x] 取消后再次打卡可创建新的 active 记录，旧记录保留为 deleted。
- [x] 补卡可对过去日期写入 checkin。
- [x] 完成率只统计计划日期，非计划日期打卡不提高分母。
- [x] 连续周期在跨周、跨月和 interval 计划下正确。
- [x] `dart format --output=none --set-exit-if-changed lib test` 通过。
- [x] `flutter analyze` 通过。
- [x] 相关 habits/database 测试通过。

## Constraints

- 继续使用 Drift + SQLite。
- `checkinDay` 使用本地日开始 epoch milliseconds。
- 习惯和打卡删除继续使用软删除字段。
- 仓库层不依赖 UI。
- 统计计算必须可被后续 controller、Statistics 页面和 Calendar 聚合复用。

## Notes

- Task 24 会在本仓库基础上实现习惯应用状态与 Windows/Android UI。
- Task 25 会在本统计基础上实现全局 Statistics 聚合与页面。
