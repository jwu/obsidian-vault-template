---
created: 2026-04-20
updated: 2026-04-20
author: "[[No Name]]"
---
## AI 速查（AI Quick Reference）

以下为 AI Agent 协作 C# 时的硬约束，按权重分为三级：**必须（MUST）** > **应该（SHOULD）** > **可以（MAY）**。冲突时高权重覆盖低权重。

### 格式
- **MUST** 左大括号与语句同行，右大括号另起一行
- **MUST** 4 空格缩进，tab 转空格
- **MUST** 杜绝末端空格、末端空行、多个空行
- **MUST** 数学符号两侧空格，逗号/分号后空格
- **MUST** 注释符号后加空格

### 命名
- **MUST** 文件名/类/函数/属性/委托 `PascalCase`，字段/本地变量/参数 `camelCase`
- **MUST** 布尔变量 `is`/`has`/`can` 前缀
- **MUST** 委托名以 `EventHandler` 或 `Callback` 结尾
- **MUST** 参数与成员变量同名时用 `this.`；与 static 字段同名时参数加 `_` 后缀

### 表达式
- **MUST** if/for/while/switch 写完整格式，不省略大括号
- **MUST** else 紧跟 if 结束大括号

### 代码设计
- **SHOULD** 文件 ≤1000 行，方法 ≤50 行
- **SHOULD** 删除废弃代码，用 Git 回溯
- **SHOULD** 使用 `this.` 访问成员变量

### 排版
- **MUST** using 顺序：.NET → 第三方库 → 项目命名空间
- **MUST** 静态字段在最上方，成员变量和属性集中放置

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

我们的书写风格主要从 K&R 的编码风格派生而来，主旨是为了减少代码行数，降低阅读压力，减少可能产生 Diff 的情况。

### 大括号（Braces）

- **规则** ：所有 **左大括号** 都和表达式在同一行，所有 **右大括号** 都另起一行。
- **理由** ：减少代码函数从而减少代码审核负担。减少无效信息的产生。

**GOOD**

```
class MyClass {
    void DoSomething() {
        if (someTest) {
            // ...
        }
    }
}
```

**BAD**

```
class MyClass
{
    void DoSomething()
    {
        if (someTest)
        {
            // ...
        }
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
void DoSomething() {
∙∙∙∙string name = "foobar";
}
```

**BAD**

```
void DoSomething() {
∙∙string name = "foobar";
}

void DoSomething() {
∙∙tab∙∙∙string name = "foobar";
}
```

### 空格（Spacing）

- **规则** ：杜绝 **末端空格（trailing spaces）** ，杜绝 **末端空行（trailing empty lines）** ，杜绝 **多个空行（multiple empty lines）。**
- **理由** ：这些不良的书写习惯，都会造成当其他人修改时，代码之间的 Diff 出现额外信息，增加审核者的阅读负担。

**GOOD**

```
int foobar = 10;↵
int id = 20;↵
↵
void DoSomething() {↵
    string name = "foobar";↵
}↵
```

**BAD**

```
int foobar = 10;∙∙∙∙∙∙↵
int∙∙∙∙∙id = 20;↵
↵
↵
void DoSomething() {↵
    string name = "foobar";∙∙∙↵
↵
↵
}↵
```

### 间隔（Interval）

- **规则** ：在数学符号两边加入一个空格作为间隔，在参数，for 表达式的间隔符后加入一个空格强化间隔效果。
- **理由** ：减少代码阅读负担。

**GOOD**

```
string name = "foobar";

obj.DoSomething(a, b, c);

if (a + 5 > method(blah() + 4)) { ... }

for (i = 0; i < 10; ++i) { ... }

void DoSomething(int _a, int _b, int _c) { ... }
```

**BAD**

```
string name="foobar";

obj.DoSomething(a,b,c);

if(a+5>method(blah()+4)) { ... }

for(i=0;i<10;++i) { ... }

void DoSomething(int _a,int _b,int _c) { ... }
```

### 注释（Comment）

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

我们使用 **驼峰命名法（Camel-Case）而不是匈牙利命名法（Hungarian notation）** 。匈牙利命名法是在 IDE 不发达的时代的产物，目的是为了区分变量的属性和变量的类型。现代 IDE 可以很快速的定位变量的这两个信息，匈牙利命名法也逐渐被驼峰命名法取代。匈牙利命名法不利于代码 Review，并且书写和命名复杂，当变量的类型调整以后，重构的工作量也比较大，不利于迭代开发。

