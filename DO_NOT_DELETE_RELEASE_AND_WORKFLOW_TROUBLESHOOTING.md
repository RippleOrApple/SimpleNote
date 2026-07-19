# SimpleNote 发布与工作流问题处理手册

> **不可删除。**
>
> 本文档记录 2026-07-19 提交、推送和发布 `v2.0.0+3` 时遇到的问题与解决方法。后续如果 Git、Flutter、GitHub Release、构建或工作区状态出现相似问题，先阅读本文档。

## 1. 本次上下文

- 日期：2026-07-19
- 分支：`codex/ticktick-v2-phase2-continuation`
- Release：`v2.0.0+3`
- 远端：`https://github.com/RippleOrApple/SimpleNote`
- GitHub Release URL：`https://github.com/RippleOrApple/SimpleNote/releases/tag/v2.0.0%2B3`
- 上传资产：
  - `build/SimpleNote-v2.0.0+3-windows-x64.zip`
  - `build/SimpleNote-v2.0.0+3-android-release.apk`

## 2. 问题一：普通沙箱无法写 `.git/index.lock`

### 现象

执行：

```powershell
git add README.md
git commit -m "docs: update phase two release status"
```

失败：

```text
fatal: Unable to create 'D:/MyProject/SimpleNote/.git/index.lock': Permission denied
```

### 原因

当时文件系统权限允许读 `.git`，但不允许写 Git 元数据。`git add` 和 `git commit` 都需要写 `.git/index.lock`，因此失败。

### 解决方法

在当时的权限模型下，使用提升后的 Git 命令完成：

```powershell
git add README.md
git commit -m "docs: update phase two release status"
git push -u origin codex/ticktick-v2-phase2-continuation
```

当前环境如果已经是 unrestricted/danger-full-access，就不要再申请提升权限，直接运行命令即可。

### 经验

- 读 Git 状态和 diff 可能成功，不代表能 stage/commit。
- 如果失败信息包含 `.git/index.lock` 和 `Permission denied`，优先判断为 Git 元数据写权限问题。

## 3. 问题二：Node REPL 调 `.bat` 或 `cmd.exe` 卡住

### 现象

用 Node REPL 调用：

```text
D:\DevEnv\Flutter\bin\flutter.bat --version
cmd.exe /c "D:\DevEnv\Flutter\bin\flutter.bat --version"
```

出现长时间无输出，甚至工具超时。

### 原因

Node REPL 的进程启动方式和 Windows 批处理入口不稳定，尤其是 `.bat`、`cmd.exe`、长期构建命令混用时容易卡住。

### 解决方法

改用普通终端工具执行 Flutter：

```powershell
D:\DevEnv\Flutter\bin\flutter.bat --version
D:\DevEnv\Flutter\bin\flutter.bat analyze
D:\DevEnv\Flutter\bin\flutter.bat test
```

### 经验

- Flutter 验证优先走终端，不优先走 Node REPL。
- 如果 `flutter --version` 都无输出超时，不要直接判断 Flutter 损坏，先换执行通道。

## 4. 问题三：`flutter` 不在默认 PATH，但固定路径可用

### 现象

普通 `spawn flutter` 报：

```text
spawn flutter ENOENT
```

但实际 Flutter 存在：

```powershell
D:\DevEnv\Flutter\bin\flutter.bat --version
```

可输出：

```text
Flutter 3.44.4
Tools • Dart 3.12.2
```

### 解决方法

项目验证命令统一使用固定路径：

```powershell
D:\DevEnv\Flutter\bin\dart.bat format --output=none --set-exit-if-changed lib test
D:\DevEnv\Flutter\bin\flutter.bat analyze
D:\DevEnv\Flutter\bin\flutter.bat test
D:\DevEnv\Flutter\bin\flutter.bat build windows --release
D:\DevEnv\Flutter\bin\flutter.bat build apk --release
```

### 经验

- 文档和 release notes 应记录固定路径命令，避免不同 shell 的 PATH 差异。
- 不要因为 `flutter` 命令名不可用就跳过验证。

## 5. 问题四：Windows Flutter 生成文件显示 modified，但无实际 diff

### 现象

`git status -sb` 显示：

```text
 M windows/flutter/generated_plugin_registrant.cc
 M windows/flutter/generated_plugin_registrant.h
 M windows/flutter/generated_plugins.cmake
```

但：

```powershell
git diff -- windows/flutter/generated_plugin_registrant.cc windows/flutter/generated_plugin_registrant.h windows/flutter/generated_plugins.cmake
git diff --numstat -- windows/flutter/generated_plugin_registrant.cc windows/flutter/generated_plugin_registrant.h windows/flutter/generated_plugins.cmake
git diff --name-only -- windows/flutter/generated_plugin_registrant.cc windows/flutter/generated_plugin_registrant.h windows/flutter/generated_plugins.cmake
```

