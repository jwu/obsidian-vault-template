---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
template: "[[Video Game Template]]"
cover:
developer:
publisher:
genre:
release date:
platform:
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
