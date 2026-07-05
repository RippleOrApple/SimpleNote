# SimpleNote 项目架构说明书

## 1. 架构目标

SimpleNote 的架构目标是支撑一个 Windows / Android 双端本地优先应用，核心能力包括笔记、待办、Markdown、本地存储、主题自定义和局域网同步。

架构设计应满足以下原则：

- 跨端一致：Windows 和 Android 尽量复用同一套业务逻辑和数据模型。
- 本地优先：所有核心数据先落本地数据库，不依赖云服务。
- 简洁可维护：模块边界清晰，避免功能之间互相耦合。
- 同步可扩展：第一版支持手动局域网同步，后续可扩展二维码连接、自动发现和备份。
- UI 可主题化：颜色、文本、按钮、背景等视觉元素由统一主题系统管理。

## 2. 推荐技术栈

### 2.1 客户端框架

推荐使用 Flutter。

选择理由：

- 一套代码支持 Windows 和 Android。
- UI 自定义能力强，适合做简洁、个性化界面。
- 生态中已有 SQLite、Markdown、网络服务等成熟组件。
- 便于快速做出可展示的完整产品。

### 2.2 状态管理

推荐使用 Riverpod。

用途：

- 管理笔记列表、待办列表、当前主题、同步状态。
- 将 UI 与业务逻辑解耦。
- 便于测试和后续维护。

可选替代：

- Provider：上手更简单。
- Bloc：适合更复杂的大型应用。

### 2.3 本地数据库

推荐使用 SQLite + Drift。

用途：

- 存储笔记、待办、标签、主题、同步元数据。
- 提供类型安全的数据访问层。
- 支持数据库迁移。

### 2.4 Markdown

推荐使用 flutter_markdown。

用途：

- 渲染 Markdown 预览。
- 支持标题、列表、代码块、链接、加粗、引用等基础语法。

第一版编辑器可以使用普通多行文本输入框，降低实现复杂度。

### 2.5 局域网同步

推荐使用 Dart 内置 HTTP Server 或轻量 HTTP 服务库。

第一版采用手动连接：

- 服务端设备开启同步服务。
- 客户端设备输入 IP 和端口。
- 双方通过 HTTP 接口交换 JSON 数据。

后续可以加入：

- mDNS / Bonjour 自动发现。
- 二维码连接。
- 连接确认码。

## 3. 总体架构

```text
SimpleNote App
├─ Presentation Layer
│  ├─ Windows Layout
│  ├─ Android Layout
│  ├─ Notes UI
│  ├─ Todos UI
│  ├─ Settings UI
│  └─ Theme UI
├─ Application Layer
│  ├─ Notes Controller
│  ├─ Todos Controller
│  ├─ Theme Controller
│  ├─ Sync Controller
│  └─ Search Controller
├─ Domain Layer
│  ├─ Note Entity
│  ├─ Todo Entity
│  ├─ Tag Entity
│  ├─ Theme Scheme Entity
│  ├─ Sync Snapshot Entity
│  └─ Merge Policy
├─ Data Layer
│  ├─ Drift Database
│  ├─ Notes Repository
│  ├─ Todos Repository
│  ├─ Tags Repository
│  ├─ Theme Repository
│  └─ Sync Repository
└─ Infrastructure Layer
   ├─ Local HTTP Server
   ├─ Sync API Client
   ├─ Device Info Service
   ├─ Logger
   └─ Import / Export Service
```

## 4. 分层说明

### 4.1 Presentation Layer

负责所有界面展示和用户交互。

包含：

- 页面布局。
- 表单输入。
- 列表展示。
- Markdown 编辑和预览。
- 主题色应用。
- 同步状态展示。

该层不直接访问数据库，而是通过 Controller 或 Provider 调用应用层能力。

### 4.2 Application Layer

负责组织业务流程。

典型职责：

- 创建笔记。
- 更新笔记。
- 删除笔记。
- 搜索笔记。
- 创建待办。
- 切换待办完成状态。
- 保存主题方案。
- 发起同步。
- 处理同步结果。

该层可以调用多个 Repository，并将结果转换成 UI 需要的状态。

