# v1.0.0 发布说明

## 版本定位

`v1.0.0` 是简记 SimpleNote 的第一个完整 MVP 版本，覆盖笔记、待办、本地存储、主题自定义、局域网同步和基础体验打磨。

## 新增能力

- 中文化应用界面。
- Markdown 笔记编辑与预览。
- 笔记搜索和标签筛选。
- 待办优先级、截止日期和状态筛选。
- 本地 SQLite 持久化。
- 预设主题和自定义主题保存。
- 局域网手动同步。
- 删除确认和操作反馈。
- GitHub Actions 自动检查。

## 验证方式

```powershell
D:\DevEnv\Flutter\bin\flutter.bat analyze
D:\DevEnv\Flutter\bin\flutter.bat test
```

## 已知限制

- 局域网同步需要手动输入对端地址。
- 暂未提供二维码配对和自动设备发现。
- 暂未提供正式安装包资产。
- Windows 首次开启同步服务时可能需要允许防火墙访问。

## 下一步建议

- 打包 Windows 和 Android 产物。
- 增加截图、演示视频和简历项目描述。
- 补充同步日志界面和删除撤销。
