---
created: 2026-04-30
author: "[[No Name]]"
---
## AI 速查（AI Quick Reference）

以下为 AI Agent 协作 GDScript 时的硬约束，按权重分为三级：**必须（MUST）** > **应该（SHOULD）** > **可以（MAY）**。冲突时高权重覆盖低权重。

### 强制静态类型
- **MUST** 所有变量声明带类型：`var health: int = 0`
- **MUST** 函数参数和返回值带类型：`func heal(amount: int) -> void:`
- **MUST** 类型明确时用 `:=` 推断：`var v := Vector3(1, 2, 3)`
- **MUST** `get_node()` 标注类型或用 `as`：`@onready var bar: ProgressBar = get_node(...)`

### 格式
- **MUST** 4 空格缩进，LF 换行，UTF-8
- **MUST** 续行 2 级缩进；数组/字典/枚举续行 1 级
- **MUST** 多行列表最后一项加尾逗号
- **SHOULD** 行宽 ≤100，尽量 ≤80
- **MUST** 每行一条语句（三元运算符除外）
- **MUST** 用 `and`/`or`/`not`，不用 `&&`/`||`/`!`
- **MUST** 运算符两侧空格，逗号后空格
- **SHOULD** 默认双引号，减少转义时用单引号
- **MUST** 浮点数不省前导零和末尾零，十六进制小写

### 命名
- **MUST** 文件/函数/变量 `snake_case`，类/节点 `PascalCase`，常量 `CONSTANT_CASE`
- **MUST** 信号 `snake_case` 过去式：`signal door_opened`
- **MUST** 私有成员 `_` 前缀
- **MUST** 枚举名 `PascalCase`，成员 `CONSTANT_CASE`，每成员一行

### 代码顺序
- **MUST** 代码顺序：信号 → 枚举 → 常量 → 导出变量 → 普通变量 → @onready → 方法
- **MUST** public 在前，private 在后

### 代码设计
- **SHOULD** 文件 ≤800 行，方法 ≤40 行（纯数据声明例外）
- **SHOULD** 删除废弃代码，用 Git 回溯
- **MUST** setter 中同名属性用 `self.`
- **MUST** 局部变量就近声明

> 以下为完整规范，速查区与详细规则冲突时以详细规则为准。

## 准则

本规范参考 Godot 官方 [GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)，并结合项目实际需求整理。

