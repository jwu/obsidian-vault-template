---
name: org-archiving
description: 为该知识库创建或更新组织档案笔记。用户要给某个组织、机构、公司、协会或社区建档、补充资料、挖掘社媒信息、整理会议/产品/团队信息时使用。
allowed-tools: read bash edit write grep find ls
---

# Organization Archiving

为本项目中的组织（机构、公司、协会、社区、会议主办方等）建立或完善档案，输出到 `80-archive-档案库/Organization-组织/`，并尽量保持与现有组织笔记一致的结构、语气与信息密度。

## When to use

在以下情况使用本技能：
- 用户要求为某个组织建立档案
- 用户提供一个组织名、官网链接或社媒链接，希望整理成标准组织笔记
- 用户要求补充某个组织的团队、产品、会议或社媒信息

## References

开始前优先读取这些参考材料：
- `../../../99-system/templates/Organization Template.md`

如需对齐现有风格，可查看 `80-archive-档案库/Organization-组织/` 下已有笔记，例如：
- `../../../80-archive-档案库/Organization-组织/ACM SIGGRAPH.md`
- `../../../80-archive-档案库/Organization-组织/GDC Vault.md`
- `../../../80-archive-档案库/Organization-组织/Khronos Group.md`

## Output

组织档案统一放在：
- `80-archive-档案库/Organization-组织/`

默认要求：
- 文件名使用组织常用名
- 笔记需包含 `created:` 属性
- 优先沿用 `[[Organization Template]]` 的结构

## Rules

- 默认使用简洁中文
- 保留事实，不臆测
- 优先小步补充，不大改原文
- 如果信息不确定，宁可留空，也不要强填
- 编辑 Markdown 内容时保持 Obsidian 兼容
- 引用文件夹时不要使用 `[[wikilink]]`，统一使用 `文件夹名/` 形式
- 若需创建、移动、重命名组织笔记，遵循项目要求，使用 `obsidian vault=work ...` 完成
- 笔记内容中提及的技术、人物、概念、其他组织等，若库内已有对应笔记则使用 wikilink，若是外部资源则使用外部链接，尽量让内容可导航

## Workflow

### 1. 确认输入

用户可能提供：
- 一个组织名（最常见，如「SIGGRAPH」「Khronos Group」）
- 组织名 + 官网链接
- 组织名 + 社媒链接
- 组织名 + 领域描述（如「那个做开放标准的行业协会」）

目标是先确认"要归档的是哪个组织"。

- 如果用户提供的信息已经足够唯一定位到该组织，则继续下一步
- 如果信息过少、存在重名，或无法确认是否为目标组织，则先向用户确认
- 在组织身份未确认前，不要擅自创建笔记或合并到现有笔记

### 2. 确认是否已有笔记

先搜索 `80-archive-档案库/Organization-组织/` 中是否已有同名或近似组织笔记。

- 如果已有：在原笔记上补充
- 如果没有：基于模板新建
- 如果出现同名或疑似重名组织：先暂停并向用户确认，不要擅自合并

### 3. 信息收集与内容整理

#### 基本信息

优先从以下来源获取：
- 官网（首页、About 页、History 页）
- 维基百科（组织简介、成立时间）
- 社媒主页（YouTube、Twitter/X、LinkedIn、Facebook 等）

#### Logo

从官网获取组织 logo：
- 优先找首页 header 中的 logo 图片（通常在 `<img>` 或 `<svg>` 标签中）
- 用 `curl` 下载到本地 `80-archive-档案库/Organization-组织/@media/` 目录
- 文件命名格式：`组织名-毫秒时间戳.扩展名`（如 `ACM SIGGRAPH-1779107063302.svg`）
- 支持 svg、png、webp 格式

#### 社媒链接

通过官网 footer、Contact 页面或页面源码，挖掘以下社媒链接：
- YouTube
- Twitter / X
- LinkedIn
- Facebook
- Instagram
- Bluesky
- 其他平台（如 B 站、抖音等，按需）

