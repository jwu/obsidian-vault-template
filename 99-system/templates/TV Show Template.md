---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
template: "[[TV Show Template]]"
cover:
genre:
creator:
cast:
release date:
rating:
aliases:
---
cover
```dataviewjs
const cover = dv.current().cover;
if (cover) {
    dv.el("img", "", { attr: { src: cover, width: "200" } });
}
```
