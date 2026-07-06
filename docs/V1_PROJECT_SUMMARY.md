# 简记 SimpleNote v1.0 项目总结

## 项目定位

简记是一款 Windows / Android 双端本地优先笔记与待办应用，目标是帮助用户在电脑和手机上管理 Markdown 笔记、日常任务和个人主题，并能在同一局域网内手动同步数据。

## v1.0 已完成功能

- Flutter Windows / Android 工程。
- 响应式应用壳：宽屏侧边导航，小屏底部导航。
- Drift + SQLite 本地数据库。
- 笔记模块：新建、编辑、删除、搜索、标签、Markdown 预览。
- 待办模块：新建、编辑、完成、删除、优先级、截止日期、筛选。
- 主题模块：预设主题、自定义颜色、自定义主题保存与恢复。
- 同步模块：本地 HTTP 服务、JSON 快照、对端地址手动同步、时间戳合并策略。
- 体验打磨：删除确认、小屏返回列表、操作反馈、轻量页面切换。
- 自动化测试：数据库、控制器、同步服务、界面流程。
- GitHub Actions：Flutter analyze/test。

## 架构特点

- `lib/features/*` 按功能模块组织代码。
- `lib/database` 统一管理 Drift 数据库、表和 DAO。
- Riverpod 管理应用状态。
- 同步使用 `dart:io` HTTP 服务和客户端，避免引入重依赖。
- 数据合并以 `updatedAt` / `deletedAt` 为核心，优先保留最新有效变更。

## 适合演示的亮点

- 一套 Flutter 代码覆盖 Windows 和 Android。
- 应用不是静态页面，数据真实落地到 SQLite。
- Markdown、标签、待办、主题和同步都形成了完整闭环。
- 同步方案是可解释的本地优先设计，不依赖云账号。
- 有阶段文档、测试和 CI，能展示工程习惯。

## 后续可继续优化

- 打包 Windows 安装包和 Android APK。
- 增加 README 截图和 1-2 分钟演示视频。
- 增加同步二维码配对或局域网设备发现。
- 增加删除撤销。
- 增加 Markdown 工具栏。
- 增加同步日志界面。
