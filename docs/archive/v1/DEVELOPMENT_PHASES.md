# SimpleNote 分阶段开发计划

> **历史文档。**
>
> 本文是 v1/MVP 阶段的开发计划，P0-P7 已完成。当前后续开发不是继续执行本文的旧阶段，而是沿用 V2 设计蓝本和 `../../superpowers/plans/2026-07-19-phase-3-4-habits-statistics-sync-plan-DO-NOT-DELETE.md`。

## 1. 总体节奏

SimpleNote 建议拆成 8 个小阶段开发。每个阶段都应该产出一个可以验证的结果，避免一开始同时做笔记、待办、主题、同步和打包，导致项目变得混乱。

推荐周期：

- 快速 MVP：7-10 天。
- 稳定可展示版本：14-21 天。
- 适合投递的打磨版本：21-30 天。

核心原则：

- 先让应用跑起来。
- 再让数据能保存。
- 然后完善笔记和待办。
- 接着做主题自定义。
- 最后做局域网同步和打包展示。

## 2. 阶段 0：开发环境与工程初始化

### 目标

让项目变成一个真正可运行的 Flutter Windows / Android 工程。

### 建议耗时

0.5-1 天。

### 主要任务

- 安装 Flutter SDK。
- 配置 Android Studio 或 VS Code。
- 检查 Windows 桌面开发环境。
- 在项目根目录生成 Flutter 平台文件。
- 拉取依赖。
- 运行默认应用。

### 推荐命令

```powershell
flutter doctor
flutter create . --platforms=windows,android
flutter pub get
flutter run -d windows
```

### 产出

- Windows 端可以启动。
- Android 端可以通过模拟器或真机启动。
- `pubspec.yaml` 依赖可以正常安装。

### 验收标准

- `flutter doctor` 没有关键阻塞项。
- `flutter run -d windows` 能打开应用窗口。
- Android 设备或模拟器能识别并运行项目。

## 3. 阶段 1：基础应用壳与页面导航

### 目标

完成应用的基础结构，让用户能在笔记、待办、设置三个核心页面之间切换。

### 建议耗时

1 天。

### 主要任务

- 完善 `AppShell`。
- 完善底部导航或 Windows 侧边导航。
- 建立 Notes、Todos、Settings 三个页面。
- 建立统一的主题入口。
- 统一页面标题、空状态和基础按钮样式。

### 涉及文件

- `lib/app.dart`
- `lib/core/routing/app_routes.dart`
- `lib/shared/widgets/app_shell.dart`
- `lib/features/notes/presentation/notes_page.dart`
- `lib/features/todos/presentation/todos_page.dart`
- `lib/features/settings/presentation/settings_page.dart`

### 产出

- 应用有清晰的主界面。
- 用户可以切换笔记、待办、设置。
- 空状态页面看起来简洁明确。

### 验收标准

- 点击导航不会报错。
- 三个页面都能正常进入。
- 页面结构在 Windows 和 Android 上都不明显错位。

## 4. 阶段 2：本地数据库接入

### 目标

接入 SQLite / Drift，让笔记、待办、标签、主题等数据可以本地持久化。

### 建议耗时

2-3 天。

### 主要任务

- 在 `pubspec.yaml` 加入 Drift、SQLite 相关依赖。
- 定义数据库表。
- 建立 DAO。
- 建立 Repository 实现。
- 完成数据库初始化。
- 完成基础迁移策略。

### 推荐依赖

```yaml
dependencies:
  drift: ^2.20.0
  drift_flutter: ^0.2.0
  path_provider: ^2.1.4
  path: ^1.9.0

dev_dependencies:
  drift_dev: ^2.20.0
  build_runner: ^2.4.11
```

### 涉及文件

- `lib/database/app_database.dart`
- `lib/database/tables/`
- `lib/database/daos/`
- `lib/features/notes/data/notes_repository.dart`
- `lib/features/todos/data/todos_repository.dart`
- `lib/features/tags/data/tags_repository.dart`
- `lib/features/settings/data/theme_repository.dart`