### 4.3 Domain Layer

负责定义核心业务对象和规则。

包含：

- Note。
- Todo。
- Tag。
- ThemeScheme。
- SyncSnapshot。
- 数据合并策略。

该层不依赖 Flutter UI，也不依赖具体数据库实现。

### 4.4 Data Layer

负责本地数据读写。

包含：

- SQLite 表定义。
- Drift DAO。
- Repository 实现。
- 数据库迁移。
- JSON 序列化与反序列化。

### 4.5 Infrastructure Layer

负责与系统、网络、设备相关的能力。

包含：

- 局域网 HTTP 服务。
- 同步 API 客户端。
- 获取设备 ID 和设备名称。
- 日志记录。
- 导入导出。

## 5. 推荐目录结构

```text
lib/
├─ main.dart
├─ app.dart
├─ core/
│  ├─ constants/
│  ├─ errors/
│  ├─ logging/
│  ├─ routing/
│  ├─ theme/
│  └─ utils/
├─ features/
│  ├─ notes/
│  │  ├─ application/
│  │  ├─ data/
│  │  ├─ domain/
│  │  └─ presentation/
│  ├─ todos/
│  │  ├─ application/
│  │  ├─ data/
│  │  ├─ domain/
│  │  └─ presentation/
│  ├─ tags/
│  │  ├─ application/
│  │  ├─ data/
│  │  ├─ domain/
│  │  └─ presentation/
│  ├─ settings/
│  │  ├─ application/
│  │  ├─ data/
│  │  ├─ domain/
│  │  └─ presentation/
│  └─ sync/
│     ├─ application/
│     ├─ data/
│     ├─ domain/
│     └─ infrastructure/
├─ shared/
│  ├─ widgets/
│  ├─ providers/
│  └─ models/
└─ database/
   ├─ app_database.dart
   ├─ tables/
   ├─ daos/
   └─ migrations/
```

## 6. 核心模块设计

### 6.1 笔记模块

职责：

- 管理笔记创建、编辑、删除、搜索。
- 管理笔记与标签的关系。
- 提供 Markdown 编辑内容。
- 提供笔记列表和详情状态。

主要页面：

- NotesListPage。
- NoteEditorPage。
- NotePreviewPanel。
- TagFilterPanel。

主要对象：

```text
Note
├─ id
├─ title
├─ content
├─ createdAt
├─ updatedAt
├─ deletedAt
├─ pinned
├─ deviceId
└─ version
```

### 6.2 待办模块

职责：

- 管理待办创建、编辑、完成、删除。
- 支持截止时间和优先级。
- 支持按状态筛选。

主要页面：

- TodosPage。
- TodoEditorSheet。
- TodoFilterBar。

主要对象：

```text
Todo
├─ id
├─ title
├─ description
├─ completed
├─ dueAt
├─ priority
├─ createdAt
├─ updatedAt
├─ deletedAt
├─ deviceId
└─ version
```

### 6.3 标签模块

职责：

- 创建、编辑、删除标签。
- 为笔记绑定标签。
- 支持按标签筛选笔记。

主要对象：

```text
Tag
├─ id
├─ name
├─ color
├─ createdAt
├─ updatedAt
├─ deletedAt
└─ deviceId
```

### 6.4 Markdown 模块

职责：

- 管理编辑模式和预览模式。
- 渲染 Markdown 内容。
- 提供基础编辑体验。

第一版能力：

- 标题。
- 列表。
- 任务列表。
- 代码块。
- 行内代码。
- 链接。
- 加粗。
- 引用。

后续能力：

- 分屏编辑预览。
- 代码高亮。
- 快捷插入语法。

### 6.5 主题模块

职责：

- 保存主题方案。
- 切换当前主题。
- 将主题色应用到全局 UI。
- 提供主题预设。

主要对象：

```text
ThemeScheme
├─ id
├─ name
├─ backgroundColor
├─ primaryColor
├─ textColor
├─ surfaceColor
├─ createdAt
├─ updatedAt
└─ isActive
```

设计建议：

