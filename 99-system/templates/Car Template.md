---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
template: "[[Car Template]]"
cover:
developer:
release date:
rating:
aliases:
---
cover
```dataviewjs
const cover = dv.current().cover;
let src;

if (cover && cover.path) {
    const file = app.vault.getAbstractFileByPath(cover.path);
    src = app.vault.getResourcePath(file);
} else {
    src = cover;
}

if (src) {
    dv.el("img", "", { attr: { src: src, width: "200" } });
}
```
