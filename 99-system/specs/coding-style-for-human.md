---
created: 2026-05-01
---
## 书写优秀代码三原则

- KISS (Keep it simple, stupid)
- Unix Philosophy
	- Write programs that do one thing and do it well.
    - Write programs to work together.
    - Write programs to handle text streams, because that is a universal interface.
- DRY (Don't Repeat Yourself)

## 准则

### 制定代码规范的考量点

- 是否易于阅读（Good for Read）
- 是否方便代码审核（Good for Code Review）
- 是否方便解决冲突（Good for Diff）

### 修订代码规范时需要遵守

- 代码规范不是教条，随着项目的发展会不断修订和改进。
- 修订规范需要讲出好的理由而不是凭借个人喜好。

### 应用代码规范时需要遵守

- 老旧代码的代码规范应逐步纠正而不是强制要求。
- 当为老旧代码（以文件为单位）添加功能时，请先和老旧代码的风格保持一致。
- 请注意纠正代码规范和书写新功能是不同的提交，不要把纠正规范和新功能开发两部分改动混在一份提交内完成。
- 在性能关系重大的代码中，性能优化比代码规范更重要。
- 第三方库扩展中，请和其风格保持一致。

### 主要内容

- 书写风格（Formatting）
- 命名规范（Naming Conventions）
- 表达式（Statements）
- 代码设计（Code Design）
- 代码顺序（Code Order）
- 参考样例（Example）