### 数据表

- `notes`
- `todos`
- `tags`
- `note_tags`
- `theme_schemes`
- `sync_logs`
- `app_settings`

### 产出

- 应用重启后数据不会丢失。
- Repository 不再只使用内存数据。
- 数据模型和数据库表对应清晰。

### 验收标准

- 创建一条笔记，重启后仍存在。
- 创建一条待办，重启后仍存在。
- 删除操作使用软删除字段。
- 数据库文件能在本地生成。

## 5. 阶段 3：笔记模块 MVP

### 目标

完成笔记的核心闭环：新建、编辑、删除、搜索、标签、Markdown 编辑和预览。

### 建议耗时

3-5 天。

### 主要任务

- 完成笔记列表。
- 完成笔记编辑页。
- 支持标题和正文编辑。
- 支持 Markdown 预览。
- 支持编辑 / 预览切换。
- 支持搜索标题和正文。
- 支持标签创建和筛选。
- 保存更新时间。

### 涉及文件

- `lib/features/notes/domain/note.dart`
- `lib/features/notes/application/notes_controller.dart`
- `lib/features/notes/data/notes_repository.dart`
- `lib/features/notes/presentation/notes_page.dart`
- `lib/features/tags/`

### Markdown 最低支持

- 标题。
- 无序列表。
- 有序列表。
- 任务列表。
- 加粗。
- 链接。
- 行内代码。
- 代码块。
- 引用。

### 产出

- 一个真正可用的 Markdown 笔记功能。
- 用户可以完成日常记录。

### 验收标准

- 可以创建笔记。
- 可以编辑标题和正文。
- 可以删除笔记。
- 可以搜索笔记。
- 可以给笔记设置标签。
- Markdown 预览能正确显示基础语法。
- 重启应用后笔记仍存在。

## 6. 阶段 4：待办模块 MVP

### 目标

完成待办的核心闭环：新建、编辑、完成、删除、截止时间、优先级和筛选。

### 建议耗时

2-3 天。

### 主要任务

- 完成待办列表。
- 完成快速新增待办。
- 完成待办编辑。
- 支持完成 / 取消完成。
- 支持删除。
- 支持截止时间。
- 支持优先级。
- 支持全部、未完成、已完成筛选。

### 涉及文件

- `lib/features/todos/domain/todo.dart`
- `lib/features/todos/application/todos_controller.dart`
- `lib/features/todos/data/todos_repository.dart`
- `lib/features/todos/presentation/todos_page.dart`

### 优先级建议

- 低：普通事项。
- 中：默认事项。
- 高：重要或紧急事项。

### 产出

- 一个可以独立使用的本地待办功能。
- 用户可以用它管理当天任务。

### 验收标准

- 可以创建待办。
- 可以标记完成。
- 可以取消完成。
- 可以删除待办。
- 可以设置截止时间。
- 可以设置优先级。
- 可以按状态筛选。
- 重启应用后待办仍存在。

## 7. 阶段 5：主题自定义

### 目标

完成背景色、主按钮色、文字色的自定义，并支持保存主题方案。

### 建议耗时

2-3 天。

### 主要任务

- 完成颜色选择器。
- 支持设置背景色。
- 支持设置主按钮色。
- 支持设置文字色。
- 支持设置卡片或面板颜色。
- 保存主题方案。
- 切换主题方案。
- 添加预设主题。
- 应用启动时读取当前主题。

### 涉及文件

- `lib/core/theme/app_theme.dart`
- `lib/features/settings/domain/theme_scheme.dart`
- `lib/features/settings/application/theme_controller.dart`
- `lib/features/settings/data/theme_repository.dart`
- `lib/features/settings/presentation/settings_page.dart`

### 推荐预设主题

