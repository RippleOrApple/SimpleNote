# Goal

## Objective

完成 V2 Phase 3 Task 21：补齐 Calendar 页面。

当前项目已经有 Calendar 聚合数据层和 `CalendarController`，但导航中的 Calendar 仍停留在占位页。本任务先补一个可用的最小日历页面，为后续习惯计划、习惯打卡状态和统计入口打基础。

## Scope

- 新增真实 `CalendarPage`，替换 Calendar 占位页。
- 使用已有 `CalendarController` 默认加载 30 天范围。
- 显示任务开始、任务截止、重复任务实例和笔记创建日期 entry。
- 按日期分组显示条目，并区分任务/笔记来源与 entry 类型。
- 点击任务 entry 后切到任务模块，并选中对应任务。
- 点击笔记 entry 后切到笔记模块，并选中对应笔记。
- 保留 `source`/`kind` 扩展点，方便后续习惯 entry 接入。
- 添加 Calendar widget/navigation 测试。
- 更新 `task_plan.md`、`findings.md` 和 `progress.md`。

## Non-goals

- 不新增习惯数据库表。
- 不实现月/周/日完整复杂视图。
- 不实现拖拽改期。
- 不实现习惯 entry。
- 不改同步协议。
- 不接入真实原生通知插件。

## Acceptance Criteria

- [x] Windows 和 Android 导航进入 Calendar 后不再显示占位文案。
- [x] Calendar 页面默认使用 `CalendarController` 的 30 天范围。
- [x] Calendar 页面能显示任务、重复任务和笔记 entry。
- [x] Calendar entry 按日期分组显示。
- [x] 点击任务 entry 可以切到任务模块并选中对应任务。
- [x] 点击笔记 entry 可以切到笔记模块并选中对应笔记。
- [x] 页面结构为后续习惯 entry 保留来源/类型扩展点。
- [x] `dart format --output=none --set-exit-if-changed lib test` 通过。
- [x] `flutter analyze` 通过。
- [x] 相关 calendar/navigation/widget 测试通过。

## Constraints

- 继续使用 feature-first 结构。
- UI 不直接访问数据库。
- 页面复用现有 Riverpod provider、controller 和导航状态。
- 仅做文档规划中 Task 21 的范围，不提前做 Task 22-26。

## Notes

- Phase 3 的后续任务仍按不可删除规划推进：schema 4 与习惯领域模型、习惯仓库、习惯 UI、统计、Calendar 习惯集成与验收。