### 文件名（Filename）

- **规则** ：使用 **CamelCase** 命名，使用 **.** 作为补充文件说明。
- **理由** ：与 Unity3D 的脚本命名规范保持一致。

**GOOD**

```
FooBar.cs
Foobar.cs
FooBar.Actions.cs
```

**BAD**

```
fooBar.cs
foobar.cs
foo-bar.cs
foo_bar.cs
```

### 类（Class）

- **规则** ：使用 **CamelCase** 命名。
- **理由** ：与 Unity3D 的脚本命名规范保持一致。

**GOOD**

```
public class FooBar { ... }
```

**BAD**

```
public class fooBar { ... }
public class foobar { ... }
```

### 函数（Function）

- **规则** ：使用 **CamelCase** 命名。
- **理由** ：与 Unity3D 的脚本命名规范保持一致。

**GOOD**

```
void DoSomething() { ... }
```

**BAD**

```
void doSomething() { ... }
```

### 字段（Field）

- **规则** ：使用 **camelCase** 命名。
- **理由** ：与 Unity3D 的脚本命名规范保持一致。

**GOOD**

```
public class FooBar {
    public int fooBar;
    public int foobar;
    public int foobar;
}
```

**BAD**

```
public class MyClass {
    public int FooBar;
    public int _foobar;
    public int foobar_;
    public int foo_bar;
}
```

### 属性（Property）

- **规则** ：使用 **CamelCase** 命名。
- **理由** ：与.NET 运行时规范保持一致，且在代码审核和解决冲突缺少上下文信息时，能够更清楚开发者是要做属性操作还是关联字段操作。

**GOOD**

```
string name;
string Name {
    get { return name; }
    set { name = value; }
}
```

**BAD**

```
string _name;
string name {
    get { return _name; }
    set { _name = value; }
}
```

### 本地变量（Variable）

- **规则** ：使用 **camelCase** 命名。
- **理由** ：易于辨别。

**GOOD**

```
void DoSomething() {
    float speed = 20.0f;
    bool useWeapon = false;
    ...
}
```

**BAD**

```
void DoSomething() {
    float Speed = 20.0f;
    bool UseWeapon = false;
    ...
}
```

### 参数（Parameter）

- **规则1** ：使用 **camelCase** 命名。
- **规则2** ：当参数命名和成员变量命名一致时，使用 `this` 索引成员变量。
- **规则3** ：当参数命名和 static 成员变量命名一致时，使用 **camelCase\_** 命名（加下划线后缀）。
- **理由** ：与 Unity3D 的脚本命名规范保持一致。

**GOOD**

```
void DoSomething(Vector3 location) { ... }

class MyClass {
    float speed = 0.0f;
    static float speedScale = 1.0f;

    public void SetSpeed(float speed) {
        this.speed = speed
    }

    public static void SetSpeedScale(float speedScale_) {
        speedScale = speedScale_;
    }
}
```

**BAD**

```
void DoSomething(Vector3 Location) { ... }
void DoSomething(Vector3 _location) { ... }
void DoSomething(Vector3 location_) { ... } // 根据规则3斟酌使用
```

### 委托（Delegate）

- **规则** ：使用 **CamelCase** 命名并在名字末端加入 **EventHandler** 或者 **Callback** 。
- **理由** ：让代码审核者更清楚的知道哪些声明是委托。

**GOOD**

```
public delegate void ClickEventHandler();
public delegate void RenderCallback();
```

**BAD**

```
public delegate void Click();
public delegate void Render();
```

### 布尔变量（Boolean Variables）

- **规则** ：使用 **is** ， **has** 或者 **can** 作为前缀命名变量名。
- **理由** ：让变量在使用过程中更容易被其他人理解。

**GOOD**

```
public class MyClass {
    public bool isPerson = true;
    public bool hasAge = true;
    public bool canDance = true;
}
```

**BAD**

```
public class MyClass {
    public bool person = true;
    public bool age = true;
    public bool dance = true;
}
```

## 表达式（Statements）

我们要求所有表达式都需要写完整格式，不能写简化版本。

