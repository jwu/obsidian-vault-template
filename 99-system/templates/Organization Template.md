---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
template: "[[Organization Template]]"
logo:
desc:
website:
aliases:
---
logo
```dataviewjs
const logo = dv.current().logo;
let src;

if (logo && logo.path) {
    const file = app.vault.getAbstractFileByPath(logo.path);
    src = app.vault.getResourcePath(file);
} else {
    src = logo;
}

if (src) {
    dv.el("img", "", { attr: { src: src, width: "200" } });
}
```

## 文章
- [(2026-01-01) 文章标题](链接地址)

## 产品
- 产品链接

