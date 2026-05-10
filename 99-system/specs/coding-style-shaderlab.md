---
created: 2026-04-20
updated: 2026-04-20
author:
  - "[[No Name]]"
---
## 优秀的 Shader 代码满足但不限于以下特征

- 计算的目标清晰, 计算的过程简单
- 尽量将一个固定功能的多行代码用函数表达
- 如果函数能被其他 Shader 反复调用，应当做一个库文件，封装这些函数
- 计算过程有序, 不要将不同计算目标的代码穿插写在一起

## AI 速查（AI Quick Reference）

以下为 AI Agent 协作 Shader 时的硬约束，按权重分为三级：**必须（MUST）** > **应该（SHOULD）** > **可以（MAY）**。冲突时高权重覆盖低权重。

### 格式
- **MUST** 左大括号与语句同行，右大括号另起一行
- **MUST** 4 空格缩进，tab 转空格
- **MUST** 数学符号两侧空格，逗号/分号后空格
- **MUST** Properties 变量类型紧跟变量名，语义名紧跟冒号
- **MUST** 注释符号后加空格

### 命名
- **MUST** Shader 名/函数名/属性名 `PascalCase`（全大写开头）
- **MUST** 变量名/结构体/函数参数 `camelCase`（`_` 后首字母大写）
- **MUST** 自定义宏 `_` 开头全大写
- **MUST** 文件名 `PascalCase`，用 `.` 补充说明

### 表达式
- **MUST** if/for/while 写完整格式，不省略大括号
- **MUST** else 紧跟 if 结束大括号

### 代码设计
- **SHOULD** 按效果分类封装函数库（如 Lighting.hlsl）
- **SHOULD** 可复用函数封装为库文件
- **SHOULD** 删除废弃代码，用 Git 回溯

### 排版
- **MUST** 顺序：宏编译指令 → include → 变量 → 结构体 → 自定义函数 → vertex/fragment shader

> 以下为完整规范，速查区与详细规则冲突时以详细规则为准。

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

- 书写风格
- 命名规范
- 表达式
- 代码设计
- 代码顺序

## 书写风格（Formatting）

书写风格主要从 Unity 官方 ShaderLab 结合 [[coding-style-csharp]] 的风格和写法继承而来

### 大括号（Braces）

- **规则** ：所有 **左大括号** 都和表达式在同一行，所有 **右大括号** 都另起一行。
- **理由** ：减少代码函数从而减少代码审核负担。减少无效信息的产生。

**GOOD**

```
Shader ".../..."{
    Properties {
        _Var("variable", float) = 0
    }
}
```

**BAD**

```
Shader ".../..."
{
    Properties
    {
        _Var("variable", float) = 0
    }
}
```

### 缩进（Indentation）

- **规则** ：使用 **4 空格（4 spaces）** 缩进， **tab** 键强制转成 **4 空格** 间隔。
- **不使用 tab 的理由** ：虽然 tab 缩进可以根据开发者本地文本编辑器需求自动调节缩进距离，但是我们在做代码审核的时候通常是在网页上进行，根据网页的 css 设置规则会呈现不同的缩进间隔影响阅读。
- **强制将 tab 转换为空格理由** ：空格与 tab 混合使用，无论在本地文本编辑器还是在网页端都会由于 tab 缩进设置不同而带来缩进不一致的情况。
- **使用 4 空格的理由** ：2 空格和 4 空格都有大批的簇拥者。考虑到 2 空格是近期才开始在各个程序社群中流行，且公司内已有代码多数采用 4 空格缩进，故沿用 4 空格标准。

**GOOD**

```
structa2v {
∙∙∙∙float4 vertex :POSITION;
}

#ifdef _NORMALMAP
∙∙∙∙float4 texcoord_Normal :TEXCOORD0;
∙∙∙∙float4 tangent_World :TEXCOORD1;
∙∙∙∙float3 binormal_World :TEXCOORD2;
#endif
```

**BAD**

```
structa2v {
∙∙float4 vertex :POSITION;
}

#ifdef _NORMALMAP
float4 texcoord_Normal :TEXCOORD5;
float4 tangent_World :TEXCOORD3;
float3 binormal_World :TEXCOORD4;
#endif
```

### 间隔（Interval）

- **规则** ：在数学符号两边加入空格，逗号和分号之后需要空格, Properties的变量类型紧跟变量名, 语义名紧跟冒号, 函数参数列表紧跟函数名, 函数名和大括号之间需要空格
- **理由** ：减少代码阅读负担。

**GOOD**

```
_Color("Color", Color) = (1, 1, 1, 1)

[KeywordEnum(On, Off)] _Use_NormalMap("Use NormalMap", float) = 0

if(a + 5 > method(blah() + 4)) { ... }

float4 vertex :POSITION;

half DoSomething(float3 _Direction, Light light) { ... }
```

**BAD**

```
_Color (" Color ",Color)=(1, 1,1, 1)

[ KeywordEnum(On , Off)] _Use_NormalMap ("Use NormalMap", float)    =    0

if(a+5>method(blah()+4)) { ... }

float4 vertex : POSITION;

half DoSomething (float3 _Direction, Light light){ ... }
```