没有实际内容输出，只出现换行提示：

```text
warning: LF will be replaced by CRLF the next time Git touches it
```

### 原因

这是 Windows 换行状态噪音，不是代码变更。

### 处理方法

本次 release 没有提交这些文件。

如果后续需要清理，先确认：

```powershell
git diff --numstat -- windows/flutter/generated_plugin_registrant.cc windows/flutter/generated_plugin_registrant.h windows/flutter/generated_plugins.cmake
```

仍为空后，再由维护者决定是否做换行归一化。不要把它们混入功能提交。

## 6. 问题五：GitHub CLI 字段兼容性

### 现象

执行：

```powershell
gh release view v2.0.0+3 --json url,tagName,name,isLatest,assets
```

失败：

```text
Unknown JSON field: "isLatest"
```

### 解决方法

改用当前 `gh` 支持的字段：

```powershell
gh release view v2.0.0+3 --json url,tagName,name,isDraft,isPrerelease,targetCommitish,assets
```

### 经验

- `gh` 的 JSON 字段随版本变化，失败时看命令输出里的 Available fields。
- 不要因为某个字段不可用就认为 release 创建失败。

## 7. 问题六：GitHub release 的 `+` 在 URL 中会转义

### 现象

tag 是：

```text
v2.0.0+3
```

GitHub release URL 显示为：

```text
https://github.com/RippleOrApple/SimpleNote/releases/tag/v2.0.0%2B3
```

### 原因

URL 中的 `+` 被编码为 `%2B`，这是正常行为。

### 经验

- tag 仍是 `v2.0.0+3`。
- URL 中看到 `%2B` 不代表 tag 错误。

## 8. 本次通过的验证

```powershell
D:\DevEnv\Flutter\bin\dart.bat format --output=none --set-exit-if-changed lib test
D:\DevEnv\Flutter\bin\flutter.bat analyze
D:\DevEnv\Flutter\bin\flutter.bat test
D:\DevEnv\Flutter\bin\flutter.bat build windows --release
D:\DevEnv\Flutter\bin\flutter.bat build apk --release
```

结果：

- 格式检查通过，177 个文件未修改。
- `flutter analyze` 通过，无问题。
- `flutter test` 通过，217 个测试。
- Windows release build 通过。
- Android release APK build 通过。

## 9. 标准发布流程备忘

1. 检查状态：

```powershell
git status -sb
git diff --stat
git log --oneline --decorate -5
```

2. 跑验证：

```powershell
D:\DevEnv\Flutter\bin\dart.bat format --output=none --set-exit-if-changed lib test
D:\DevEnv\Flutter\bin\flutter.bat analyze
D:\DevEnv\Flutter\bin\flutter.bat test
```

3. 构建产物：

```powershell
D:\DevEnv\Flutter\bin\flutter.bat build windows --release
D:\DevEnv\Flutter\bin\flutter.bat build apk --release
```

4. 打包 Windows：

```powershell
Compress-Archive -Path build\windows\x64\runner\Release\* -DestinationPath build\SimpleNote-<version>-windows-x64.zip -Force
```

5. 复制 APK：

```powershell
Copy-Item -LiteralPath build\app\outputs\flutter-apk\app-release.apk -Destination build\SimpleNote-<version>-android-release.apk -Force
```

6. 提交 release notes：

```powershell
git add README.md docs\releases\RELEASE_NOTES_<version>.md
git commit -m "docs: add <version> release notes"
git push -u origin <branch>
```

7. 打 tag 并推送：

```powershell
git tag -a <version> -m "SimpleNote <version>"
git push origin <version>
```

8. 创建 GitHub release：

```powershell
gh release create <version> build\SimpleNote-<version>-windows-x64.zip build\SimpleNote-<version>-android-release.apk --title "简记 SimpleNote <version>" --notes-file docs\releases\RELEASE_NOTES_<version>.md --latest
```

9. 核对：

```powershell
gh release view <version> --json url,tagName,name,isDraft,isPrerelease,targetCommitish,assets
```

## 10. 禁止事项

- 不要在未确认 diff 的情况下 `git add -A`。
- 不要把无实际内容的 Windows 换行噪音混入功能提交。
- 不要在 `flutter analyze` 或 `flutter test` 未通过时声称 release 可交付。
- 不要恢复 V1 同步入口作为 V2 同步替代品。
- 不要删除本文档。

## 11. 修订记录

- 2026-07-19：记录 `v2.0.0+3` 提交、推送、构建和 GitHub release 过程中的问题与解决方案。
