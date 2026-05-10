---
description: 分析 git 改动并按规范分批提交
argument-hint: "[--ask]"
---

请按以下步骤处理本次提交：

## 0. 参数解析

- 如果参数包含 `--ask`：展示分组方案和提交命令后，先向用户确认，确认后再逐批提交
- 如果参数不包含 `--ask`：展示分组方案和提交命令后，直接逐批执行提交，不要等待用户确认

## 1. 查看改动
执行以下命令了解当前状态：
- `git status --short` — 查看所有改动文件
- `git diff --stat` — 查看改动统计
- `git diff --cached --stat` — 查看已暂存的改动
- `git log --oneline -10` — 参考最近的提交风格

## 2. 分析并分组
根据改动文件的内容、路径和变更性质，将改动分为逻辑独立的批次：

- **不同类型分开提交**：feat、fix、docs、style、refactor、perf、test、build、ci、chore、revert 等各自成批
- **不同模块分开提交**：不相关的文件改动不要混在一起
- **每个批次应可独立回滚**：单一批次的改动应有完整的意义
- **优先提交依赖项**：被后续改动依赖的批次先提交

## 3. 生成提交信息
每个批次生成符合项目规范的提交信息：

- 格式：`<type>: <简短描述>`
- type 类型：feat / fix / docs / style / refactor / perf / test / build / ci / chore / revert
- 描述用简洁中文，动词开头，不超过 50 字
- 复杂改动可在 `git commit -m` 中追加 `-m "<详细说明>"`

## 4. 展示并提交
向我展示分组方案和对应的提交命令，格式如下：

```
批次 1/3 — feat: 新增 xxx 功能
  M  src/xxx.ts
  A  src/xxx.test.ts
  命令: git add src/xxx.ts src/xxx.test.ts && git commit -m "feat: 新增 xxx 功能"

批次 2/3 — docs: 更新 README
  ...

批次 3/3 — chore: 清理未使用依赖
  ...
```

然后按参数决定是否执行：
- 有 `--ask`：等待用户确认后，再逐批执行
- 没有 `--ask`：直接逐批执行

执行时每个批次依次运行：
- `git add <files>` — 暂存该批次文件
- `git commit -m "<message>"` — 提交

## 注意事项
- **绝不 force push 或修改已推送的历史**
- 只有传入 `--ask` 时才需要等待用户确认；默认直接执行提交
- 提交前检查是否有未解决的合并冲突
- 如果工作区干净无改动，直接告知无需提交
- 如果只有一个逻辑批次，无需强行拆分