- 应用启动时读取当前激活主题。
- 所有颜色通过统一 Theme Provider 获取。
- 保存主题时校验文字色和背景色的对比度。

### 6.6 同步模块

职责：

- 开启和关闭本机同步服务。
- 连接另一台设备。
- 导出本地数据快照。
- 接收远端数据快照。
- 合并数据。
- 保存同步结果。

第一版同步方式：

```text
Windows 端开启同步服务
Android 端输入 Windows 端 IP 和端口
Android 端请求 Windows 端数据快照
Android 端合并数据
Android 端将自己的数据快照发送给 Windows 端
Windows 端合并数据
双方返回同步结果
```

## 7. 数据库设计

### 7.1 notes 表

```text
notes
├─ id TEXT PRIMARY KEY
├─ title TEXT NOT NULL
├─ content TEXT NOT NULL
├─ created_at INTEGER NOT NULL
├─ updated_at INTEGER NOT NULL
├─ deleted_at INTEGER NULL
├─ pinned INTEGER NOT NULL DEFAULT 0
├─ device_id TEXT NOT NULL
└─ version INTEGER NOT NULL DEFAULT 1
```

### 7.2 todos 表

```text
todos
├─ id TEXT PRIMARY KEY
├─ title TEXT NOT NULL
├─ description TEXT NOT NULL DEFAULT ''
├─ completed INTEGER NOT NULL DEFAULT 0
├─ due_at INTEGER NULL
├─ priority INTEGER NOT NULL DEFAULT 0
├─ created_at INTEGER NOT NULL
├─ updated_at INTEGER NOT NULL
├─ deleted_at INTEGER NULL
├─ device_id TEXT NOT NULL
└─ version INTEGER NOT NULL DEFAULT 1
```

### 7.3 tags 表

```text
tags
├─ id TEXT PRIMARY KEY
├─ name TEXT NOT NULL
├─ color TEXT NULL
├─ created_at INTEGER NOT NULL
├─ updated_at INTEGER NOT NULL
├─ deleted_at INTEGER NULL
└─ device_id TEXT NOT NULL
```

### 7.4 note_tags 表

```text
note_tags
├─ note_id TEXT NOT NULL
├─ tag_id TEXT NOT NULL
├─ created_at INTEGER NOT NULL
└─ PRIMARY KEY(note_id, tag_id)
```

### 7.5 theme_schemes 表

```text
theme_schemes
├─ id TEXT PRIMARY KEY
├─ name TEXT NOT NULL
├─ background_color TEXT NOT NULL
├─ primary_color TEXT NOT NULL
├─ text_color TEXT NOT NULL
├─ surface_color TEXT NOT NULL
├─ created_at INTEGER NOT NULL
├─ updated_at INTEGER NOT NULL
└─ is_active INTEGER NOT NULL DEFAULT 0
```

### 7.6 sync_logs 表

```text
sync_logs
├─ id TEXT PRIMARY KEY
├─ peer_device_id TEXT NULL
├─ peer_device_name TEXT NULL
├─ started_at INTEGER NOT NULL
├─ finished_at INTEGER NULL
├─ status TEXT NOT NULL
├─ notes_created INTEGER NOT NULL DEFAULT 0
├─ notes_updated INTEGER NOT NULL DEFAULT 0
├─ notes_deleted INTEGER NOT NULL DEFAULT 0
├─ todos_created INTEGER NOT NULL DEFAULT 0
├─ todos_updated INTEGER NOT NULL DEFAULT 0
├─ todos_deleted INTEGER NOT NULL DEFAULT 0
└─ error_message TEXT NULL
```

### 7.7 app_settings 表

```text
app_settings
├─ key TEXT PRIMARY KEY
└─ value TEXT NOT NULL
```

推荐存储内容：

- device_id。
- device_name。
- active_theme_id。
- last_sync_at。
- sync_port。

## 8. 同步协议设计

### 8.1 设备信息

```json
{
  "deviceId": "windows-uuid",
  "deviceName": "My Windows PC",
  "platform": "windows",
  "appVersion": "1.0.0"
}
```

### 8.2 数据快照