从页面 HTML 源码中搜索社媒域名（`twitter.com`、`x.com`、`linkedin.com`、`facebook.com`、`youtube.com`、`instagram.com` 等）来提取社媒链接。

#### 团队信息

从 About / Governance / Team 页面获取：
- 组织架构（如 Executive Committee、Board of Directors 等）
- 核心人员及其职务
- 如人员较多，优先列出最高层领导或最知名的成员

#### 产品/会议/出版

根据组织类型，收集其核心产出：
- 会议/活动（名称、周期、链接）
- 产品/服务
- 出版物/标准

### 4. 生产档案文件

#### 建立 frontmatter 属性

优先整理这些属性：

```yaml
---
created: YYYY-MM-DD
template: "[[Organization Template]]"
logo: "[[组织名-时间戳.svg|300]]"
desc:
website:
youtube:
twitter:
linkedin:
facebook:
instagram:
aliases:
---
```

填写规则：
- `desc`：一句话说明这个组织是什么、做什么
- `website`：官网链接
- `logo`：本地 logo 图片的 wikilink embed，格式 `"[[文件名|300]]"`
- `youtube` / `twitter` / `linkedin` / `facebook` / `instagram`：填主页链接
- `aliases`：仅在确有常见别名、缩写、全称时填写
- 未找到或无法确认的社媒字段，直接省略，不要保留空字段
- 仅保留已确认且对后续检索、补充有价值的属性

#### 使用统一格式写入正文

正文结构严格遵循 `[[Organization Template]]`：

```md
## 简介
- 简要介绍这个组织是什么、干什么、创办目的和创办时间

## 团队
- 创始人、组织结构、核心成员
- 每项一行无序列表

## 产品
- [产品名 (2026)](链接地址)
- 包括会议、出版物、标准、服务等

## 文章
- [(2026-01-01) 文章标题](链接地址)

## 其他
- 补充信息，如合作伙伴、下属机构、历史事件等
```

格式要求：
- 简介：简洁说明组织的性质、定位、创办时间、覆盖领域
- 团队：核心成员与组织架构，每项一行
- 产品：会议、出版物、标准、服务等核心产出，格式 `[名称 (年份)](链接)` 或 `[名称](链接)`
- 文章：与组织相关的重要文章（非博客主页），格式 `[(YYYY-MM-DD) 文章标题](链接)`
- 其他：补充信息，注意**不要重复 frontmatter 中已有的信息**（如网站、社媒链接）
- 各节按模板顺序排列，**没有内容的节直接去掉**，不保留空节
- 时间相关条目（文章、产品）统一按时间降序排列

## Ambiguity handling

遇到以下情况时，优先保守处理：
- 无法确认是否为同一组织：先向用户确认
- 多个来源信息冲突：优先采用官网信息；若仍无法判断，则暂不写入
- 团队信息不完整或过时：优先记录当前已知信息，标注年份范围
- 某栏目暂无可靠信息：可保留空节或不写入该节
- 组织有多个名称/品牌（如母公司 vs 子品牌）：优先记录最常用的名称，补充关系说明

## Quality bar

- 优先记录"长期有价值"的组织定位与核心产出，而不是堆链接
- 简介应让读者快速判断"这个组织做什么、为什么重要"
- 团队应列出关键决策者，不必穷举所有成员
- 产品应覆盖组织最核心的会议/出版物/标准
- 其他中的补充信息应有独立价值，而非 frontmatter 的重复
- 如果条目很多，先选最能代表此组织的核心信息
- 若发现已有内容结构混乱，先轻量整理，再补充信息
- 输出应便于后续持续补充，而不是一次性塞满

## Delivery

完成后，简要说明：
- 新建了还是更新了哪一篇组织笔记
- 补充了哪些信息，如 logo、社媒、团队、产品
- 哪些信息仍缺失或待确认
