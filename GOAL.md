# Goal

## Objective

完成 V2 Phase 3 Task 24：习惯应用状态与 Windows/Android UI。

Task 23 已经完成习惯仓库与统计计算。本任务在其上实现可用的习惯模块：`HabitsController`、`HabitsPage`、列表/详情/编辑入口，并替换导航中的 Habits 占位页。

## Scope

- 新增 `habitsControllerProvider`。
- 新增 `HabitsState`、保存状态、选择状态、今日计划、全部 active 习惯、归档习惯入口数据。
- 支持创建、编辑、归档、软删除习惯。
- 支持今日打卡和取消今日打卡。
- 支持加载选中习惯的 checkins 与统计数据。
- 新增 `HabitsPage`。
- Windows 宽屏显示列表 + 详情两栏。
- Android/窄屏显示今日习惯列表，点击进入详情。
- 替换 `AdaptiveAppShell` 中 Habits 的占位页。
- 添加 controller 和 widget 测试。
- 更新 `task_plan.md`、`findings.md` 和 `progress.md`。

## Non-goals

- 不实现习惯提醒。
- 不接入 Calendar。
- 不实现全局 Statistics 页面。
- 不新增 schema。
- 不修改同步协议。
- 不实现复杂图表、数值目标、计时目标或多次完成目标。

## Acceptance Criteria

- [x] `HabitsController` 初始加载今日计划、active 习惯和归档习惯。
- [x] Controller 可以创建习惯并选中新习惯。
- [x] Controller 可以编辑习惯名称、提示语、图标、颜色和计划。
- [x] Controller 可以归档、取消归档和软删除习惯。
- [x] Controller 可以对今天打卡和取消今天打卡。
- [x] 选中习惯时可加载 checkins 与 `HabitStatistics`。
- [x] Habits 导航不再显示占位页。
- [x] Windows 宽屏显示习惯列表和详情两栏。
- [x] Android/窄屏可从列表进入详情，并可返回列表。
- [x] UI 有创建、编辑、归档、删除、打卡、取消打卡反馈入口。
- [x] `dart format --output=none --set-exit-if-changed lib test` 通过。
- [x] `flutter analyze` 通过。
- [x] 相关 habits/navigation/widget 测试通过。

## Constraints

- 继续使用 Riverpod AsyncNotifier。
- UI 不直接访问 Drift 数据库。
- 页面风格贴合现有 Tasks/Calendar 模块，不做营销式 landing page。
- 所有日期以本地日开始 epoch milliseconds 作为日粒度键。

## Notes

- Task 25 会实现全局 Statistics 聚合与页面。
- Task 26 会把习惯计划和打卡状态接入 Calendar。