### 注释（Comments）

- **规则** ：在注释符号后面加一个空格开始你的注释。
- **理由** ：在英文语句中，单词以空格间隔开，注释符号后直接跟进文字，会增加阅读负担。

**GOOD**

```
// This is a comment
// 这是一行注释
/**
 * This is a comment with
 * multiple lines
 */
```

**BAD**

```
//This is a comment
//    这是一行注释
/**
 *   This is a comment with
 *multiple lines
 */
```

## 命名规范（Naming Conventions）

- Shader: 名称遵循大驼峰命名法, 全部以大写开头
- 变量名: 命名遵循小"驼峰"命名法, \*\*\_\*\*符号之后的首字母大写, 否则以小写开头
- Inspector 中的属性名: 单词之间要空格，单词首字母均大写, property 属性默认值后面有大括号的, 在大括号之前要空格, 属性 GUI 标记的首字母大写
- 函数名: 首字母大写
- 自定义宏名: 以\*\*\_\*\*符号开头, 全部大写
- 结构体: 以小写字母开头, 遵循小"驼峰"命名法
- 函数参数: 以小写字母开头, 遵循小"驼峰"命名法

**GOOD**

```
Shader "MyShader/VertexAnimation"{...}
_Color("Color", Color) = (1, 1, 1, 1)
[UserDefined]_NormalMap("Normal Map", 2D) = "bump"{}
floatdiff = 1.0;
half GetDiffuse() {...}
#pragma shader_feature _LIGHTENABLED_ON
structa2v {...};
half Fun(half param1, half param2) {...}
```

**BAD**

```
Shader "myShader/vertexAnimation"{...}
_color("color", Color) = (1, 1, 1, 1)
[userDefined]_NormalMap("NormalMap", 2D) = "bump"{}
floatDiff = 1.0;
half getDiffuse() {...}
#pragma shader_feature lightEnabled_on
structA2V {...};
half Fun(half _param1, half Param2) {...}
```

### 文件名（Filename）

- **规则** ：使用 **CamelCase** 命名，使用 **.** 作为补充文件说明。
- **理由** ：与 Unity ShaderLibrary 库的命名风格一致

**GOOD**

```
LightFunctions.hlsl
Simulation.cginc
```

**BAD**

```
lightFunctions.hlsl
simulation.cginc
```

## 表达式（Statements）

我们要求所有表达式都需要写完整格式，不能写简化版本。

### if 表达式（If Statements）

- **规则** ：书写规则为 if (…) { ，若有 else 表达式，则 else 紧跟在 if 结束后。
- **理由** ：减少行数，减少 Bug 产生概率。

**GOOD**

```
if(i > 0) {
    returnfalse;
}

if(i > 1) {
    returnfalse;
}

if(i > 2) {
    thing1();
} elseif(i < -2) {
    thing2();
} else{
    thing3();
}
```

**BAD**

```
if(i > 0) { returnfalse; }

if(i > 1)
    returnfalse;

if(i > 2) {
    thing1();
}
elseif(i < -2) {
    thing2();
}
else{
    thing3();
}
```

### 循环表达式（Loops）

- **规则** ：书写规则为 for (a…; b…; c…) {，while (…) {，do { … } while ();。
- **理由** ：减少行数。

**GOOD**

```
for(inti = 0; i < 10; ++i) {
    thing1();
}

while(true) {
    thing1();
}
```

**BAD**

```
for(inti = 0; i < 10; ++i) { thing1(); }
for(inti = 0; i < 10; ++i)
{
    thing1();
}

while(true) { thing1(); }
while(true)
{
    thing1();
}
```

## 代码设计（Code Design）

### 注释（Comments）

- 非必要条件下不加注释，只有当代码本身难以通过阅读快速理解时才加入注释
- 在将函数封装到库文件时, 应在库文件中的函数名上方描述该函数的注释
- 注释应该言简意赅。
- 注释不是类型名、方法名或属性名的翻译，注释中应该简单指出方法的功能以及使用者需要注意的事项。
- 必要说明情况如：
	- 接口本身的调用意义难以通过接口名称得知。
		- 参数有边界范围。
		- 返回值有多重意义。
		- ...

### 篇幅（File Length）

- 函数库的封装以效果进行分类，如 Lighting.hlsl, Animation.hlsl 等

### 废弃的代码（Dead Code）

当代码逻辑废弃或者说“暂时不用”，建议从代码文件中删除。冗余的代码会带来阅读障碍和提升维护难度。由于需求的变更和逻辑的重构，曾经暂时留在代码文件中的代码往往变得不可用。如果真的希望找回曾经写过的代码，可以通过 Git 查找历史文件的方式找回，更推荐重新思考和重新编写。

## 代码顺序（Code Order）

- 宏编译指令位于最上方
- include 关键字
- 变量
- 结构体
- 自定义函数
- vertex shader 与 fragment shader
