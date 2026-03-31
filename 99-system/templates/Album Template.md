---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
template: "[[Album Template]]"
cover:
genre:
artist:
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
