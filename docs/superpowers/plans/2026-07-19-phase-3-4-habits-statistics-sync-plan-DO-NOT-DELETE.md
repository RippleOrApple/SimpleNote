# SimpleNote V2 Phase 3/4 详细设计与实施计划

> **不可删除。**
>
> 本文档是 SimpleNote V2 后半段开发的长期蓝图，必须保留在仓库中。后续任务、自动化代理、人工维护和发布回归都应先阅读本文档，再修改 `GOAL.md` 或创建具体实现计划。

## 1. 文档定位

- 日期：2026-07-19
- 适用阶段：V2 Phase 3、V2 Phase 4
- 当前基线：`v2.0.0+3`
- 当前分支：`codex/ticktick-v2-phase2-continuation`
- 设计蓝本：`docs/superpowers/specs/2026-07-17-ticktick-style-v2-design.md`
- 本文性质：详细设计与阶段拆分，不是单次编码任务

本文只承接既有蓝本，不重新发明产品方向。已经完成的 Phase 1/2 继续作为基础能力保留：

- Phase 1 已完成任务核心、新应用壳、外观系统、任务/笔记正文图片、V1 同步生产保护。
- Phase 2 已完成任务时间基础、重复任务完成事件、日期查询、日历聚合数据层、提醒调度接口和任务详情提醒控件。
- 旧 V1 同步仍不得在生产环境恢复；V2 同步由 Phase 4 统一处理。

## 2. 总体原则

- 保留 SimpleNote 的本地优先思想。
- 不引入账号系统、云服务、多人协作、Web 客户端或第三方后端。
- 数据仍由 Drift + SQLite 管理，所有新增实体都要有迁移、仓库、领域模型和测试。
- 继续采用 feature-first 目录结构，保持 presentation、application、domain、data、infrastructure 分层。
- Phase 3 只做习惯与统计，不做同步。
- Phase 4 最后做同步、回归、构建和交付，因为此时 V2 数据模型才稳定。
- 不复制 TickTick 的名称、图标、插画或品牌资产，只复用“个人效率软件的信息结构和操作效率”。

## 3. 当前真实状态

当前代码已有：

- `lib/features/tasks/`：V2 任务系统、清单、标签、智能筛选、重复任务、提醒 UI。
- `lib/features/calendar/`：日历聚合的 domain、repository、controller，但导航里的 Calendar 页面仍是占位页。
- `lib/features/notifications/`：通知调度抽象和 no-op 默认适配器。
- `lib/features/sync/`：V1 同步兼容代码和生产禁用提示。
- `lib/features/appearance/`：外观、背景、颜色、字体、密度、导航设置。
- `lib/features/attachments/`：任务/笔记正文图片、事务导入、缩略图、恢复提示。

当前缺口：

- 没有 `lib/features/habits/`。
- 没有真正的 Statistics 模块。
- Calendar 没有真实展示页面，只有数据聚合能力。
- 系统通知尚未接入 `flutter_local_notifications` 或 Windows 原生通知。
- V2 同步协议、附件传输、背景图同步和 V2 冲突规则尚未实现。

## 4. Phase 3 目标：习惯与统计

Phase 3 的目标是补齐蓝本中的“习惯与统计”，让应用从任务/笔记工具升级成完整的本地个人效率面板。

阶段完成后应具备：

- 用户可创建、编辑、归档和删除习惯。
- 用户可为习惯设置名称、提示语、图标、主题色、间隔计划和提醒。
- 用户可完成当日打卡、取消打卡、补卡，并查看打卡历史。
- 应用可计算连续周期、完成率、周/月/年完成趋势。
- Statistics 模块可聚合任务完成事件与习惯打卡数据。
- Calendar 可显示习惯计划和完成状态。
- 所有能力离线可用，不依赖同步。

## 5. Phase 3 数据设计

### 5.1 `habits`

新增 schema 4 表。

字段：

```text
id TEXT PRIMARY KEY
name TEXT NOT NULL
prompt TEXT NOT NULL DEFAULT ''
icon_key TEXT NOT NULL
color INTEGER NOT NULL
schedule_type TEXT NOT NULL
schedule_json TEXT NOT NULL
sort_order INTEGER NOT NULL DEFAULT 0
archived INTEGER NOT NULL DEFAULT 0
created_at INTEGER NOT NULL
updated_at INTEGER NOT NULL
deleted_at INTEGER NULL
device_id TEXT NOT NULL
version INTEGER NOT NULL DEFAULT 1
```

