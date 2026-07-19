# v2.0.0+3 发布说明

## 版本定位

这是 V2 Phase 2 阶段性发布，基于 v2.0.0 的任务核心继续补齐任务时间、重复任务、日历聚合和提醒管理基础。

## 主要更新

- 增加任务开始时间、截止时间、全天任务和提醒数据基础。
- 增加重复任务完成事件记录和下一次日期推进。
- Today、Next 7 Days 和智能筛选支持更完整的开始/截止日期范围。
- 增加只读日历聚合数据层，可聚合任务时间标记、重复任务实例和笔记创建日期。
- 增加本地通知调度接口、提醒 reconciliation 流程和任务详情页提醒控件。
- 更新 README，使项目状态、运行方式、验证方式和后续路线图与当前 V2 状态一致。

## 验证结果

- `dart format --output=none --set-exit-if-changed lib test`：通过，177 个文件未修改。
- `flutter analyze`：通过，无问题。
- `flutter test`：通过，217 个测试。
- `flutter build windows --release`：通过，产物为 `build/windows/x64/runner/Release/simple_note.exe`。
- `flutter build apk --release`：通过，产物为 `build/app/outputs/flutter-apk/app-release.apk`。

## 已知限制

- V2 局域网同步尚未启用，生产环境仍禁用旧版 V1 同步入口。
- 本地通知目前通过接口和调度流程抽象完成，原生通知权限和插件接入仍属后续任务。
- Calendar、Habits 和 Statistics 的完整交互页面仍待后续任务实现。
