---
name: archive-wikilink-repair
version: 1
description: 修复 Obsidian 档案库内“已有档案但未使用 wikilink”的提及。用于处理 80-archive-档案库/ 内已有对应笔记的纯文本、frontmatter 字段值、Markdown 外链，并把确认同一事物的提及改为 wikilink。
agents: [main_agent]
---

# Skill: 档案库 Wikilink 修复

## 目标

只针对 `80-archive-档案库/` 内的笔记，找出“源笔记提到某个事物，且该事物在 `80-archive-档案库/` 已有对应档案，但当前提及不是 wikilink”的位置；确认同一事物后改成 Obsidian wikilink。

## 触发场景

用户要求：修复档案库内部 wikilink、把已有档案链接起来、将外链替换为内部链接、检查某篇档案中可 wikilink 的对象。

## MUST

- MUST 只处理 `80-archive-档案库/` 内的源文件和目标档案。
- MUST 先读取源笔记，理解上下文。
- MUST 确认目标档案已经存在于 `80-archive-档案库/`。
- MUST 确认当前提及和目标档案是同一事物，再改成 wikilink。
- MUST 不处理“已有 wikilink 但目标笔记缺失”的问题。
- MUST 不为不存在的目标档案创建新链接。
- MUST 不做全库无脑字符串替换。
- MUST 使用 `edit` 精确修改已有 `.md` 文件。
- MUST 保留原文含义，只替换链接表达。
- MUST 默认小批量处理，并汇报修改范围。

## SHOULD

- SHOULD 优先处理高置信关系：
    - `author` → `People-人物/`
    - `developer` / 公司名 → `Organization-组织/`
    - 论文标题 → `Paper-论文/`
    - 应用名 → `Application-应用/`
    - 技术 / 工具 / 库名 → `Technique-技术/`
    - 产品名 → `Product-产品/`
- SHOULD 优先处理 Markdown 外链文字等于已有档案名或 alias 的情况。
- SHOULD 对显示名不同的提及使用别名显示：`[[target|Display Text]]`。
- SHOULD 在 YAML frontmatter 中使用带引号的 wikilink：`"[[Name]]"`。
- SHOULD 对歧义词先跳过或列入待确认清单。

## MUST NOT

- MUST NOT 修改 `ABOUT-ME.md`、`.obsidian/`。
- MUST NOT 增加、删除、重命名一级目录或 `80-archive-档案库/` 中的文件夹。
- MUST NOT 因为字符串相同就自动替换。
- MUST NOT 修改代码块内容，除非用户明确要求。
- MUST NOT 修改普通 URL 中的文本。
- MUST NOT 批量把 `tags:` 改成 wikilink，除非用户明确要求。

## 默认跳过的歧义词

`go`、`pi`、`uv`、`rg`、`rio`、`c`、`cpp`、`rust`、`python`

若上下文充分确认，可以局部处理，例如：`[[ripgrep]]`、`[[python|Python]]`。

## 工作流程

1. 收集 `80-archive-档案库/` 中已有档案的文件名 stem、frontmatter `aliases`、所在类别目录。
2. 读取待处理源笔记，识别 frontmatter、正文、已有 wikilink、Markdown 外链。
3. 跳过代码块、图片链接、普通 URL、已有 wikilink。
4. 判断是否同一事物：名称等于目标档案名或 alias；字段语义匹配目标类型；上下文明确指向同一对象；源笔记和目标档案描述一致。
5. 能确认则用 `edit` 小步替换；不能确认则不改，列入待确认。

## 替换规则

### frontmatter 单值

```yaml
author: Xue Bin Peng
```

```yaml
author: "[[Xue Bin Peng]]"
```

### frontmatter 列表

```yaml
author:
  - Xue Bin Peng
```

```yaml
author:
  - "[[Xue Bin Peng]]"
```

### 正文纯文本

```md
MimicKit 是 Xue Bin Peng 开源的轻量级 motion imitation 框架。
```

```md
MimicKit 是 [[Xue Bin Peng]] 开源的轻量级 motion imitation 框架。
```

### 显示名不同

```md
基于 Dear ImGui 的字体工具。
```

```md
基于 [[imgui|Dear ImGui]] 的字体工具。
```

### Markdown 外链文字已有档案

用户偏好：直接替换为 wikilink，不保留原外链。

```md
[raylib](https://github.com/raysan5/raylib)
```

```md
[[raylib]]
```

```md
[The Machinery](https://example.com)
```

```md
[[the-machinery|The Machinery]]
```

### 外链后面已有内部链接

```md
[(2023-10-16) Animation Networking](https://youtube.com/...) → [[(2023-10-16) Animation Networking]]
```

```md
[[(2023-10-16) Animation Networking]]
```

## 输出格式

执行前若用户要求先确认：

```md
## 高置信待改清单
- `源文件`
    - 原文 / 字段：`...`
    - 建议：`[[目标]]`
    - 目标档案：`80-archive-档案库/.../目标.md`
    - 确认理由：...

## 暂不处理
- `...`：原因
```

执行后：

```md
已完成本轮档案库 wikilink 修复。
- 修改文件数：N
- 修改类型：frontmatter / 正文纯文本 / Markdown 外链
- 跳过内容：歧义词、缺失档案、无法确认同一事物的提及
```

## 最小示例

输入：

```yaml
---
author:
  - Xue Bin Peng
---
MimicKit 是 Xue Bin Peng 开源的框架。
- [raylib](https://github.com/raysan5/raylib)
```

已有目标档案：

```text
80-archive-档案库/People-人物/Xue Bin Peng.md
80-archive-档案库/Technique-技术/raylib.md
```

输出：

```yaml
---
author:
  - "[[Xue Bin Peng]]"
---
MimicKit 是 [[Xue Bin Peng]] 开源的框架。
- [[raylib]]
```