约束：

- `name` 去除首尾空白后不能为空。
- `icon_key` 必须来自内置 Phosphor Duotone 图标白名单，首版使用 48 个图标。
- `color` 必须是 `0..0xFFFFFF`。
- `schedule_type` 只允许 `daily`、`weekdays`、`weekly`、`interval`。
- `schedule_json` 必须可由 domain 层解析，不在表层保存自然语言。
- 删除采用软删除。

### 5.2 `habit_checkins`

新增 schema 4 表。

字段：

```text
id TEXT PRIMARY KEY
habit_id TEXT NOT NULL
checkin_day INTEGER NOT NULL
status TEXT NOT NULL
note TEXT NOT NULL DEFAULT ''
created_at INTEGER NOT NULL
updated_at INTEGER NOT NULL
deleted_at INTEGER NULL
device_id TEXT NOT NULL
version INTEGER NOT NULL DEFAULT 1
```

约束：

- `checkin_day` 使用本地日开始时间的 epoch milliseconds。
- `status` 首版只允许 `done`。
- 同一个未删除习惯在同一天只能有一条 active checkin。
- 取消打卡不物理删除记录，写软删除，便于 Phase 4 同步合并。

### 5.3 索引

schema 4 创建：

```sql
CREATE INDEX habits_active_order
ON habits(archived, sort_order, updated_at)
WHERE deleted_at IS NULL;

CREATE UNIQUE INDEX habit_checkins_active_day
ON habit_checkins(habit_id, checkin_day)
WHERE deleted_at IS NULL;

CREATE INDEX habit_checkins_day_active
ON habit_checkins(checkin_day, habit_id)
WHERE deleted_at IS NULL;
```

## 6. Phase 3 模块设计

新增目录：

```text
lib/features/habits/
  application/habits_controller.dart
  data/habits_repository.dart
  domain/habit.dart
  domain/habit_checkin.dart
  domain/habit_schedule.dart
  domain/habit_statistics.dart
  presentation/habits_page.dart
  presentation/habit_list_pane.dart
  presentation/habit_detail_pane.dart
  presentation/habit_editor.dart

lib/features/statistics/
  application/statistics_controller.dart
  data/statistics_repository.dart
  domain/statistics_summary.dart
  domain/statistics_range.dart
  presentation/statistics_page.dart
```

数据库层新增：

```text
lib/database/tables/habits_table.dart
lib/database/tables/habit_checkins_table.dart
lib/database/daos/habits_dao.dart
lib/database/migrations/schema_v4_migration.dart
```

测试目录新增：

```text
test/habits/
test/statistics/
```

## 7. Phase 3 交互设计

### 7.1 Windows

Windows 继续使用现有功能侧栏。

- 点击 Habits 进入习惯模块。
- 宽屏使用两栏：左侧习惯列表，右侧习惯详情。
- 习惯列表包含今日计划、全部 active 习惯和已归档入口。
- 习惯详情展示今日打卡按钮、提示语、连续周期、最近 30 天热力格和编辑入口。
- 不使用卡片套卡片；模块区域遵循现有全局背景和中性纸张表面规则。

### 7.2 Android

Android 底部导航已有 Habits 入口。

- 首屏展示今日习惯。
- 点击习惯进入详情页。
- 详情页纵向布局，提示语、统计卡、历史区域不得重叠。
- 打卡按钮使用熟悉的勾选或圆形完成控件，不新增复杂手势。
- 列表项触控目标不小于 48dp。

### 7.3 习惯创建

首版创建表单包含：

- 名称。
- 提示语。
- 图标。
- 主题色。
- 计划类型。
- 提醒开关。

计划类型首版只做：

- 每天。
- 工作日。
- 每周指定星期。
- 每 N 天。

不做：

- 数值目标。
- 计时目标。
- 多次完成目标。
- 社交挑战。
- 番茄钟。

### 7.4 习惯提醒

Phase 3 只把习惯提醒纳入领域和调度抽象，不强行完成平台通知插件。

策略：

