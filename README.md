# 简记 SimpleNote

简记是一款面向 Windows / Android 的本地优先笔记与待办应用。项目使用 Flutter 构建跨端界面，使用 Drift + SQLite 保存本地数据，支持 Markdown 笔记、待办管理、主题自定义和同局域网手动同步。

## 当前版本

`v2.0.0`

这是一个可演示的完整 MVP，已经完成从产品需求、架构设计、分阶段开发、测试验证到发布准备的主要流程。

## 核心功能

- 笔记：新建、编辑、删除、搜索、标签筛选。
- Markdown：编辑与预览，支持标题、列表、加粗、链接、代码块等常用语法。
- 待办：新建、编辑、完成/取消完成、删除、优先级、截止日期、状态筛选。
- 本地存储：数据保存在本机 SQLite 数据库中，离线可用。
- 主题自定义：预设主题、背景色、主按钮色、文字色、面板色、浅色/深色切换、自定义主题保存。
- 局域网同步：同 Wi-Fi 下通过手动输入对端地址交换 JSON 快照。
- 体验打磨：小屏编辑返回、删除确认、操作反馈、轻量路由切换。

## 技术栈

- Flutter / Dart
- Riverpod
- Drift / SQLite
- flutter_markdown
- dart:io HTTP Server / Client
- GitHub Actions

## 运行方式

```powershell
D:\DevEnv\Flutter\bin\flutter.bat pub get
D:\DevEnv\Flutter\bin\flutter.bat run -d windows
```

Android 运行需要连接真机或启动模拟器。

## 验证

```powershell
D:\DevEnv\Flutter\bin\flutter.bat analyze
D:\DevEnv\Flutter\bin\flutter.bat test
```

当前测试覆盖数据库、笔记、待办、主题、局域网同步和主要界面流程。

## 项目文档

- [产品需求文档](docs/PRODUCT_REQUIREMENTS.md)
- [项目架构说明书](docs/ARCHITECTURE.md)
- [分阶段开发计划](docs/DEVELOPMENT_PHASES.md)
- [v1.0 项目总结](docs/V1_PROJECT_SUMMARY.md)
- [v1.0 发布说明](docs/RELEASE_NOTES_v1.0.0.md)
- [v1.0.1 发布说明](docs/RELEASE_NOTES_v1.0.1.md)
- [v2.0.0 发布说明](docs/RELEASE_NOTES_v2.0.0.md)
- [Codex Skills 使用记录](docs/SKILLS_USED.md)

## 阶段完成情况

- P0：工程环境与 Flutter 工程初始化，已完成。
- P1：基础应用壳与页面导航，已完成。
- P2：本地数据库接入，已完成。
- P3：笔记 MVP，已完成。
- P4：待办 MVP，已完成。
- P5：主题自定义，已完成。
- P6：局域网同步 MVP，已完成。
- P7：体验打磨与异常处理，已完成。
- P8：测试、打包与作品展示，当前收尾阶段。

## 简历描述参考

独立设计并开发“简记 SimpleNote”，一款 Windows / Android 双端本地优先笔记待办应用。项目基于 Flutter 构建跨端界面，使用 Drift + SQLite 实现本地持久化，支持 Markdown 编辑预览、标签搜索、待办优先级与截止时间、主题高度自定义，并实现了基于局域网 HTTP 和时间戳合并策略的数据同步 MVP。项目配套自动化测试与 GitHub Actions，覆盖需求分析、产品设计、架构设计、开发实现、测试验证和发布准备。

## V2 Phase 1

V2 Phase 1 已加入自适应导航、完整任务工作区、跨平台外观设置，以及笔记和任务正文图片。旧版局域网同步协议无法识别这些数据，生产版本已禁用 V1 同步入口；V2 同步将在 Phase 4 启用，本地功能不受影响。

构建说明：Windows 插件构建需要启用 Developer Mode 或具备符号链接权限；Android 构建使用 JDK 17。完整验收结果见 [V2 Phase 1 验收记录](docs/V2_PHASE_1_ACCEPTANCE.md)。
