---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
template: "[[People Template]]"
avatar:
desc:
website:
github:
twitter:
youtube:
B 站:
抖音:
小红书:
aliases:
---
avatar
```dataviewjs
const avatar = dv.current().avatar;
if (avatar) {
    dv.el("img", "", { attr: { src: avatar, width: "200" } });
}
```

## 访谈
- 访谈链接

## 文章
- [(2026-01-01) 文章标题](链接地址)

## 视频
- [(2026-01-01) 视频标题](链接地址)

## 作品
- 代码仓库链接

## 履历
- 2020-02-02 ~ 2022-02-02 就职于 foobar
