# Goal

## Objective

完成 V2 Phase 3 Task 22：schema 4 与习惯领域模型。

Task 21 已经补齐 Calendar 入口。Task 22 只建立习惯能力的数据基础：新增 `habits`、`habit_checkins`、schema v4 migration，以及 `Habit`、`HabitCheckin`、`HabitSchedule` 领域模型。

## Scope

- 将数据库 schema version 从 3 升级到 4。
- 新增 `habits` 表。
- 新增 `habit_checkins` 表。
- 新增 schema v4 migration。
- 新增 schema 4 索引和约束。
- 扩展生产数据库升级前备份，使 schema 3 -> 4 前生成 `pre-v4` 备份。
- 新增 `Habit` 领域模型。
- 新增 `HabitCheckin` 领域模型。
- 新增 `HabitSchedule` 领域模型。
- 覆盖 schema 1/2/3 -> 4 的迁移路径。
- 添加数据库和领域模型测试。
- 更新 `task_plan.md`、`findings.md` 和 `progress.md`。

## Non-goals

- 不实现习惯仓库 CRUD。
- 不实现习惯 controller。
- 不实现习惯 UI。
- 不实现习惯提醒调度。
- 不把习惯接入 Calendar。
- 不实现 Statistics。
- 不改同步协议。

## Acceptance Criteria

- [x] 新数据库创建时包含 `habits` 和 `habit_checkins`。
- [x] schema version 为 4。
- [x] `habits` 约束能拒绝空名称、非法颜色、非法计划类型和非法归档值。
- [x] `habit_checkins` 约束能拒绝非法状态。
- [x] 同一未删除习惯同一天只能有一条 active checkin。
- [x] schema 1 -> 4、schema 2 -> 4、schema 3 -> 4 迁移后旧任务、笔记、外观和附件基础表不丢失。
- [x] schema 3 生产升级前会创建 `pre-v4` 备份。
- [x] `Habit`、`HabitCheckin`、`HabitSchedule` 支持 JSON round-trip。
- [x] `HabitSchedule` 支持 `daily`、`weekdays`、`weekly`、`interval`。
- [x] `dart run build_runner build --delete-conflicting-outputs` 通过。
- [x] `dart format --output=none --set-exit-if-changed lib test` 通过。
- [x] `flutter analyze` 通过。
- [x] 相关 database/habits 测试通过。

## Constraints

- 继续使用 Drift + SQLite。
- `checkinDay` 使用本地日开始 epoch milliseconds。
- 删除继续使用软删除字段。
- 领域模型不依赖 UI。
- Task 22 只建立数据与领域基础，不提前做 Task 23。

## Notes

- 后续 Task 23 会基于这些表和领域模型实现习惯仓库、打卡、取消打卡、补卡和基础统计计算。
