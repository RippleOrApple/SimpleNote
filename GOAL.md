# Goal

## Objective

完成 V2 Phase 3 Task 26：习惯进入 Calendar、阶段验收、README 与发布准备。

Task 25 已经完成 Statistics 聚合与页面。本任务收尾 Phase 3：让 Calendar 同时显示任务、笔记和习惯计划/打卡状态，补齐 Phase 3 验收文档，更新 README 与 release notes，并准备 GitHub release。

## Scope

- 扩展 `CalendarEntrySource` 与 `CalendarEntryKind`，加入习惯来源。
- Calendar 聚合 active、未归档、未删除的习惯计划。
- Calendar 识别 active `habit_checkins`，把当天已打卡习惯显示为已完成。
- Calendar entry 保留习惯主题色，用于 UI 区分。
- Calendar day summary 显示 task、note、habit 计数。
- 点击习惯 entry 后切换到 Habits 页面并选中对应习惯。
- 新增或更新 Calendar repository/widget 测试。
- 创建 `docs/acceptance/V2_PHASE_3_ACCEPTANCE.md`。
- 更新 `docs/acceptance/README.md`、`docs/README.md`、`README.md`。
- 新增 Phase 3 release notes。
- 将应用版本推进到本次 Phase 3 release。
- 运行全量测试与 Windows/Android release build。

## Non-goals

- 不实现 Phase 4 V2 局域网同步。
- 不恢复旧版 V1 同步入口。
- 不新增 Calendar 月视图/周视图/拖拽编辑。
- 不实现平台原生通知插件。
- 不新增 schema。

## Acceptance Criteria

- [x] Calendar 可区分任务、笔记、习惯三类 entry。
- [x] Calendar 显示范围内应打卡的 active 习惯计划。
- [x] 已归档、已删除习惯不进入 Calendar。
- [x] active `habit_checkins` 会让对应习惯 entry 显示完成状态。
- [x] 习惯 entry 使用习惯主题色。
- [x] Calendar day summary 显示 habits 计数。
- [x] 点击习惯 entry 会进入 Habits 页面并选中该习惯。
- [x] Phase 3 acceptance 文档记录自动化命令和平台构建结果。
- [x] README 说明当前 Phase 3 能力、运行验证方式和后续 Phase 4 边界。
- [x] Release notes 描述本次 Phase 3 交付。
- [x] `dart format --output=none --set-exit-if-changed lib test` 通过。
- [x] `flutter analyze` 通过。
- [x] `flutter test` 通过。
- [x] `flutter build windows --release` 通过。
- [x] `flutter build apk --release` 通过。
- [x] GitHub release 创建并上传 Windows zip 与 Android APK。

## Constraints

- 继续使用 Drift + SQLite。
- Calendar 页面不直接访问 Drift 数据库。
- 继续保持本地优先，不引入账号服务器或云同步。
- V1 同步入口继续保持生产禁用，Phase 4 完成前不恢复。

## Notes

- 本次 release 推荐版本：`v2.1.0+4`。
- Task 27 将进入 Phase 4：V2 同步协议骨架与握手。
