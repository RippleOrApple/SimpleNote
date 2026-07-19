# SimpleNote

SimpleNote 是一款面向 Windows 和 Android 的本地优先笔记与任务应用。它使用 Flutter 构建跨平台界面，使用 Drift + SQLite 做本地持久化，目标是在没有账号、没有云服务的前提下，提供可靠的离线笔记、任务、外观自定义和后续局域网同步能力。

当前版本：`2.0.0+3`

## 当前状态

项目已经从早期的笔记/待办 MVP 进入 V2 任务系统建设阶段：

- V2 Phase 1 已完成：自适应导航、任务工作区、外观系统、Markdown 图片附件、V1 同步生产保护。
- V2 Phase 2 Task 15-20 已完成并发布到 `v2.0.0+3`：任务时间、重复任务、完成事件、日期查询、日历聚合、提醒调度接口和任务详情提醒控件。
- 当前生产环境仍禁用旧版 V1 局域网同步入口，因为旧协议无法理解 V2 任务、附件和外观数据。V2 同步会在后续 Phase 4 重新实现。
- 本地功能不依赖网络，离线可用。

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
- 笔记创建日期可作为日历聚合来源。
- 编辑不会改变笔记的创建日期归属。

### Markdown 与图片

- 任务描述和笔记正文共享 Markdown 工具栏。
- 支持标题、粗体、斜体、列表、任务列表、引用、代码、代码块、链接。
- 支持从 Windows 文件系统、Android 相册或 Android 相机插入图片。
- 图片以 `attachment://` 引用写入 Markdown，数据库不保存设备绝对路径。
- 附件导入使用事务式流程，失败不会留下无效 Markdown 引用。
- 图片支持缩略图渲染、原图查看和删除确认。

### 日历与时间

- 可按日期范围聚合任务开始/截止标记和笔记创建日期。
- 可展开重复任务的未来日期，用于后续日历视图。
- Today 和 Next 7 Days 查询同时考虑开始时间和截止时间。
- 智能筛选支持开始/截止日期范围。

### 外观与导航

- Windows 使用功能侧栏和宽屏任务工作区。
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
    calendar/           日历聚合
    navigation/         自适应应用壳
    notes/              笔记
    notifications/      本地通知调度接口
    settings/           设置
    sync/               同步与设备信息
    tasks/              V2 任务系统
test/                   单元测试、仓库测试、Widget 测试
docs/                   产品、架构、阶段计划和验收记录
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

最近一次 Task 20 验证结果：

- `dart format --output=none --set-exit-if-changed lib test`：通过。
- `flutter analyze`：通过，无问题。
- `flutter test`：通过，217 个测试。

生成代码或数据库表结构改动后运行：

```powershell
dart run build_runner build --delete-conflicting-outputs
```

## 构建说明

Windows：

```powershell
flutter build windows --debug
```

Android：

```powershell
flutter build apk --debug
```

当前 Android 构建使用 JDK 17。Windows 插件构建在干净环境中可能需要 Developer Mode 或符号链接权限；如果没有权限，需要用等效的本地构建环境处理 Flutter 生成的插件链接。

## 数据与同步边界

SimpleNote 的核心数据默认保存在本机 SQLite 数据库中。V2 阶段继续坚持本地优先：

- 不需要账号。
- 不依赖云服务。
- 不自动上传内容。
- 旧版 V1 局域网同步在生产环境中默认关闭。
- V2 局域网同步尚未启用，后续会重新设计协议以支持任务、附件、外观和提醒等结构化数据。

## 文档

- [文档索引](docs/README.md)
- [V2 Phase 1 验收记录](docs/acceptance/V2_PHASE_1_ACCEPTANCE.md)
- [V2 Phase 2 验收记录](docs/acceptance/V2_PHASE_2_ACCEPTANCE.md)
- [v2.0.0 发布说明](docs/releases/RELEASE_NOTES_v2.0.0.md)
- [v2.0.0+3 发布说明](docs/releases/RELEASE_NOTES_v2.0.0+3.md)
- [V2 设计规格](docs/superpowers/specs/2026-07-17-ticktick-style-v2-design.md)
- [V2 Phase 1 实施计划](docs/superpowers/plans/2026-07-17-phase-1-task-core-appearance-attachments.md)
- [V2 Phase 3/4 详细设计与实施计划](docs/superpowers/plans/2026-07-19-phase-3-4-habits-statistics-sync-plan-DO-NOT-DELETE.md)
- [v1/MVP 历史文档](docs/archive/v1/)
- [Codex Skills 使用记录](docs/process/SKILLS_USED.md)

## 路线图

已完成：

- P0-P7：Flutter 工程、应用壳、本地数据库、笔记、早期待办、主题、V1 局域网同步 MVP、体验打磨。
- V2 Phase 1：任务核心、新导航、新外观、任务/笔记正文图片、V1 同步生产保护。
- V2 Phase 2 Task 15-20：任务时间基础、重复任务、日期查询、日历聚合、提醒调度接口、任务详情提醒控件。

后续待确认：

- V2 Task 21：补齐 Calendar 交互页面，并承接后续习惯进入日历的扩展点。
- V2 Phase 3：习惯与统计。
- V2 Phase 4：V2 局域网同步、附件传输、最终回归与发布。

## 简历描述参考

独立设计并开发 SimpleNote，一款 Windows / Android 双端本地优先笔记与任务应用。项目基于 Flutter 构建跨平台界面，使用 Riverpod 管理应用状态，使用 Drift + SQLite 实现本地持久化和迁移，支持 Markdown 笔记、V2 任务系统、智能清单、自定义筛选、重复任务、日历聚合、正文图片附件、外观自定义和自动化测试。项目强调离线可用、无账号、本地数据优先，并为后续 V2 局域网同步保留结构化数据基础。
