---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
template: "[[Book Template]]"
cover:
author:
genre:
website:
release date:
rating:
---
cover
```dataviewjs
const cover = dv.current().cover;
if (cover) {
    dv.el("img", "", { attr: { src: cover, width: "200" } });
}
```