```json
{
  "device": {
    "deviceId": "windows-uuid",
    "deviceName": "My Windows PC",
    "platform": "windows",
    "appVersion": "1.0.0"
  },
  "exportedAt": 1760000000000,
  "notes": [],
  "todos": [],
  "tags": [],
  "noteTags": [],
  "themeSchemes": []
}
```

### 8.3 推荐接口

```text
GET  /health
GET  /device
GET  /snapshot
POST /sync
POST /shutdown
```

接口说明：

- `/health`：检查服务是否可访问。
- `/device`：获取设备信息。
- `/snapshot`：获取本机数据快照。
- `/sync`：接收远端数据快照并执行合并。
- `/shutdown`：关闭同步服务，可选。

### 8.4 合并策略

每条可同步数据都应包含：

```text
id
createdAt
updatedAt
deletedAt
deviceId
version
```

合并规则：

- 本地不存在，远端存在：插入远端数据。
- 本地存在，远端不存在：保留本地数据。
- 本地和远端都存在，均未删除：保留 `updatedAt` 更晚的一方。
- 本地未删除，远端已删除：如果远端 `deletedAt` 晚于本地 `updatedAt`，则本地标记删除。
- 本地已删除，远端未删除：如果本地 `deletedAt` 晚于远端 `updatedAt`，则保留删除状态，否则恢复为远端版本。
- 本地和远端都已删除：保留 `deletedAt` 更晚的一方。

### 8.5 同步冲突限制

第一版不做复杂冲突副本，例如“不生成 Note copy”。这能让产品更简单，也便于演示。

如果后续需要增强，可以在发生双端同时编辑时生成冲突副本：

```text
原笔记
原笔记 - 来自 Android 的冲突副本
```

## 9. 状态管理设计

推荐 Provider 划分：

```text
notesProvider
currentNoteProvider
noteSearchQueryProvider
todosProvider
todoFilterProvider
themeProvider
syncServerProvider
syncClientProvider
syncStatusProvider
```

典型状态：

```text
idle
loading
success
error
syncing
```

UI 不直接执行数据库操作，而是调用 Controller：

```text
NotesController.createNote()
NotesController.updateNote()
NotesController.deleteNote()
TodosController.toggleTodo()
ThemeController.saveTheme()
SyncController.startServer()
SyncController.syncWithPeer()
```

## 10. 页面结构设计

### 10.1 Windows 页面

推荐结构：

```text
Window
├─ Sidebar
│  ├─ Notes
│  ├─ Todos
│  └─ Settings
├─ List Pane
│  ├─ Search
│  ├─ Tags / Filters
│  └─ Items
└─ Content Pane
   ├─ Editor
   ├─ Preview
   └─ Detail
```

### 10.2 Android 页面

推荐结构：

```text
Scaffold
├─ AppBar
├─ Body
│  ├─ Notes Page
│  ├─ Todos Page
│  └─ Settings Page
└─ BottomNavigationBar
```

笔记编辑：

```text
Notes List
└─ Note Editor
   ├─ Title Input
   ├─ Markdown Input
   └─ Preview Toggle
```

## 11. 关键业务流程

### 11.1 创建笔记

```text
用户点击新建笔记
生成 Note id 和时间戳
写入数据库
刷新笔记列表
打开编辑区
用户输入内容
自动保存或手动保存
更新 updatedAt
```

### 11.2 搜索笔记

```text
用户输入关键词
更新搜索状态
查询标题和正文
过滤 deletedAt 不为空的数据
按 updatedAt 倒序展示
```

### 11.3 创建待办

```text
用户输入待办标题
选择截止时间和优先级
写入数据库
刷新待办列表
```

### 11.4 切换主题

```text
用户选择颜色
生成主题预览
用户保存主题
写入 theme_schemes
设置 is_active
更新全局 ThemeData
```

### 11.5 手动同步

```text
设备 A 开启同步服务
设备 B 输入设备 A 地址
设备 B 获取设备 A 快照
设备 B 合并快照
设备 B 将自己的快照发送给设备 A
设备 A 合并快照
双方展示同步结果
写入 sync_logs
```

