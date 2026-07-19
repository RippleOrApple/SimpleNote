# 阶段 0 完成记录

> **历史文档。**
>
> 本文仅记录项目初始化阶段的环境与工程搭建情况，保留用于追踪项目来源。当前 V2 开发状态请阅读 `../../README.md`。

## 已完成

- 已确认 Flutter SDK 可用。
- 已将 Flutter 的 `bin` 目录加入用户 PATH。
- 已使用本机 Flutter SDK 生成 Windows / Android 平台目录。
- 已完成依赖安装。
- 已修复 Flutter 模板默认测试与当前应用入口不匹配的问题。
- 已创建 Android 模拟器 `SimpleNote_Pixel`。
- 已构建 Android debug APK 并安装到模拟器。
- 已运行代码格式化。
- 已运行静态检查。
- 已运行测试。

## Flutter 环境

Flutter SDK 路径：

```text
D:\DevEnv\Flutter
```

PATH 条目：

```text
D:\DevEnv\Flutter\bin
```

当前版本：

```text
Flutter 3.44.4
Dart 3.12.2
```

## 已生成的关键目录

```text
android/
windows/
lib/
test/
docs/
D:\Tool\Android Studio\avd/
```

## Android 模拟器

AVD 存放目录：

```text
D:\Tool\Android Studio\avd
```

模拟器名称：

```text
SimpleNote_Pixel
```

系统镜像：

```text
Android 16 / API 36 / Google APIs / x86_64
```

启动命令：

```powershell
flutter emulators --launch SimpleNote_Pixel
```

或：

```powershell
D:\DevEnv\Android\emulator\emulator.exe -avd SimpleNote_Pixel
```

## 验证结果

### 静态检查

```text
flutter analyze
No issues found
```

### 测试

```text
flutter test
All tests passed
```

当前通过的测试：

- 同步合并策略测试。
- 应用启动到 Notes 页面测试。

### Android 构建与安装

```text
flutter build apk --debug
Built build\app\outputs\flutter-apk\app-debug.apk
```

```text
adb install -r build\app\outputs\flutter-apk\app-debug.apk
Success
```

## 当前环境限制

### Windows 桌面运行

当前机器尚未安装 Visual Studio 的 Windows 桌面开发组件，因此暂时不能编译运行 Windows 桌面应用。

需要安装：

```text
Visual Studio
Desktop development with C++ workload
```

### Android 运行

Android 模拟器已创建并验证。当前 Flutter 可识别以下 Android 设备：

```text
sdk gphone64 x86 64 (mobile) / emulator-5554 / Android 16 (API 36)
```

## 下一步

阶段 1 可以继续推进，不依赖 Windows 实机运行。建议先完成基础页面导航和布局打磨，然后在 Android 设备或 Windows C++ 环境补齐后再做真机验证。
