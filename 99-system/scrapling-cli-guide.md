---
created: 2026-04-18
tags:
  - system
  - tool
  - scraping
---
# Scrapling CLI 使用指南

CLI 适合快速一次性抓取，不需要登录态的场景。功能比 Python API 少（无 cookies、cdp_url、page_action），但一行命令即可完成。

## 抓取优先级

```bash
# 临时输出文件路径（跨平台）
OUT="${TEMP:-/tmp}/scrapling_output.md"

# 1. 静态 GET（最快，适合普通网页）
uv run scrapling extract get --ai-targeted <url> "$OUT"

# 2. SPA 动态页面（Playwright 渲染）
uv run scrapling extract fetch --network-idle --wait=3000 --ai-targeted <url> "$OUT"

# 3. 隐身浏览器（反爬严格）
uv run scrapling extract stealthy-fetch --network-idle --wait=3000 --ai-targeted <url> "$OUT"
```

读取结果后记得清理：`rm -f "${TEMP:-/tmp}/scrapling_output.md"`

更多参数见 `uv run scrapling extract <command> --help`。

## 常用参数

| 参数 | 说明 |
|------|------|
| `--ai-targeted` | 去噪保结构，只保留主内容，省 token |
| `--network-idle` | 等待网络空闲（SPA 内容加载完毕后采集） |
| `--wait=3000` | 页面加载后再等待 N 毫秒 |
| `--headless / --no-headless` | 无头/有头模式（调试时用 `--no-headless`） |
| `--real-chrome` | 使用本地 Chrome 而非内置 Chromium |
| `--wait-selector=xxx` | 等待特定 CSS 选择器出现 |
| `--proxy=http://user:pass@host:port` | 使用代理 |
| `--extra-headers "Key: Value"` | 附加请求头 |
| `--solve-cloudflare` | 自动解决 Cloudflare 验证（仅 stealthy-fetch） |

## 输出格式

根据文件扩展名自动判断：

- `.md` → Markdown（推荐，最省 token）
- `.html` → 原始 HTML
- `.txt` → 纯文本

## 踩坑记录

| 方案                            | 问题                                                       |
| ----------------------------- | -------------------------------------------------------- |
| `get` 抓 Twitter               | SPA 不渲染，只返回登录墙                                           |
| `fetch / stealthy-fetch` 无登录态 | 能拿到个人资料，拿不到推文列表                                          |
| `--extra-headers Cookie`      | Cookie 在 HTTP header 中，不进浏览器 cookie store，Twitter JS 读不到 |

需要登录态的场景请用 Python API，见 `99-system/scrapling-api-guide.md`。