- 极简白。
- 夜间黑。
- 护眼绿。
- 淡紫。
- 灰蓝。

### 产出

- 用户可以明显感受到应用支持个性化。
- 主题设置可以作为项目展示亮点。

### 验收标准

- 修改背景色后页面背景立即变化。
- 修改主按钮色后按钮颜色立即变化。
- 修改文字色后主要文字颜色立即变化。
- 保存主题后重启应用仍生效。
- 可以恢复默认主题。

## 8. 阶段 6：局域网同步 MVP

### 目标

完成 Windows 和 Android 在同一 Wi-Fi 下的手动同步。

### 建议耗时

4-6 天。

### 主要任务

- Windows 或 Android 任一端可开启同步服务。
- 显示本机局域网 IP 和端口。
- 另一端可以输入地址连接。
- 实现 `/health` 接口。
- 实现 `/device` 接口。
- 实现 `/snapshot` 接口。
- 实现 `/sync` 接口。
- 实现数据快照 JSON。
- 实现合并策略。
- 同步完成后展示结果。
- 同步失败时提示原因。

### 涉及文件

- `lib/features/sync/domain/device_info.dart`
- `lib/features/sync/domain/sync_snapshot.dart`
- `lib/features/sync/domain/merge_policy.dart`
- `lib/features/sync/domain/sync_result.dart`
- `lib/features/sync/application/sync_controller.dart`
- `lib/features/sync/data/sync_repository.dart`
- `lib/features/sync/infrastructure/local_sync_server.dart`
- `lib/features/sync/infrastructure/sync_api_client.dart`

### 第一版同步流程

```text
设备 A 开启同步服务
设备 B 输入设备 A 的 IP 和端口
设备 B 请求设备 A 的数据快照
设备 B 合并设备 A 的数据
设备 B 将自己的数据快照发送给设备 A
设备 A 合并设备 B 的数据
双方展示同步结果
```

### 合并规则

- 新数据直接插入。
- 同一条数据保留更新时间更晚的一方。
- 删除与更新冲突时，比较 `deletedAt` 和 `updatedAt`。
- 同步失败不覆盖本地数据。
- 合并过程尽量放在数据库事务中。

### 产出

- Windows 新建的笔记可以同步到 Android。
- Android 新建的待办可以同步到 Windows。

### 验收标准

- 两端同 Wi-Fi 下可以连接。
- `/health` 能返回成功。
- 新增、更新、删除笔记可以同步。
- 新增、更新、删除待办可以同步。
- 同步失败不导致本地数据丢失。
- 同步结果能显示新增、更新、删除数量。

## 9. 阶段 7：体验打磨与异常处理

### 目标

让应用从“功能能跑”变成“用户愿意用”。

### 建议耗时

3-5 天。

### 主要任务

- 优化 Windows 宽屏布局。
- 优化 Android 小屏布局。
- 增加加载状态。
- 增加错误提示。
- 增加删除确认或撤销。
- 优化空状态。
- 优化搜索体验。
- 优化 Markdown 预览样式。
- 优化同步失败提示。
- 增加基础日志。

### 重点检查

- 文字不要溢出。
- 按钮不要拥挤。
- 移动端输入体验要顺手。
- Windows 端列表和编辑区要有清晰层次。
- 同步状态要明确。

### 产出

- 应用在视觉和交互上更像一个完整产品。

### 验收标准

- 常用操作路径不超过两步。
- 空状态有明确行动入口。
- 错误信息用户能看懂。
- Windows 和 Android 均没有明显布局错乱。

## 10. 阶段 8：测试、打包与作品展示

### 目标

完成投递可用的项目材料：安装包、截图、演示视频、README 和简历描述。

### 建议耗时

2-4 天。

### 主要任务

- 补充单元测试。
- 补充同步合并测试。
- 手动测试 Windows。
- 手动测试 Android。
- 打包 Windows 应用。
- 打包 Android APK。
- 整理截图。
- 录制演示视频。
- 完善 README。
- 整理简历项目描述。

