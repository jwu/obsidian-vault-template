本文件用于让 AI Agent 快速理解本仓库，并以一致方式协作。

- 和我协作前，必须先阅读 `99-system/work-with-me.md`。
- 要了解我的履历、兴趣爱好与长期目标，请阅读 `ABOUT-ME.md`。
- 要更深入挖掘我的各个周期的兴趣爱好、目标和转变细节，则需要遍历整个仓库。

## 1. 项目定位

这是一个 Obsidian 个人知识库，不是传统代码仓库。
主线：收集 → 分拣 → 沉淀 → 执行。
AI 的首要任务：理解内容、保留原意、帮助归类、提升可执行性。

## 2. 仓库结构

数字前缀表示阶段：
- `00~09` 收集
- `10~19` 分拣
- `20~29` 消化
- `30~39` 转化
- `80~89` 沉淀
- `98` AI 输出
- `99` 系统区

关键目录：
- `00-inbox-收件箱/`：默认入口；无法稳定分类时优先放回这里
- `01-daily-日记/`：这个项目作者的日记
- `10-todo-待办/`：任务清单
- `11-ideas-想法/`：想法清单
- `12-questions-问题/`：问题清单
- `20-research-调研/`：正在调研中的事项
- `21-learning-学习/`：正在或即将执行的学习计划
- `22-reading-阅读/`：正在看、听、读的文章、书籍、影视作品等
- `23-playing-游玩/`：正在游玩的游戏、旅游的地方等
- `30-projects-项目/`：正在进行的项目
- `80-archive-档案库/`：世间万物的档案，子目录包括：
    - `People-人物/`、`Organization-组织/`、`Paper-论文/`、`Article-文章/`、`Methodology-方法/`
    - `Website-网站/`、`Technique-技术/`、`Application-应用/`、`ArtAsset-美术资产/`、`Tutorial-教程/`
    - `Book-书籍/`、`Game-游戏/`、`Movie-电影/`、`TVShow-电视剧/`
    - `Car-汽车/`、`Product-产品/`
- `81-knowledge-知识库/`：将档案库中的事务关联起来的知识笔记
- `82-categories-索引库/`：档案库的索引与导航
- `83-data-数据库/`：数据库主要存放各种渠道获取的可信官方数据
- `90-personal-私人数据/`：这里主要存放个人的生活数据
- `98-ai-output/`：AI 专用输出区
- `99-system/`：模板、Bases 与系统规则

## 3. 协作规则

### 编辑

- 编辑任何 md 文档使用 `obsidian-markdown` Skill
- 默认使用简洁中文
- 嵌套列表的子级使用 4 空格缩进
- 引用文件夹时不要使用 `[[wikilink]]`，统一使用 ``文件夹名/`` 形式
- Markdown 表格内的 `[[wikilink|alias]]` 需写成 `[[wikilink\|alias]]`，否则 `|` 会被当作表格分隔符导致表格断裂
- 编辑已有 `.md` 笔记内容时，一律使用 `edit` tool
- 创建、重命名、移动、删除文件时，必须使用 `obsidian-cli`，并显式指定 `vault=work`
    - 新建笔记：`obsidian vault=work create name=<name> path=<dir>`
    - 移动文件：`obsidian vault=work move path=<fullpath> to=<target-dir>`
    - 重命名文件：`obsidian vault=work rename file=<name> path=<dir> name=<new-name>`
    - 删除文件：`obsidian vault=work delete file=<name> path=<dir>`
- 编辑 `01-daily-日记/` 里的日记时，请先阅读 `99-system/dairy-editing-guide.md`
- 优先小步编辑，避免大改结构或覆盖大量原文
- 不确定时保留原意，不替用户强行改写观点

### 创建

- 创建笔记前，必须先检查目标笔记是否已经存在，避免重复创建、误覆盖或制造重复笔记
- 创建笔记用 `obsidian vault=work create ...` 但不要把内容写进去，而是创建后再用 `edit` 编辑
- 新建的笔记必须包含 `created:` 属性，并写入对应创建时间
- 无法稳定分类时，优先放回 `00-inbox-收件箱/`

### 搜索

- 默认不全库扫描，按任务读取相关笔记与必要索引
- 搜索文件内容优先使用 `rg`（ripgrep），而非 `find` 或 `grep`
- 获取 GitHub 仓库信息优先使用 `gh`
- 获取 YouTube 等视频信息优先使用 `yt-dlp`
- 获取互联网信息优先使用 `uv run scrapling shell`，使用前务必阅读 `99-system/scrapling-api-guide.md`

### 提交

- Git commit message 使用 Conventional Commits 格式：`type(scope): 中文描述`
- commit message 的描述部分必须使用中文，不使用纯英文描述
- 按改动内容分批次提交，避免把无关改动混进同一个 commit

### 严禁

- 修改 `.obsidian/`、`ABOUT-ME.md`
- 增加、删除、重命名任何一级文件夹
- 增加、删除、重命名 `80-archive-档案库/` 中的文件夹

### 以下操作必须先征求用户同意

- 大规模移动、重命名文件
- 删除文件
- 覆盖大量原始内容
- 引入新的目录体系
- 批量重构历史笔记
- 提交 Git

## 4. 评分规则

若涉及评分，使用 `99-system/rating.md` 的 `1~7` 整数制，除非用户明确要求其他制式。
