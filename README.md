# SimpleNote

SimpleNote 是一款面向 Windows / Android 的本地优先笔记与待办应用，目标是支持 Markdown、主题高度自定义和同局域网数据同步。

## 当前状态

项目已完成第一版工程骨架：

- Flutter Windows / Android 平台目录。
- Flutter 应用入口。
- Notes / Todos / Tags / Settings / Sync 功能模块目录。
- Riverpod 状态管理骨架。
- Markdown 预览页面骨架。
- 主题系统骨架。
- 局域网同步服务与客户端骨架。
- 数据库表名与 DAO 目录占位。
- 合并策略单元测试示例。

## 技术栈

- Flutter
- Riverpod
- flutter_markdown
- SQLite / Drift，后续接入
- LAN HTTP sync，后续完善

## 文档

- [产品需求文档](docs/PRODUCT_REQUIREMENTS.md)
- [项目架构说明书](docs/ARCHITECTURE.md)
- [分阶段开发计划](docs/DEVELOPMENT_PHASES.md)
- [阶段 0 完成记录](docs/PHASE_0_SETUP_REPORT.md)

## 计划

1. 接入 Drift 和 SQLite。
2. 完成笔记编辑页、待办编辑页和主题选择器。
3. 完成局域网同步 JSON 协议和合并落库。
4. 打包 Windows 和 Android。
