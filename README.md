# SimpleNote

SimpleNote 是一款面向 Windows 和 Android 的本地优先个人效率应用。它使用 Flutter 构建跨平台界面，使用 Drift + SQLite 管理本地数据，目标是在没有账号、没有云服务、没有远端服务器的前提下，提供稳定的离线笔记、任务、日历、习惯和统计能力。

当前版本：`2.1.0+4`

当前发布：`v2.1.0+4`

## 当前状态

- V2 Phase 1 已完成：自适应导航、任务工作区、外观系统、Markdown 图片附件、V1 同步生产保护。
- V2 Phase 2 已完成：任务时间、重复任务、完成事件、日期查询、日历聚合数据层、提醒调度抽象、任务详情提醒控件。
- V2 Phase 3 已完成：Calendar 页面、习惯 schema/domain/repository/controller/UI、Statistics 聚合与页面、习惯进入 Calendar。
- V2 Phase 4 尚未完成：V2 局域网同步、结构化快照、文件传输、冲突合并、备份/导入/导出和最终交付。
- 生产环境仍禁用旧 V1 局域网同步入口。旧协议不能理解 V2 任务、附件、外观、习惯和统计数据，必须等 Phase 4 的 V2 同步完成后再恢复。

## 功能概览

### 任务

- 收集箱、今天、未来 7 天、全部任务等内置智能清单。
- 自定义清单、任务标签、智能筛选。
- 标题、Markdown 描述、优先级、开始时间、截止时间、全天任务。
- 一层子任务。
- 搜索、排序、显示/隐藏已完成任务。
- 重复任务完成推进，支持每日、工作日、每周、每月、每年和间隔规则。
- 任务完成事件记录。
- 任务提醒定义、调度接口和详情页提醒控件。

### 笔记

- 笔记创建、编辑、删除、搜索和标签筛选。
- Markdown 编辑与预览。
- 笔记创建日期可作为 Calendar 来源。
- 编辑不会改变笔记的创建日期归属。

### Markdown 与图片

- 任务描述和笔记正文共享 Markdown 工具栏。
- 支持标题、粗体、斜体、列表、任务列表、引用、代码、代码块和链接。
- 支持从 Windows 文件系统、Android 相册或 Android 相机插入图片。
- 图片以 `attachment://` 引用写入 Markdown，数据库不保存设备绝对路径。
- 附件导入使用事务式流程，失败不会留下无效 Markdown 引用。
- 图片支持缩略图渲染、原图查看和删除确认。

### Calendar

- Calendar 是真实页面，不再是占位模块。
- 按日期聚合任务开始/截止、重复任务未来发生、笔记创建日期和习惯计划。
- 可区分任务、笔记、习惯三类 entry。
- 习惯 entry 使用习惯主题色，并根据当天 active checkin 显示完成状态。
- 点击任务、笔记、习惯 entry 可跳转到对应模块并选中来源对象。

### 习惯

- 创建、编辑、归档、取消归档和软删除习惯。
- 支持每日、工作日、每周指定星期、每 N 天间隔计划。
- 支持今日打卡和取消今日打卡。
- 保留历史打卡，取消打卡使用软删除，便于后续同步合并。
- 计算计划天数、完成天数、完成率、当前连续周期和最长连续周期。
- Windows 使用列表 + 详情双栏，Android 使用列表/详情切换。

### Statistics

- 支持本周、本月、本年范围。
- 聚合任务完成数：active `task_completions` 与非重复任务 `completed_at`。
- 聚合习惯打卡数、习惯计划天数、习惯完成率、当前连续周期和最长连续周期。
- 空数据展示中性 0 值，不制造失败感。

### 外观与导航

- Windows 使用功能侧栏和宽屏工作区。
- Android 使用图标式底部导航。
- 支持导航顺序、可见性和默认入口设置。
- 支持全局背景、预设背景图、主题色、自定义 RGB/HEX、字体、密度、动效和触感偏好。
- Windows 和 Android 分别保存适合本机的密度、导航、背景裁剪和触感设置。

## 技术栈

- Flutter / Dart
- Riverpod
- Drift / SQLite
- flutter_markdown
- file_picker / image_picker
- GitHub Actions

## 项目结构

