# SimpleNote 文档索引

> 当前文档入口。阅读项目状态、验收记录或后续计划时，优先从这里进入，避免被 v1/MVP 历史文档带偏。

## 当前状态

- 当前发布基线：`v2.1.0+4`
- 已完成：V2 Phase 1、V2 Phase 2 Task 15-20、V2 Phase 3 Task 21-26
- 当前后续重点：Phase 4 V2 局域网同步、备份、导入导出与最终交付
- 生产环境仍禁用旧 V1 同步入口；V2 同步在 Phase 4 重新实现

## 当前应优先阅读

- [V2 总体设计蓝本](superpowers/specs/2026-07-17-ticktick-style-v2-design.md)
- [V2 Phase 3/4 详细设计与实施计划](superpowers/plans/2026-07-19-phase-3-4-habits-statistics-sync-plan-DO-NOT-DELETE.md)
- [V2 Phase 1 验收记录](acceptance/V2_PHASE_1_ACCEPTANCE.md)
- [V2 Phase 2 验收记录](acceptance/V2_PHASE_2_ACCEPTANCE.md)
- [V2 Phase 3 验收记录](acceptance/V2_PHASE_3_ACCEPTANCE.md)
- [v2.0.0+3 发布说明](releases/RELEASE_NOTES_v2.0.0+3.md)
- [v2.1.0+4 发布说明](releases/RELEASE_NOTES_v2.1.0+4.md)

## 目录结构

```text
docs/
  README.md                 当前文档索引
  acceptance/               阶段验收记录
  releases/                 发布说明
  archive/v1/               v1/MVP 历史需求、架构、阶段计划和总结
  process/                  工具、技能和流程记录
  superpowers/specs/        V2 设计规格
  superpowers/plans/        V2 分阶段实施计划
```

## 历史文档

`archive/v1/` 中的文档保留为项目演进记录。它们描述的是 v1/MVP 阶段的产品、架构和同步方案，其中关于旧待办、旧主题和 V1 局域网同步的内容不再代表当前生产状态。

当前开发应以 `superpowers/specs/2026-07-17-ticktick-style-v2-design.md` 和 `superpowers/plans/2026-07-19-phase-3-4-habits-statistics-sync-plan-DO-NOT-DELETE.md` 为准。