### 推荐测试

- 合并策略测试。
- 笔记 Repository 测试。
- 待办 Repository 测试。
- 主题保存测试。
- 同步快照导入导出测试。

### 展示材料

- 项目 README。
- Windows 主界面截图。
- Android 主界面截图。
- Markdown 编辑与预览截图。
- 主题自定义截图。
- 局域网同步演示视频。
- GitHub 仓库链接。

### 验收标准

- Windows 端可以正常安装或运行。
- Android APK 可以安装。
- README 能说明项目亮点和运行方式。
- 演示视频能展示完整流程。
- 简历描述能突出独立开发、跨端、本地存储、局域网同步和产品设计能力。

## 11. 最小可投递版本清单

如果时间有限，至少完成以下内容：

- Windows / Android 都能运行。
- 笔记可以新建、编辑、删除、搜索。
- Markdown 可以编辑和预览。
- 待办可以新建、完成、删除。
- 数据本地保存。
- 背景色、按钮色、文字色可以自定义。
- 同一 Wi-Fi 下可以手动同步。
- README 有截图和运行说明。
- 有一段 1-2 分钟演示视频。

## 12. 推荐开发顺序

```text
环境搭建
→ 页面导航
→ 本地数据库
→ 笔记模块
→ 待办模块
→ 主题自定义
→ 局域网同步
→ 体验打磨
→ 测试打包
→ 项目展示
```

## 13. 每日推进建议

### 7 天压缩版

- 第 1 天：环境、工程、页面导航。
- 第 2 天：数据库和笔记基础 CRUD。
- 第 3 天：Markdown 预览、搜索、标签。
- 第 4 天：待办 CRUD、截止时间、优先级。
- 第 5 天：主题自定义。
- 第 6 天：局域网手动同步。
- 第 7 天：测试、截图、README、演示视频。

### 14 天稳妥版

- 第 1 天：环境、工程、页面导航。
- 第 2-3 天：数据库、Repository、数据模型。
- 第 4-6 天：笔记、Markdown、搜索、标签。
- 第 7-8 天：待办、筛选、优先级、截止时间。
- 第 9-10 天：主题自定义和界面打磨。
- 第 11-12 天：局域网同步。
- 第 13 天：测试和修复。
- 第 14 天：打包、README、演示视频。

### 21 天展示版

- 第 1-2 天：环境和基础架构。
- 第 3-5 天：数据库和数据层。
- 第 6-9 天：笔记模块。
- 第 10-12 天：待办模块。
- 第 13-14 天：主题自定义。
- 第 15-17 天：局域网同步。
- 第 18-19 天：体验打磨和异常处理。
- 第 20 天：测试和打包。
- 第 21 天：展示材料和简历描述。

## 14. v1.0 当前状态

截至 v1.0，项目已经完成 P0 到 P7 的核心开发目标，并补齐了发布说明、项目总结和 Codex skills 使用记录。

已完成内容：

- Windows / Android Flutter 工程基础。
- 响应式应用外壳和中文界面文案。
- Drift + SQLite 本地数据库。
- 笔记新建、编辑、删除、搜索、标签和 Markdown 预览。
- 待办新建、编辑、完成、删除、筛选、优先级和截止时间。
- 主题预设、自定义颜色、主题保存和默认恢复。
- 同局域网手动同步 MVP。
- 基础体验打磨：空状态、加载状态、错误提示、删除确认和更平滑的页面切换。
- 自动化检查：`flutter analyze` 和 `flutter test`。

建议继续补充：

- 打包 Windows 可执行程序和 Android APK。
- 补充 README 截图和 1-2 分钟演示视频。
- 增加二维码配对同步，减少手动输入 IP 的成本。
- 增加 Markdown 快捷工具栏。
- 为同步冲突展示更清晰的用户提示。
