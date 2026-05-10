---
created: 2026-04-18
tags:
  - system
  - tool
  - scraping
---
# Scrapling Python API 使用指南

## 三个 Fetcher

| Fetcher           | 底层                    | 何时用          |
| ----------------- | --------------------- | ------------ |
| `Fetcher`         | curl_cffi             | 静态页面、不需要 JS  |
| `DynamicFetcher`  | Playwright + Chromium | SPA 动态页面     |
| `StealthyFetcher` | Playwright + Camoufox | 反爬严格 / 需要登录态 |

## 抓取优先级

按以下顺序尝试，直到拿到内容：

```python
from scrapling.fetchers import Fetcher, DynamicFetcher, StealthyFetcher
from scrapling.core.shell import Convertor

def extract(page, mode='markdown'):
    return ''.join(Convertor._extract_content(page, extraction_type=mode, main_content_only=True))

url = 'https://example.com'

# 1. 静态抓取（最快）
page = Fetcher.get(url)

# 2. SPA 动态页面
page = DynamicFetcher.fetch(url, network_idle=True, wait=3000)

# 3. 遇反爬
page = StealthyFetcher.fetch(url, network_idle=True, wait=3000)

# 4. 需要登录态（见 Twitter 方案）
```

## 内容提取

`Convertor._extract_content(page, extraction_type, main_content_only=True)` 等价于 CLI 的 `--ai-targeted`：

- 去掉 script、style、noscript、svg 等噪音标签
- 去掉隐藏元素、aria-hidden、零宽字符
- 只保留 `<body>` 内的主内容
- `extraction_type` 支持 `'markdown'`（推荐）、`'html'`、`'text'`

## 运行方式

所有 Python API 通过 `scrapling shell` 运行：

```bash
uv run scrapling shell -L warning -c "你的代码"
```

## 特定站点抓取指南

只写 agent 需要立刻知道的站点处理规则。以后新增站点，也按这个格式补充：**站点 → 用什么 fetcher → 有什么限制**。

### Twitter / X

- **用法**：`StealthyFetcher` + `cookies`
- **原因**：需要登录态，且是 SPA
- **Cookie 获取**：浏览器登录后，从 `https://x.com` 的 Cookies 中取 `auth_token`、`ct0`、`twid`
- **注意**：
    - `cookies` 必须是 Playwright `SetCookieParam` 的 array，不是 dict
    - 每个 cookie 都要有 `name`、`value`、`domain`、`path`
    - `timeout` 建议 `90000+`
    - Cookie 会过期，发现过期提醒用户更新

```python
from scrapling.fetchers import StealthyFetcher
from scrapling.core.shell import Convertor

cookies = [
    {'name': 'auth_token', 'value': 'xxx', 'domain': '.x.com', 'path': '/'},
    {'name': 'ct0', 'value': 'xxx', 'domain': '.x.com', 'path': '/'},
    {'name': 'twid', 'value': 'u%3D用户ID', 'domain': '.x.com', 'path': '/'},
]

page = StealthyFetcher.fetch(
    'https://x.com/目标用户名',
    cookies=cookies,
    network_idle=True,
    wait=5000,
    timeout=90000,
)
text = ''.join(Convertor._extract_content(page, extraction_type='markdown', main_content_only=True))
```

### Shadertoy

- **用法**：优先 `StealthyFetcher`
- **原因**：Cloudflare 保护；`Fetcher` 常 403，`DynamicFetcher` 也可能只拿到 challenge 页面
- **限制**：
    - scrapling 通常只能稳定拿到 HTML 和页面元信息
    - shader 源码是后续 API 动态注入的，通常不在初始 HTML 里
    - scrapling 不暴露底层 Playwright page，无法拦截请求或执行额外 JS
- **结论**：
    - 需要标题、作者、描述、评论等元信息 → 用 `StealthyFetcher`
    - 需要 shader 源码 → scrapling 不适合，改用 Wayback / 缓存 / Playwright-CDP 手动方案

## Windows 环境（GBK 编码问题）

Windows 终端默认 GBK，`print()` 遇 Unicode 字符（如 `⊶`、emoji 等）会触发 `UnicodeEncodeError`，即使内容已抓到也会崩溃。

**解决方案：写到系统临时目录而非 print**

```python
import tempfile, os
outfile = os.path.join(tempfile.gettempdir(), 'scrapling_output.txt')
with open(outfile, 'w', encoding='utf-8') as f:
    f.write(text)
print('DONE, length:', len(text))
```

读取结果：

```bash
# Linux / macOS
cat /tmp/scrapling_output.txt
# Windows
cat %TEMP%/scrapling_output.txt
```

抓完记得清理临时文件：

```bash
rm -f ${TEMP:-/tmp}/scrapling_output.txt
```

## Response 对象注意

- 无 `.html` 属性，用 `page.html_content` 获取原始 HTML
- 无 `.page` 属性（不暴露底层 Playwright page），无法手动滚动、等待额外加载
- 只能拿到首屏内容，无法通过滚动获取更多
- 常用属性：`.status`、`.url`、`.text`、`.cookies`、`.css()`、`.xpath()`

## 杂项

- `DynamicFetcher` 和 `StealthyFetcher` 支持 `cdp_url` 参数连接已启动的 Chrome 实例（需 `--remote-debugging-port=9222`）
- 更多参数见 `uv run scrapling extract <command> --help` 或源码 https://github.com/D4Vinci/Scrapling