## 12. 错误处理

### 12.1 数据库错误

处理方式：

- 捕获异常。
- 展示保存失败提示。
- 记录日志。
- 不清空用户输入。

### 12.2 同步连接失败

可能原因：

- 不在同一 Wi-Fi。
- IP 地址输入错误。
- 防火墙拦截。
- 对方未开启同步服务。

处理方式：

- 展示可理解的错误文案。
- 保留用户输入的地址。
- 提供重试按钮。

### 12.3 同步合并失败

处理方式：

- 不覆盖本地数据库。
- 尽量使用事务执行合并。
- 失败时回滚事务。
- 写入失败日志。

## 13. 测试计划

### 13.1 单元测试

重点测试：

- Note 数据模型。
- Todo 数据模型。
- Markdown 内容保存。
- 合并策略。
- 主题颜色保存。

### 13.2 集成测试

重点测试：

- 创建笔记后数据库存在记录。
- 删除笔记后 `deletedAt` 被设置。
- 创建待办后状态正确。
- 切换主题后配置持久化。
- 导出和导入数据快照。

### 13.3 手动测试

Windows：

- 创建、编辑、删除、搜索笔记。
- 创建、完成、删除待办。
- 切换主题。
- 开启同步服务。

Android：

- 创建、编辑、删除、搜索笔记。
- 创建、完成、删除待办。
- 输入 Windows 地址并同步。
- 断网情况下正常查看本地数据。

### 13.4 同步测试用例

- A 新增笔记，B 同步后可见。
- A 修改笔记，B 同步后更新。
- A 删除笔记，B 同步后删除。
- A 和 B 同时修改同一笔记，更新时间较晚者生效。
- 同步中断后，本地数据不丢失。

## 14. 打包与交付

### 14.1 Windows

交付物：

- Windows 可执行程序。
- README。
- 截图。
- 演示视频。

### 14.2 Android

交付物：

- APK 安装包。
- Android 端截图。
- 同步演示视频。

### 14.3 项目仓库

推荐仓库内容：

```text
README.md
docs/
├─ PRODUCT_REQUIREMENTS.md
└─ ARCHITECTURE.md
lib/
test/
assets/
screenshots/
```

README 应包含：

- 项目介绍。
- 核心功能。
- 技术栈。
- 运行方式。
- 截图。
- 同步演示说明。
- 开发计划。

## 15. 开发里程碑

### 第 1 阶段：基础工程

- 创建 Flutter 项目。
- 跑通 Windows 和 Android。
- 接入基础路由和主题。
- 建立目录结构。

### 第 2 阶段：本地数据

- 接入 Drift。
- 建立 notes、todos、tags、theme_schemes 表。
- 完成 Repository。

### 第 3 阶段：笔记和 Markdown

- 完成笔记列表。
- 完成笔记编辑。
- 完成 Markdown 预览。
- 完成搜索。
- 完成标签。

### 第 4 阶段：待办

- 完成待办列表。
- 完成新增、完成、删除。
- 完成截止时间和优先级。

### 第 5 阶段：主题自定义

- 完成颜色选择。
- 完成主题保存。
- 完成主题切换。
- 完成预设主题。

### 第 6 阶段：局域网同步

- 完成同步服务端。
- 完成同步客户端。
- 完成数据快照。
- 完成合并策略。
- 完成同步结果展示。

### 第 7 阶段：测试和展示

- 完成基础测试。
- 打包 Windows。
- 打包 Android。
- 录制演示视频。
- 整理 README。

## 16. 简历描述参考

```text
独立设计并开发 SimpleNote，一款 Windows / Android 双端本地笔记待办应用。项目基于 Flutter 构建跨端界面，使用 SQLite + Drift 实现本地优先的数据存储，支持 Markdown 编辑与预览、笔记搜索、标签分类、待办优先级与截止时间、主题高度自定义，并设计了基于局域网 HTTP 和时间戳合并策略的数据同步方案。项目覆盖需求分析、产品设计、架构设计、开发实现、测试验证与打包交付完整流程。
```
