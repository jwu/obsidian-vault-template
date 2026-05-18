---
created: 2026-04-20
updated: 2026-05-17
author: "[[No Name]]"
---

本规范基于 [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)，并针对本项目特点做了扩展。

## 提交信息格式

```
<type>[(scope)][!]: <description>

<body>

<footer>
```

- **type** 和 **description** 为必填，scope、body、footer 为可选。
- `!` 表示破坏性变更（BREAKING CHANGE），详见下文。

## Type

type 表示本次提交的**变更性质**。

### 标准 type

| type | 用途 | SemVer |
|------|------|--------|
| **feat** | 新功能 | MINOR |
| **fix** | bug 修复 | PATCH |
| **docs** | 文档更新 | — |
| **style** | 代码格式（不影响逻辑） | — |
| **refactor** | 代码重构（不改变行为） | — |
| **perf** | 性能优化 | — |
| **test** | 测试相关 | — |
| **build** | 构建系统或外部依赖变更 | — |
| **ci** | CI/CD 配置变更 | — |
| **chore** | 工程杂项 | — |
| **revert** | 回退之前的提交 | — |

### 项目特有 type

| type | 用途 |
|------|------|
| **assets** | 资源提交（模型、贴图、动画、音效、UI 资源、原画、策划数据等） |

## Scope

scope 表示本次提交的**影响范围**，放在 type 后面的括号内，为可选字段。

### 资源 scope（配合 `assets` type 使用）

- 3D 资源
    - **scene** — 场景资源
    - **prefab** — 预制体资源
    - **tex** — 贴图资源
    - **shd** — Shader 资源
    - **mat** — 材质球资源
    - **model** — 模型资源
    - **anim** — 动画资源
    - **sfx** — 特效资源
    - **sky** — 天空盒资源
    - **col** — 碰撞体资源
    - **bake** — 场景烘焙资源
    - **script** — 美术用脚本资源
- UI 资源
    - **bmf** — BitmapFont 字体资源
    - **skh** — Sketch 资源
    - **psd** — PSD 资源
    - **jpg** — JPG 资源
    - **png** — PNG 资源
    - **s9** — 切图资源
- 外部资源
    - **vendor** — 第三方/外部资源

### 代码模块 scope

代码模块 scope 不做限定，可根据项目实际模块自由命名，如 `api`、`parser`、`ui`、`config` 等。

## Description

description 是对本次提交的**简要描述**，紧跟在 `type[(scope)][!]:` 之后。

> 提醒：description 正文与冒号空格之间建议保留**一个半角空格**。

- 使用"添加"、"修改"、"更新"、"修正"、"调整"、"移除"等中文词汇。
- 控制在 50 字以内。
- **不要在末尾使用句号**。

## Body

当 description 不足以说明变更细节时，在 description 之后空一行书写 body。

- body 为自由格式，可包含多个自然段。
- 用于补充变更动机、上下文、实现思路等。

## Footer

footer 位于 body 之后（无 body 时位于 description 之后），同样需要空一行。遵循 [git trailer 格式](https://git-scm.com/docs/git-interpret-trailers)。

### 破坏性变更

破坏性变更（BREAKING CHANGE）必须**至少以下列一种方式**标明：

1. **`!` 前缀**：在 type/scope 与冒号之间加 `!`，如 `feat(api)!: 重构接口返回格式`
2. **`BREAKING CHANGE:` footer**：在 footer 中以大写 `BREAKING CHANGE:` 开头，后跟描述

```
feat(api)!: 重构用户接口返回格式

所有接口返回值从数组改为对象，调用方需同步修改。

BREAKING CHANGE: 返回值结构从 `User[]` 变更为 `{ list: User[], total: number }`
```

### 其他 footer

footer 还可用于引用 issue、标注审核人等：

```
fix(parser): 修正多空格解析异常

Refs: #123
Reviewed-by: Z
```

## 参考示例

```
feat(scene): 添加主战场逻辑
fix(sfx): 修正技能释放后无音效的问题
docs: 更新构建流程文档
assets(tex): 替换主角皮肤贴图
assets(anim): 添加待机动画资源
assets(vendor): 更新 DoTween 插件至 v2.0
feat(api)!: 重构网络层协议
revert: 回退之前的测试提交

Refs: 676104e
```

## 常见问题

### 不确定用哪个 type？

- 新增功能 → **feat**
- 修复问题 → **fix**
- 仅涉及资源文件 → **assets**（配合对应 scope）
- 改文档 → **docs**
- 改代码格式 → **style**
- 代码重构（不改行为） → **refactor**
- 其他工程事务 → **chore**

### 资源提交的 type 与 scope 如何搭配？

所有资源类提交统一使用 `assets` type，具体资源类型通过 scope 区分：

```
assets(tex): 替换主角贴图
assets(model): 添加怪物模型
assets(anim): 更新攻击动画
assets(sfx): 添加爆炸特效
assets(vendor): 更新第三方插件
```

### 破坏性变更如何标记？

推荐同时使用 `!` 前缀和 `BREAKING CHANGE:` footer，确保人类和工具都能识别。

### 一次提交涉及多个 scope？

建议拆分为多个提交。如果确实无法拆分，选择最主要的影响范围作为 scope，在 body 中说明其他影响。
