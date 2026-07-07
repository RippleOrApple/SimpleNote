# v1.0.1 发布说明

## 版本定位

`v1.0.1` 是一次体验修复版本，重点解决 Windows 下中文字体显示偏瘦、偏硬的问题。

## 更新内容

- 内置 Noto Sans CJK SC 简体中文字体。
- 将应用全局字体切换为 `NotoSansSC`。
- 改善 Windows 下中文、英文和数字混排的显示效果。
- 保持 Android 与 Windows 的字体体验一致。
- 忽略本地 `dist/` 打包产物目录，避免误提交发布文件。

## 验证方式

```powershell
D:\DevEnv\Flutter\bin\flutter.bat analyze
D:\DevEnv\Flutter\bin\flutter.bat test
D:\DevEnv\Flutter\bin\flutter.bat build windows --release
```

## 安装说明

- Windows：下载 zip 后解压，运行 `simple_note.exe`。
- Android：下载 APK 后发送到手机安装。当前 APK 仍适合项目演示和本机测试；正式上架前需要配置正式签名。