- 如果 Phase 2 的任务提醒仍是 no-op 适配器，习惯提醒也使用同一通知接口。
- 提醒创建、删除、习惯打卡和习惯归档后触发 reconciliation。
- 原生通知插件可作为 Phase 3 后段或 Phase 4 前置任务，但不能阻塞习惯数据闭环。

## 8. Phase 3 统计设计

Statistics 模块聚合两个来源：

- 任务：`task_completions` 和非重复任务的 `completed_at`。
- 习惯：`habit_checkins`。

首版统计范围：

- 本周。
- 本月。
- 本年。

首版指标：

- 任务完成数。
- 任务完成趋势。
- 习惯打卡数。
- 习惯完成率。
- 当前连续打卡周期。
- 最长连续打卡周期。

不做：

- 云端排行榜。
- 时间追踪。
- 复杂图表编辑。
- 预测或 AI 总结。

## 9. Phase 3 Calendar 集成

Calendar 当前已有任务和笔记聚合层。Phase 3 应扩展为：

- 计划当天应打卡的习惯显示为 habit planned entry。
- 已打卡习惯显示完成状态。
- Calendar entry 使用习惯主题色。
- 点击习惯 entry 打开习惯详情。

如果 Calendar UI 在 Phase 3 开始前仍未实现，应先做一个最小 Calendar 页面：

1. 月/列表组合视图。
2. 展示现有任务和笔记 entry。
3. 再加入习惯 entry。

这个 Calendar UI 可以作为 Phase 3 Task 1，因为它会影响习惯如何进入日历。

## 10. Phase 3 任务拆分

### Task 21：Calendar 页面补齐

目标：

- 将 Calendar 从占位页替换为真实页面。
- 使用已有 `CalendarController` 展示日期范围。
- 支持任务、重复任务和笔记 entry。
- 为后续习惯 entry 留出 source/kind 扩展点。

验收：

- Windows 和 Android 导航进入 Calendar 不再显示占位文案。
- 默认加载 30 天范围。
- 点击任务或笔记 entry 可打开对应详情或选中对应对象。
- `flutter analyze` 和相关 calendar/widget 测试通过。

### Task 22：schema 4 与习惯领域模型

目标：

- 添加 `habits`、`habit_checkins`、schema v4 migration。
- 添加 `Habit`、`HabitCheckin`、`HabitSchedule`。
- 覆盖 schema 1/2/3 到 4 的迁移。

验收：

- 新表创建、约束和索引正确。
- schema 3 数据升级前会创建备份。
- 旧任务、笔记、外观和附件数据不受影响。

### Task 23：习惯仓库与统计计算基础

目标：

- 实现习惯 CRUD。
- 实现今日计划查询。
- 实现打卡、取消打卡、补卡。
- 实现完成率和连续周期计算。

验收：

- 同一天重复打卡不会产生重复 active 记录。
- 取消打卡写软删除。
- 连续周期在跨周、跨月和间隔计划下正确。

### Task 24：习惯应用状态与 Windows/Android UI

目标：

- 添加 `habitsControllerProvider`。
- 添加 `HabitsPage`、列表、详情、编辑器。
- 替换 Habits 占位页。
- 接入导航、外观、触感、减少动态效果。

验收：

- Windows 宽屏两栏可用。
- Android 今日习惯列表和详情可用。
- 创建、编辑、归档、删除、打卡、取消打卡都有反馈。
- 短屏不发生文字和统计区域重叠。

### Task 25：Statistics 聚合与页面

目标：

- 添加 Statistics repository/controller/page。
- 聚合任务完成和习惯打卡。
- 支持本周、本月、本年范围。
- 替换 Statistics 占位页。

验收：

- 统计页展示任务完成数、习惯完成率、趋势和连续周期。
- 已删除任务、已删除习惯、已软删除打卡不参与统计。
- 空状态清晰，不显示误导性 0% 失败感。

### Task 26：习惯进入 Calendar 与阶段验收

目标：

- Calendar 聚合习惯计划和打卡状态。
- 记录 Phase 3 验收文档。
- 运行全量测试和双平台构建。

验收：

- Calendar 可区分任务、笔记、习惯。
- Phase 3 acceptance 文档记录自动化命令和平台烟测。
- `dart format`、`flutter analyze`、`flutter test`、Windows build、Android build 通过。

