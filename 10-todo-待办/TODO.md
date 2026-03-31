---
created: 2026-03-22
tags:
  - todo
---
这里汇总了所有日记里的待办事项

```dataview
TASK
WHERE !completed
AND file.folder = "01-daily-日记"
AND !contains(text, "N/A")
GROUP BY file.name
SORT rows.file.name DESC
```