```text
lib/
  database/             Drift 数据库、表定义、迁移
  features/
    appearance/         外观、主题、背景、导航偏好
    attachments/        Markdown 图片附件、导入、渲染
    calendar/           日历聚合与 Calendar 页面
    habits/             习惯领域、仓储、状态和页面
    navigation/         自适应应用壳
    notes/              笔记
    notifications/      本地通知调度接口
    settings/           设置
    statistics/         统计聚合与页面
    sync/               同步与设备信息；生产环境禁用旧 V1 同步入口
    tasks/              V2 任务系统
test/                   单元测试、仓储测试、widget 测试
docs/                   产品、架构、阶段计划、验收和发布记录
scripts/                发布和 PR 辅助脚本
windows/ android/       平台工程
```

## 运行

先确保本机已经安装 Flutter，并且 Windows / Android 所需平台工具可用。

```powershell
flutter pub get
flutter run -d windows
```

Android 运行需要连接真机或启动模拟器：

```powershell
flutter devices
flutter run -d <device-id>
```

## 验证

常规提交前检查：

```powershell
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

涉及数据库生成代码或表结构改动后运行：

```powershell
dart run build_runner build --delete-conflicting-outputs
```

发布构建：

```powershell
flutter build windows --release
flutter build apk --release
```

当前 Phase 3 release 验收记录见：`docs/acceptance/V2_PHASE_3_ACCEPTANCE.md`。

## 数据与同步边界

SimpleNote 的核心数据默认保存在本机 SQLite 数据库中。V2 阶段继续坚持本地优先：

- 不需要账号。
- 不依赖云服务。
- 不自动上传内容。
- 旧版 V1 局域网同步在生产环境中默认关闭。
- V2 局域网同步尚未启用，后续 Phase 4 会重新设计协议，以支持任务、笔记、附件、外观、习惯和统计相关结构化数据。

## 文档

- [文档索引](docs/README.md)
- [V2 Phase 1 验收记录](docs/acceptance/V2_PHASE_1_ACCEPTANCE.md)
- [V2 Phase 2 验收记录](docs/acceptance/V2_PHASE_2_ACCEPTANCE.md)
- [V2 Phase 3 验收记录](docs/acceptance/V2_PHASE_3_ACCEPTANCE.md)
- [v2.0.0+3 发布说明](docs/releases/RELEASE_NOTES_v2.0.0+3.md)
- [v2.1.0+4 发布说明](docs/releases/RELEASE_NOTES_v2.1.0+4.md)
- [V2 设计规格](docs/superpowers/specs/2026-07-17-ticktick-style-v2-design.md)
- [V2 Phase 3/4 详细设计与实施计划](docs/superpowers/plans/2026-07-19-phase-3-4-habits-statistics-sync-plan-DO-NOT-DELETE.md)
- [v1/MVP 历史文档](docs/archive/v1/)
- [Codex Skills 使用记录](docs/process/SKILLS_USED.md)

## 路线图

已完成：

- P0-P7：Flutter 工程、应用壳、本地数据库、笔记、早期待办、主题、V1 局域网同步 MVP、体验打磨。
- V2 Phase 1：任务核心、新导航、新外观、任务/笔记正文图片、V1 同步生产保护。
- V2 Phase 2：任务时间基础、重复任务、日期查询、日历聚合、提醒调度接口、任务详情提醒控件。
- V2 Phase 3：Calendar 页面、习惯、统计、习惯进入 Calendar。

下一阶段：

- V2 Phase 4：V2 局域网同步、结构化快照、附件传输、冲突合并、二维码/手动配对、备份、导出、导入和最终验收发布。

## 简历描述参考

独立设计并开发 SimpleNote，一款 Windows / Android 双端本地优先笔记与个人效率应用。项目基于 Flutter 构建跨平台界面，使用 Riverpod 管理应用状态，使用 Drift + SQLite 实现本地持久化和迁移，支持 Markdown 笔记、V2 任务系统、智能清单、自定义筛选、重复任务、日历聚合、正文图片附件、习惯追踪、统计面板、外观自定义和自动化测试。项目强调离线可用、无账号、本地数据优先，并为后续 V2 局域网同步保留结构化数据基础。