## 11. Phase 4 目标：V2 同步、回归与交付

Phase 4 只在 V2 数据模型稳定后开始。目标是恢复并升级局域网同步，使两台设备能安全同步所有 V2 数据和必要文件。

阶段完成后应具备：

- V2 协议握手和版本能力检查。
- V2 结构化数据快照。
- 正文附件和可同步背景图的哈希清单。
- 文件传输、校验、去重和原子落盘。
- 所有 V2 实体的冲突、软删除和合并规则。
- 同步后本地提醒 reconciliation。
- 版本不兼容时明确拒绝，不静默覆盖。
- Windows / Android 全量回归和最终发布。

## 12. Phase 4 同步协议设计

### 12.1 协议原则

- 用户主动启动服务和同步。
- 不做云中继。
- 不自动发现并同步未知设备。
- V1 和 V2 协议不互通。
- 所有写入在数据库事务内完成。
- 文件必须先校验再提交元数据。

### 12.2 推荐端点

保留兼容端点但升级能力：

```text
GET  /health
GET  /device
POST /sync/v2/handshake
GET  /sync/v2/manifest
POST /sync/v2/plan
GET  /sync/v2/file/:sha256
POST /sync/v2/file
POST /sync/v2/commit
POST /sync/v2/backup
POST /sync/v2/export
POST /sync/v2/import
```

说明：

- `/handshake` 交换应用版本、协议版本、schema version、设备 ID 和能力。
- `/manifest` 返回结构化实体版本摘要、附件哈希清单、背景图哈希清单。
- `/plan` 生成本轮需要传输和合并的计划。
- `/file` 只传缺失的内容寻址文件。
- `/commit` 在文件就绪后提交元数据合并。
- `/backup`、`/export`、`/import` 为 Phase 4 的交付和恢复能力服务。

### 12.3 配对与安全

首版不做账号，也不做复杂证书体系。

推荐方案：

- Windows 端显示局域网地址和一次性配对码。
- Android 扫二维码或手动输入地址。
- 配对码只在本轮握手有效。
- 配对成功后记录对端设备 ID 和用户确认的设备名称。
- 后续同步仍需用户主动触发。

暂不做：

- 后台自动同步。
- NAT 穿透。
- 公网同步。
- 多人共享空间。

## 13. Phase 4 数据设计

### 13.1 schema 5

schema 5 扩展：

- 同步日志记录 V2 统计字段。
- 附件同步状态。
- 可同步背景图状态。
- 对端设备记录。
- 清理队列。

建议新增或扩展：

```text
sync_peers
sync_runs
sync_file_manifests
file_cleanup_queue
```

### 13.2 不进入同步的字段

以下字段不跨设备覆盖：

- `content_attachments.relative_path`
- `content_attachments.thumbnail_relative_path`
- `background_images.relative_path`
- `device_appearance_profiles.*`
- 平台通知生成的 notification ID
- 临时文件路径
- 本机窗口尺寸和运行态选择

### 13.3 进入同步的实体

Phase 4 必须覆盖：

- notes
- note tags
- task lists
- tasks v2
- task tags
- task tag links
- smart filters
- task reminders
- task completions
- habits
- habit checkins
- content attachments metadata
- custom colors
- portable appearance settings
- sync-enabled background image metadata

## 14. Phase 4 合并规则

基础规则：

- 每个 syncable 实体继续使用 `updated_at`、`deleted_at`、`device_id`、`version`。
- 删除是软删除，不物理删除业务记录。
- 最后有效变更时间较新的记录胜出。
- 时间相同时使用 `device_id` 字典序作为确定性 tie-breaker。
- 关联表缺失父实体时进入待修复状态，不直接写入悬挂关系。

特殊规则：

- 附件元数据提交前必须确认文件已落盘。
- Markdown 引用的 attachment ID 必须有对应 metadata；缺失时显示占位，不崩溃。
- 背景图只有 `sync_enabled=true` 才传输。
- “仅本机”背景不改变远端设备。
- 设备外观档案不参与同步。
- 同步完成后重新调度本地任务和习惯提醒。

## 15. Phase 4 任务拆分

### Task 27：V2 同步协议骨架和握手

目标：

- 添加 V2 protocol version。
- 添加 peer/device capability 模型。
- 明确拒绝 V1/V2 不兼容同步。
- 保留生产环境旧同步禁用提示，直到 V2 完整恢复。