> [!important] 全局要求：所有 GDScript 代码必须使用静态类型。详见 [[#强制静态类型（Static typing）|强制静态类型]] 章节。

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

- 强制静态类型（Static Typing）
- 书写风格（Formatting）
- 命名规范（Naming Conventions）
- 表达式（Statements）
- 代码设计（Code Design）
- 代码顺序（Code Order）
- 参考样例（Example）

## 强制静态类型（Static Typing）

所有代码都应该使用静态类型。

### 声明类型（Declared Types）

- **规则**：声明变量类型使用 `var name: Type = value`。
- **规则**：声明函数返回类型使用 `-> Type`。

```gdscript
var health: int = 0
func heal(amount: int) -> void:
```

### 类型推断（Inferred Types）

- **规则**：当赋值语句右侧的类型已明确时，使用 `:=` 让编译器推断类型。
- **规则**：类型不明确时，必须显式写出类型。
- **规则**：`get_node()` 等无法推断具体类型时，必须显式标注或使用 `as` 转换。
- **理由**：减少冗余信息，同时避免类型歧义导致的 bug。

**GOOD**

```gdscript
# 类型不明确，显式标注
var health: int = 0

# 类型已明确，使用推断
var direction := Vector3(1, 2, 3)

# get_node 显式标注类型
@onready var health_bar: ProgressBar = get_node("UI/LifeBar")

# 或使用 as 转换
@onready var health_bar := get_node("UI/LifeBar") as ProgressBar
```

**BAD**

```gdscript
# 类型可能是 int 或 float，不明确
var health := 0

# 类型已明确，冗余
var direction: Vector3 = Vector3(1, 2, 3)

# get_node 无法推断具体类型
@onready var health_bar := get_node("UI/LifeBar")
```

> **注意**：`as` 关键字比显式类型标注更 **type-safe**（类型安全），但不如类型标注 **null-safe**（空安全）。当运行时类型不匹配时，`as` 会静默将变量转为 `null`，不产生错误或警告，可能导致难以排查的空指针问题。推荐在能确定节点类型且需要严格空安全时优先使用显式类型标注。

## 书写风格（Formatting）

### 编码与特殊字符（Encoding and Special Characters）

- **规则**：使用 **LF** 换行，不使用 CRLF 或 CR。
- **规则**：文件末尾保留一个换行符。
- **规则**：使用 **UTF-8** 编码，不带 BOM。
- **规则**：使用 **4 空格（4 spaces）** 缩进，**tab** 键强制转成 **4 空格** 间隔。

### 缩进（Indentation）

- **规则**：每个缩进层级比包含它的代码块多一级。
- **规则**：续行（continuation line）使用 **2 级缩进**，以区别于普通代码块。
- **例外**：数组、字典、枚举的续行使用 **1 级缩进**。
- **理由**：续行双缩进能清晰区分语句边界，减少阅读歧义。

**GOOD**

```gdscript
for i in range(10):
    print("hello")

effect.interpolate_property(sprite, "transform/scale",
        sprite.get_scale(), Vector2(2.0, 2.0), 0.3,
        Tween.TRANS_QUAD, Tween.EASE_OUT)

var party = [
    "Godot",
    "Godette",
    "Steve",
]
```

**BAD**

```gdscript
for i in range(10):
  print("hello")

effect.interpolate_property(sprite, "transform/scale",
    sprite.get_scale(), Vector2(2.0, 2.0), 0.3,
    Tween.TRANS_QUAD, Tween.EASE_OUT)

var party = [
        "Godot",
        "Godette",
        "Steve",
]

var character_dict = {
        "Name": "Bob",
        "Age": 27,
        "Job": "Mechanic",
}

enum Tile {
        BRICK,
        FLOOR,
        SPIKE,
        TELEPORT,
}
```

### 尾逗号（Trailing Comma）

- **规则**：多行数组、字典、枚举的最后一项加尾逗号。
- **规则**：单行列表不加尾逗号。
- **理由**：添加新元素时不会改动最后一行，减少 Diff 噪音。

**GOOD**

```gdscript
var array = [
    1,
    2,
    3,
]
var single = [1, 2, 3]
```

**BAD**

```gdscript
var array = [
    1,
    2,
    3
]
var single = [1, 2, 3,]
```

### 空行（Blank Lines）

- **规则**：函数与类定义之间使用 **2 个空行** 分隔。
- **规则**：函数内部用 **1 个空行** 分隔逻辑区块。
- **理由**：清晰区分函数边界与逻辑段落。

**GOOD**

```gdscript
func heal(amount):
    health += amount
    health = min(health, max_health)
    health_changed.emit(health)


func take_damage(amount, effect = null):
    health -= amount
    health = max(0, health)
    health_changed.emit(health)
```

> **注意**：在类参考文档和短代码片段中，类与函数定义之间使用单行间距。本文档中的代码示例也遵从此惯例。

### 行宽（Line Length）

- **规则**：单行代码不超过 **100 字符**。
- **建议**：尽量控制在 **80 字符** 以内，便于小屏显示和分屏对比。

### 每行一条语句（One Statement Per Line）

- **规则**：每行只写一条语句，包括条件语句。
- **例外**：三元运算符可以写在一行。
- **理由**：提升可读性，避免遗漏逻辑。

**GOOD**

```gdscript
if position.x > width:
    position.x = 0

if flag:
    print("flagged")

next_state = "idle" if is_on_floor() else "fall"
```

**BAD**

```gdscript
if position.x > width: position.x = 0
if flag: print("flagged")
```

### 多行语句格式化（Format Multiline Statements For Readability）

- **规则**：长条件或多层三元表达式应换行，续行使用 **2 级缩进**。
- **规则**：换行时 `and` / `or` 放在续行开头，而非前一行末尾。
- **规则**：优先使用 **括号** 包裹多行表达式，避免使用反斜杠。
- **理由**：括号方式重构更安全，反斜杠容易出现末尾残留错误。

**GOOD**

```gdscript
var quadrant = (
        "northeast" if angle_degrees <= 90
        else "southeast" if angle_degrees <= 180
        else "southwest" if angle_degrees <= 270
        else "northwest"
)

if (
        position.x > 200 and position.x < 400
        and position.y > 300 and position.y < 400
):
    pass
```

**BAD**

```gdscript
var quadrant = "northeast" if angle_degrees <= 90 else "southeast" if angle_degrees <= 180 else "southwest" if angle_degrees <= 270 else "northwest"

if position.x > 200 and position.x < 400 and position.y > 300 and position.y < 400:
    pass
```

### 避免不必要的括号（Avoid Unnecessary Parentheses）

- **规则**：条件表达式中的括号在非必要时省略。
- **例外**：多行条件或需要明确运算优先级时保留括号。
- **理由**：减少视觉噪音。

**GOOD**

```gdscript
if is_colliding():
    queue_free()
```

**BAD**

```gdscript
if (is_colliding()):
    queue_free()
```

### 布尔运算符（Boolean Operators）

- **规则**：使用英文关键词 `and`、`or`、`not`，不使用 `&&`、`||`、`!`。
- **建议**：可在布尔运算符周围使用括号清除歧义，使长表达式更易阅读。
- **理由**：英文关键词更具可读性，与 Python 风格一致。

**GOOD**

```gdscript
if (foo and bar) or not baz:
    print("condition is true")
```

**BAD**

```gdscript
if foo && bar || !baz:
    print("condition is true")
```


### 注释间距（Comment Spacing）

- **规则**：普通注释（`#`）和文档注释（`##`）后加一个空格。
- **规则**：被注释掉的代码不加空格，`#region` / `#endregion` 不加空格。
- **规则**：注释优先写在独立行，行内注释仅用于极短说明。
- **理由**：区分文本注释与被禁用的代码。

**GOOD**

```gdscript
# This is a comment.
#print("This is disabled code")
# Short comment.
print("Example") # Short comment.
```

**BAD**

```gdscript
#This is a comment.
# print("This is disabled code")
print("Example") # This is a long comment that makes the line too long.
```

### 空格（Whitespace）

- **规则**：运算符两边各加一个空格，逗号后加一个空格。
- **规则**：字典引用和函数调用的括号内侧不加空格。
- **例外**：单行字典声明时，花括号内侧各加一个空格。
- **规则**：不使用空格做垂直对齐。
- **理由**：保持一致的视觉节奏，单行字典加空格便于与数组区分。

**GOOD**

```gdscript
position.x = 5
position.y = target_position.y + 10
dict["key"] = 5
my_array = [4, 5, 6]
my_dictionary = { key = "value" }
print("foo")
```

**BAD**

```gdscript
position.x=5
position.y = mpos.y+10
dict ["key"] = 5
myarray = [4,5,6]
my_dictionary = {key = "value"}
print ("foo")

x        = 100
y        = 100
velocity = 500
```

### 引号（Quotes）

- **规则**：默认使用双引号。
- **规则**：当单引号能减少转义字符数量时，使用单引号。
- **规则**：转义数量相同时，优先双引号。
- **理由**：以双引号为主流风格减少争议，同时允许务实例外。

**GOOD**

```gdscript
# 普通字符串
print("hello world")

# 双引号避免转义
print("hello 'world'")

# 单引号避免转义
print('hello "world"')

# 转义数量相同，优先双引号
print("'hello' \"world\"")
```

### 数字（Numbers）

- **规则**：浮点数不省略前导零和末尾零。
- **规则**：十六进制数字使用小写字母。
- **规则**：大数字使用下划线分隔，但小于 1,000,000 的数字一般不加分隔。
- **理由**：提高可读性，浮点数与整数一眼可辨。

**GOOD**

```gdscript
var float_number = 0.234
var other_float_number = 13.0
var hex_number = 0xfb8c0b
var large_number = 1_234_567_890
var large_hex_number = 0xffff_f8f8_0000
var large_bin_number = 0b1101_0010_1010
var small_number = 12345
```

**BAD**

```gdscript
var float_number = .234
var other_float_number = 13.
var hex_number = 0xFB8C0B
var large_number = 1234567890
var large_hex_number = 0xfffff8f80000
var large_bin_number = 0b110100101010
var small_number = 12_345
```

## 命名规范（Naming Conventions）

| 类型 | 规范 | 示例 |
| --- | --- | --- |
| 文件名 | snake_case | `yaml_parser.gd` |
| 类名 | PascalCase | `class_name YAMLParser` |
| 节点名 | PascalCase | `Camera3D`, `Player` |
| 函数 | snake_case | `func load_level():` |
| 变量 | snake_case | `var particle_effect` |
| 信号 | snake_case（过去式） | `signal door_opened` |
| 常量 | CONSTANT_CASE | `const MAX_SPEED = 200` |
| 枚举名 | PascalCase | `enum Element` |
| 枚举成员 | CONSTANT_CASE | `{EARTH, WATER, AIR, FIRE}` |

### 文件名（File Names）

- **规则**：使用 **snake_case** 命名。若有 `class_name`，将 PascalCase 类名转换为 snake_case。
- **理由**：与 Godot C++ 源码命名一致，避免跨平台大小写敏感问题。

**GOOD**

```gdscript
# 保存为 weapon.gd
class_name Weapon
extends Node

# 保存为 yaml_parser.gd
class_name YAMLParser
extends Object
```

### 类与节点（Classes and Nodes）

- **规则**：类名与节点名使用 **PascalCase**。
- **规则**：将类加载为常量或变量时，同样使用 PascalCase。
- **理由**：与 Godot 内置类型风格一致。

**GOOD**

```gdscript
extends CharacterBody3D
const Weapon = preload("res://weapon.gd")
```

### 函数与变量（Functions and Variables）

- **规则**：使用 **snake_case** 命名。
- **规则**：虚方法、私有函数、私有变量前加单下划线 `_` 前缀。
- **理由**：与 Godot 内置 API 风格一致，下划线前缀标识"内部使用"。

**GOOD**

```gdscript
var particle_effect
var _counter = 0

func load_level():
func _recalculate_path():
```

**BAD**

```gdscript
var ParticleEffect
func LoadLevel():
```

### 信号（Signals）

- **规则**：使用 **snake_case** 命名，使用 **过去式** 表达事件已发生。
- **理由**：过去式语义清晰，表明信号是某件事"已经发生"的通知。

**GOOD**

```gdscript
signal door_opened
signal score_changed
```

**BAD**

```gdscript
signal door_open
signal score_change
```

### 常量与枚举（Constants and Enums）

- **规则**：常量使用 **CONSTANT_CASE**（全大写+下划线）。
- **规则**：枚举名使用 **PascalCase**（单数形式），枚举成员使用 **CONSTANT_CASE**。
- **规则**：每个枚举成员独占一行。
- **理由**：枚举名是类型故用 PascalCase，成员是常量故用 CONSTANT_CASE；每行一个成员便于添加注释和 Diff。

**GOOD**

```gdscript
const MAX_SPEED = 200

enum Element {
    EARTH,
    WATER,
    AIR,
    FIRE,
}
```

**BAD**

```gdscript
const maxSpeed = 200
enum Element { EARTH, WATER, AIR, FIRE }
```

## 表达式（Statements）

### if 表达式（If Statements）

- **规则**：书写格式 `if condition:`，语句体缩进一级。
- **规则**：`elif` 和 `else` 与 `if` 对齐。
- **理由**：保持简洁，与 Python 风格一致。

**GOOD**

```gdscript
if i > 0:
    return false

if i > 1:
    return false
elif i < -1:
    thing()
else:
    other_thing()
```

**BAD**

```gdscript
if i > 0: return false

if i > 1:
return false
```

### 循环表达式（Loops）

- **规则**：`for` 和 `while` 书写格式与 `if` 一致，语句体缩进一级。

**GOOD**

```gdscript
for i in range(10):
    thing()

while true:
    thing()
```

**BAD**

```gdscript
for i in range(10): thing()

while true:
thing()
```

### match 表达式（Match Statements）

- **规则**：`match` 书写格式为 `match variable:`，每个分支缩进一级。
- **规则**：短分支可写在一行，多行分支保持缩进一致。
- **理由**：与 Godot 风格一致，灵活处理简单与复杂情况。

**GOOD**

```gdscript
match variable:
    1:
        thing1()
    2:
        thing2()
    _:
        default_thing()

match variable:
    1: thing1()
    2: thing2()
    _: default_thing()
```

**BAD**

```gdscript
match variable:
case 1:
thing1()
case 2:
thing2()
```

## 代码设计（Code Design）

### 注释（Comments）

- 非必要条件下不加注释，只有当代码本身难以通过阅读快速理解时才加入注释。
- 注释应该言简意赅。
- 注释不是类型名、方法名或属性名的翻译，注释中应该简单指出方法的功能以及使用者需要注意的事项。
- GDScript 文档注释使用 `##`，可用于为类、函数、变量生成编辑器内文档提示。

### 标签（Tags）

有时候需要对某个区块的代码进行特殊标签注释，例如：TODO、HACK 等。统一格式：

```gdscript
# TAG-NAME {
var foo = 3
var bar = 4
# } TAG-NAME
```

推荐的 tag：

- DEBUG
- DISABLE
- HACK
- TODO
- FIXME

### 篇幅（File Length）

- 单个 GDScript 文件代码行数不推荐超过 **400 行**，如遇需求增加或内容扩展，不应超过 **800 行**。
- 单个方法体代码推荐维持在 **40 行** 以内。
- 例外：篇幅并不是强制性要求，如果代码逻辑非常扁平（如纯数据声明、枚举定义），可不遵守上述原则。

### 废弃的代码（Dead Code）

当代码逻辑废弃或"暂时不用"，建议从代码文件中删除。冗余的代码会带来阅读障碍和提升维护难度。如需找回历史代码，可通过 Git 历史查找，更推荐重新思考和重新编写。

### self 关键字的使用（Self Keyword）

- GDScript 中访问成员变量和方法默认不需要 `self`，但以下情况必须使用：
    - 在 setter 中给同名属性赋值（如 `self._state = target_state`）。
    - 需要通过 `self` 明确区分局部变量与成员变量时。
- 推荐在能提升可读性时使用 `self`，不必强制统一。

## 代码顺序（Code Order）

整体按以下顺序组织 GDScript 代码：

```gdscript
1. @tool、@icon、@static_unload
2. class_name
3. extends
4. ## 文档注释

5. signal 信号声明
6. enum 枚举声明
7. const 常量声明
8. static 静态变量
9. @export 变量
10. 其余普通变量
11. @onready 变量

12. _static_init()
13. 其余静态方法
14. 重写的内置虚方法（按生命周期排序）：
    1. _init()
    2. _enter_tree()
    3. _ready()
    4. _process()
    5. _physics_process()
    6. 其余虚方法
15. 重写的自定义方法
16. 其余方法
17. 内部类
```

依访问修饰符排序：

```
1. public
2. private
```

### 信号与属性（Signals and Properties）

信号声明在前，随后是属性（成员变量）。枚举应放在信号之后（枚举成员可作为属性的 export hint）。之后依次是：常量、导出变量、公有变量、私有变量、`@onready` 变量。

**示例**：

```gdscript
signal player_spawned(position)

enum Job {
    KNIGHT,
    WIZARD,
    ROGUE,
    HEALER,
    SHAMAN,
}

const MAX_LIVES = 3

@export var job: Job = Job.KNIGHT
@export var max_health = 50
@export var attack = 5

var health = max_health:
    set(new_health):
        health = new_health

var _speed = 300.0

@onready var sword = get_node("Sword")
@onready var gun = get_node("Gun")
```

> **注意**：GDScript 在 `_ready` 回调之前计算 `@onready` 变量，可用于缓存节点依赖。

### 成员变量（Member Variables）

- **规则**：仅在某个方法内部使用的变量，不应声明为成员变量，应在方法体内声明为局部变量。
- **理由**：减少类的状态复杂度，避免不必要的作用域暴露，降低外部对内部实现细节的依赖。

### 局部变量就近声明（Local Variables）

- **规则**：局部变量应尽可能靠近其首次使用的位置进行声明。
- **理由**：减少阅读时的纵向跳跃，提升代码跟随性。

### 方法与静态函数（Methods and Static Functions）

属性之后是方法。构造与初始化函数（`_init`、`_ready`）最先出现，展示对象如何初始化。其后是其他内置虚方法回调（如 `_unhandled_input`、`_physics_process`），控制对象的主循环和引擎交互。最后是自定义公有方法和私有方法，依公有在前的顺序排列。

### 排列理由（Rationale）

遵守四条经验法则：

1. 属性与信号在前，方法在后。
2. 公有在前，私有在后。
3. 虚方法回调在类的自定义接口之前。
4. 构造与初始化函数 `_init`、`_ready` 在运行时修改对象的方法之前。

### 类声明细节（Class Declaration）

- **规则**：类声明按 `@tool` → `@icon` → `@abstract`（若需）→ `class_name` → `extends` → 文档注释的顺序依次书写。
- **规则**：抽象类使用 `@abstract` 注解，放在 `class_name` 之前。
- **规则**：内部类可使用单行声明以节省篇幅：

```gdscript
## 文档注释
@abstract class MyNode extends Node:
    pass
```

- **理由**：统一的声明顺序使类的元信息一目了然，便于快速判断类的用途和继承关系。

## 参考样例（Example）

```gdscript
@tool
class_name StateMachine
extends Node
## Hierarchical State machine for the player.
##
## Initializes states and delegates engine callbacks.

signal state_changed(previous, new)

@export var initial_state: Node
var is_active = true:
    set = set_is_active

@onready var _state = initial_state:
    set = set_state
@onready var _state_name = _state.name


func _init():
    add_to_group("state_machine")


func _enter_tree():
	print("this happens before the ready method!")


func _ready():
    state_changed.connect(_on_state_changed)
    _state.enter()


func _unhandled_input(event):
    _state.unhandled_input(event)


func _physics_process(delta):
    _state.physics_process(delta)


func transition_to(target_state_path, msg = {}):
    if not has_node(target_state_path):
        return

    var target_state = get_node(target_state_path)
    assert(target_state.is_composite == false)

    _state.exit()
    self._state = target_state
    _state.enter(msg)
    Events.player_state_changed.emit(_state.name)


func set_is_active(value):
    is_active = value
    set_physics_process(value)
    set_process_unhandled_input(value)
    set_block_signals(not value)


func set_state(value):
    _state = value
    _state_name = _state.name


func _on_state_changed(previous, new):
    print("state changed")
    state_changed.emit()


class State:
    var foo = 0

    func _init():
        print("Hello!")
```

