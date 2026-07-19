# Codex Skills 使用记录

本项目开发过程中主要使用了以下 Codex skills / 工作流。

## planning-with-files

用途：

- 按 `GOAL.md` 拆解每个阶段目标。
- 维护 `task_plan.md`、`findings.md`、`progress.md`。
- 按阶段执行实现、测试、修复和验收。

使用阶段：

- P1 应用壳与导航。
- P2 本地数据库。
- P3 笔记 MVP。
- P4 待办 MVP。
- P5 主题自定义。
- P6 局域网同步 MVP。
- P7 体验打磨。

## github:yeet / GitHub 发布流程

用途：

- 整理本地改动。
- 提交 commit。
- 更新 GitHub PR。
- 处理本地分支与远端 PR 分支历史不一致时的发布流程。

项目内也新增了辅助脚本：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\update_pr.ps1 "提交信息"
```

## github:gh-fix-ci

用途：

- 定位 GitHub Actions 失败原因。
- 将默认 Dart workflow 修正为 Flutter workflow。
- 验证 CI 通过。

## 其他说明

本项目没有引入云服务、账号系统或外部 AI API。Codex skills 主要用于工程规划、代码实现、CI 修复、PR 更新和发布整理。