验收：

- V1 peer 与 V2 peer 不会互相覆盖。
- 协议不兼容时有明确 UI 文案。
- `sync_controller_test` 覆盖禁用、握手成功、握手失败。

### Task 28：结构化快照与合并计划

目标：

- 为所有 V2 实体生成 manifest。
- 生成确定性 merge plan。
- 不包含本机路径和设备外观字段。

验收：

- 两个临时数据库可比较新增、更新、删除差异。
- manifest 序列化稳定。
- 删除墓碑参与计划。

### Task 29：文件传输、校验与去重

目标：

- 实现附件和 sync-enabled 背景图的哈希清单。
- 只传缺失 SHA-256。
- 临时落盘后校验长度和哈希。
- 原子移动到正式路径。

验收：

- 错误哈希不会提交数据库合并。
- 重复文件不产生重复物理文件。
- 传输中断可以重试。

### Task 30：事务提交与冲突规则

目标：

- 在所有文件就绪后提交结构化数据。
- 实现所有 V2 实体的冲突处理。
- 同步后刷新任务、习惯、日历和提醒。

验收：

- 任一必需附件失败时本轮数据库不提交。
- 同步完成后查询结果一致。
- 本地通知 reconciliation 被触发。

### Task 31：配对、二维码和恢复能力

目标：

- 添加二维码配对或手动地址配对。
- 添加 peer 记录。
- 添加 backup/export/import。

验收：

- 用户可明确看到对端设备名称和地址。
- 配对码过期后不可继续使用。
- backup/export/import 不破坏原数据库。

### Task 32：Phase 4 全量回归与正式交付

目标：

- 创建 Phase 4 acceptance 文档。
- Windows/Android 真机或模拟器同步烟测。
- 性能验证。
- 发布构建。
- 更新 README 和 release notes。

验收：

- `dart format` 通过。
- `flutter analyze` 通过。
- `flutter test` 通过。
- Windows release build 通过。
- Android release APK build 通过。
- GitHub release 上传 Windows zip 和 Android APK。

## 16. 推荐推进顺序

推荐路线：

1. Phase 3 先补 Calendar UI，因为习惯要进入日历。
2. 再做习惯 schema 和领域模型。
3. 再做习惯 repository/controller/UI。
4. 再做统计聚合和 Statistics UI。
5. Phase 3 结束后创建验收文档和 release。
6. Phase 4 再恢复同步，不提前打开旧同步入口。

不推荐路线：

- 不要先做同步。
- 不要一边改数据模型一边改同步协议。
- 不要先接通知插件再完成习惯闭环。
- 不要把习惯和任务混用一张表。

## 17. 文档和任务管理规则

- 每个具体 Task 开始前，先更新 `GOAL.md`。
- 每个 Task 应在 `progress.md` 写 Planning、Implementation、Verification、Handoff。
- 重要问题写入根目录的问题手册：`DO_NOT_DELETE_RELEASE_AND_WORKFLOW_TROUBLESHOOTING.md`。
- Phase 3 完成后新增 `docs/acceptance/V2_PHASE_3_ACCEPTANCE.md`。
- Phase 4 完成后新增 `docs/acceptance/V2_PHASE_4_ACCEPTANCE.md`。
- 本文档不可删除；如需修订，只能追加“修订记录”，不能直接移除历史决策。

## 18. 验证命令

每个阶段至少运行：

```powershell
D:\DevEnv\Flutter\bin\dart.bat format --output=none --set-exit-if-changed lib test
D:\DevEnv\Flutter\bin\flutter.bat analyze
D:\DevEnv\Flutter\bin\flutter.bat test
```

涉及数据库生成代码时运行：

```powershell
D:\DevEnv\Flutter\bin\dart.bat run build_runner build --delete-conflicting-outputs
```

阶段 release 前运行：

```powershell
D:\DevEnv\Flutter\bin\flutter.bat build windows --release
D:\DevEnv\Flutter\bin\flutter.bat build apk --release
```

## 19. 修订记录

- 2026-07-19：创建 Phase 3/4 详细设计与实施计划，承接 `2026-07-17-ticktick-style-v2-design.md`，明确 Task 21-32 的推荐拆分。