### if 表达式（If Statements）

- **规则** ：书写规则为 if (…) { ，诺有 else 表达式，则 else 紧跟在 if 结束后。
- **理由** ：减少行数，减少 Bug 产生概率。

**GOOD**

```
if (i > 0) {
    return false;
}

if (i > 1) {
    return false;
}

if (i > 2) {
    thing1();
} else if (i < -2) {
    thing2();
} else {
    thing3();
}
```

**BAD**

```
if (i > 0) { return false; }

if (i > 1)
    return false;

if (i > 2) {
    thing1();
}
else if (i < -2) {
    thing2();
}
else {
    thing3();
}
```

### 循环表达式（Loops）

- **规则** ：书写规则为 for (a…; b…; c…) {，while (…) {，do { … } while ();。
- **理由** ：减少行数。

**GOOD**

```
for (int i = 0; i < 10; ++i) {
    thing1();
}

while (true) {
    thing1();
}
```

**BAD**

```
for (int i = 0; i < 10; ++i) { thing1(); }
for (int i = 0; i < 10; ++i)
{
    thing1();
}

while (true) { thing1(); }
while (true)
{
    thing1();
}
```

### switch 表达式（Switch Statements）

- **规则** ：书写规则为 switch (…) {
- **理由** ：减少行数

**GOOD**

```
switch (variable) {
    case 1: thing1(); break;
    case 2: thing2(); break;
    case 3: thing3(); break;
}

switch (variable) {
    case 1:
        thing1();
        break;
    case 2:
        thing2();
        break;
    case 3:
        thing3();
        break;
}
```

**BAD**

```
switch (variable)
{
    case 1:
    thing1();
    break;

    case 2:
    thing2();
    break;

    case 3:
    thing3();
    break;
}
```

## 代码设计（Code Design）

### 注释（Comments）

- 非必要条件下不加注释，只有当代码本身难以通过阅读快速理解时才加入注释
- 注释应该言简意赅。
- 注释不是类型名、方法名或属性名的翻译，注释中应该简单指出方法的功能以及使用者需要注意的事项。
- 必要说明情况如：
	- 接口本身的调用意义难以通过接口名称得知。
		- 参数有边界范围。
		- 返回值有多重意义。
		- ...

### 篇幅（File Length）

- 类型，单个类（同一个类型文件）代码行数不推荐超过 500 行，如遇需求增加或内容扩展，不应该超过 1000 行。
- 方法，单个方法体代码推荐维持在 50 行以内。
- 例外，篇幅并不是一个强制性要求，如果代码逻辑非常扁平，比如某些工具类或某些完全并行的逻辑，可不遵守上述原则。

### 废弃的代码（Dead Code）

当代码逻辑废弃或者说“暂时不用”，建议从代码文件中删除。冗余的代码会带来阅读障碍和提升维护难度。由于需求的变更和逻辑的重构，曾经暂时留在代码文件中的代码往往变得不可用。如果真的希望找回曾经写过的代码，可以通过 Git 查找历史文件的方式找回，更推荐重新思考和重新编写。

### this 关键字的使用（this Keyword）

推荐编写代码的过程中对成员变量使用 this 关键字。

## 代码顺序（Code Order）

有以下几点注意事项：

- 静态字段的申明放在最上方。
- 成员变量和属性集中放置于类型文件头部，有强逻辑关系或者成对使用的字段和属性中间不空行，其他字段或属性中间空一行。
- 方法代码块和方法方法代码块之间空一行，不能不空行，也不推荐空多行。
- 方法代码块中，同一逻辑块的代码紧密相连，非同一逻辑块中间空一行，本地变量的申明和使用要紧密相连。

参考排版模板：

```csharp
?
```

对于名称空间的引用，排版时尽可能按照.NET 名字空间优先，第三方库其次，最后才是项目中的名字空间的顺序安排：

**GOOD**

```
using System;
using System.Linq;
using System.Collections.Generic;

using MyLib;
using MyLib.Extensions;

using MonoTouch.UIKit;
using MonoTouch.Foundation;

using MyApp;
```

**BAD**

```
using MyLib.Extensions;
using MonoTouch.Foundation;
using System.Collections.Generic;
using System;
using System.Linq;
using MonoTouch.UIKit;
using MyLib;
```
