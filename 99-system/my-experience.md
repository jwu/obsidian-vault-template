---
created: 2026-05-16
modified: 2026-09-30
---
## 目录结构

```
~
├── bin/                # 工具与配置源
├── src/                # 从 github 等地方下载的源码
├── dev/                # 开发中的代码
└── work/               # obsidian 知识库
```

### bin/

```
bin/
├── dotfiles/           # chezmoi 源：机器配置与装机脚本的唯一真源
├── pi-config/          # pi 的安装脚本与参考模板
└── platform-tools/     # Android SDK 平台工具（adb / fastboot 等）
```

`dotfiles/` 用 [chezmoi](https://www.chezmoi.io/) 一套源同时驱动 Arch Linux、macOS 与 Windows 三台机器。

### src/

从 github 等地方下载的第三方源码，按 `项目名@作者` 命名并管理。

```
src/
├── bevy@bevyengine/
├── godot@godotengine/
└── zed@zed-industries/
```

### dev/

自己开发中的代码，一级目录按归属或领域划分，下面再放具体项目。

```
dev/
├── jwu/                # 个人项目
├── org-a/              # 组织 / 公司项目
├── tools/              # 自研小工具
├── playground/         # 实验环境（见下）
└── games/              # 游戏原型
```

`~/dev/jwu/`、`~/dev/org-a/`、`~/dev/tools/`、`~/bin/dotfiles/`、`~/bin/pi-config/`、`~/work/` 也是 `~/.gitconfig` 里 `includeIf` 切换提交身份的边界。

### work/

Obsidian 知识库，推双远端：github 的 `jwu/work` 与 codeberg 的 `jwu/work`。

## 配置文件

我的配置信息
- [jwu/dotfiles](https://github.com/jwu/dotfiles) 机器配置与装机脚本的唯一真源，2026-09-27 起取代已归档的 `jwu/configs` 与 `jwu/desktop-settings`
- [jwu/pi-config](https://github.com/jwu/pi-config) pi 的安装脚本与参考模板

## 实验环境

实验代码统一落在 `~/dev/playground/` 下，每类实验各占一个目录。

```
playground/
├── aigc-playground/        # AIGC 相关工作流
├── bevy-playground/        # Bevy 最小可运行工程
├── blender-playground/     # Blender 与 Godot 的资产流程
├── coding-agent-playground/  # 编码 agent 的试验场
├── gamedev-playground/     # Gameplay 小技巧收集与验证（github: jwu/gamedev-playground）
├── godot-playground/       # Godot 游戏机制原型（github: jwu/godot-playground）
├── nvim-playground/        # Neovim 插件开发试验场
├── openpencil-playground/  # 暂空
├── pi-playground/          # pi 插件测试沙盒
└── scrap-playground/       # 抓取工具对比评估
```