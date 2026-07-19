# Goal

## Objective

完成 V2 Phase 3 Task 25：Statistics 聚合与页面。

Task 24 已经完成习惯应用状态与 Habits 页面。本任务实现全局统计模块：聚合任务完成事件与习惯打卡数据，提供本周、本月、本年范围，替换导航中的 Statistics 占位页。

## Scope

- 新增 `lib/features/statistics/`。
- 新增 `StatisticsRange`，支持本周、本月、本年。
- 新增 `StatisticsSummary` 领域模型。
- 新增 `StatisticsRepository` 与 Drift 实现。
- 聚合任务完成数：
  - `task_completions` active 记录。
  - 非重复任务的 `completed_at`。
- 聚合习惯统计：
  - active `habit_checkins`。
  - active、未归档习惯在范围内的计划天数。
  - 习惯完成率、当前连续周期、最长连续周期。
- 新增 `StatisticsController`。
- 新增 `StatisticsPage`。
- 替换 `AdaptiveAppShell` 中 Statistics 的占位页。
- 添加 repository、controller、page 测试。
- 更新 `task_plan.md`、`findings.md` 和 `progress.md`。

## Non-goals

- 不实现复杂图表库。
- 不实现自定义时间范围。
- 不实现 AI 总结。
- 不实现云端统计。
- 不修改同步协议。
- 不新增 schema。
- 不接入 Calendar。

## Acceptance Criteria

- [x] Repository 可按本周、本月、本年范围返回统计摘要。
- [x] 任务完成数包含 active `task_completions`。
- [x] 任务完成数包含非重复任务的 `completed_at`。
- [x] 已删除任务、已删除 completion 不参与统计。
- [x] 习惯打卡数只包含 active `habit_checkins`。
- [x] 已删除习惯、已归档习惯、已软删除打卡不参与统计。
- [x] 习惯完成率在空数据时为 0%，不显示失败感。
- [x] Controller 可切换本周、本月、本年并重新加载摘要。
- [x] Statistics 导航不再显示占位页。
- [x] Statistics 页面显示任务完成数、习惯打卡数、习惯完成率、当前连续周期、最长连续周期。
- [x] `dart format --output=none --set-exit-if-changed lib test` 通过。
- [x] `flutter analyze` 通过。
- [x] 相关 statistics/navigation/widget 测试通过。

## Constraints

- 继续使用 Drift + SQLite。
- 统计页面不直接访问 Drift 数据库。
- 首版页面使用轻量指标与趋势列表，不引入重型图表依赖。
- 日期范围使用本地日开始 epoch milliseconds，范围上界为 exclusive。

## Notes

- Task 26 会把习惯计划和打卡状态接入 Calendar，并创建 Phase 3 验收文档。
