---
created: 2026-04-20
updated: 2026-05-17
---
## 准则

制定美术资源命名规范是为了让团队成员贡献的美术资源在项目中能够被有效管理，方便其他工作人员识别和排查资源相关问题。美术资源命名规范主要侧重于：

## 文件夹规范

文件夹使用 **snake_case** 命名，目前我们在项目中已知的通用文件夹有：

- **auto** / **auto_gen** / **out** ：存放自动生成，引擎生成，或者由其他工具间接生成的美术资源
- **models** ：存放外部导入的模型文件（通常为 fbx，obj，blend 等模型格式文件）
- **characters** ：存放带有骨骼绑定信息的模型文件
- **materials** ：存放材质球
- **textures** ：存放贴图文件
- **scenes** ：存放场景文件
- **collisions** ：存放碰撞信息文件
- **prefabs** ：存放预制体
- **shaders** ：存放 Shader 文件
- **lights** ：存放光照相关文件
- **sky** ：存放天空盒文件
- **sfx** ：存放特效文件
- **vendors** / **3rd**：存放第三方资源，或者参考资源
- **temp** ：存放临时资源

## 文件命名规范

文件尽可能以 **snake_case** 命名。贴图类文件命名较为特殊，在 snake_case 基础上可以大写后缀字母区分贴图类型（如 `_D`、`_N`、`_S`）。

一般格式如下：

- `类型_物品种类_部件_版本`
- `类型_物品种类_部件@从属关系_版本`
- `类型_物品种类_尺寸_功能项`

样例：

- `chr_player_male_head03_s15`
- `sfx_blade_02@monster001_s16r2`
- `wpn_001_512_D`，`wpn_001_512_N`， `wpn_001_512_S`
- `mtl_building_far@shadername_v1`

常用类型缩写：

- **sfx** ：special effect 缩写（特效）
- **vfx** ：visual effect 缩写（视觉效果）
- **col** ：collision 缩写（碰撞）
- **shd** ：shader 缩写（Shader 代码）
- **mtl** ：material 缩写（材质球）
- **tex** ：texture 缩写（贴图）
- **lgt** ：light 缩写（灯光）
- **lmp** ：light map 缩写（光照贴图）
- **sky** ：sky map 缩写（天空盒，天空球）
- **sk** ：skeleton 缩写（人物骨骼）
- **mdl** ：model 缩写（模型）
- **smdl** ：skinned model 缩写（带有蒙皮信息的模型）
- **chr** ：character 缩写（人物，角色）
- **wpn** ：weapon 缩写（武器）

## Prefab 命名规范

Prefab 根据其在游戏中的使用功能，以前缀形式进行命名： **功能_名字_编号** 。功能前缀参考：

- **sfx** ：特效类 Prefab
- **env** ：场景美术相关的 Prefab
- **chr** / **player** / **npc** / **actor** ：角色控制类 Prefab
- **decal** ：贴花类 Prefab
- **s** ：StaticObject，静态生成的 Prefab
- **d** ：DynamicObject，动态生成的 Prefab
- **gpo** ：GamePlayObject，可交互的，带有交互逻辑的 Prefab
- **brk** ：BreakableObject，可破坏物件
- **col** ：碰撞体文件
- **sky** ：天空盒文件

## 模型文件（Model Prefab）和 Prefab 文件作命名区分

在 Unity3D 中模型文件虽然也是 Prefab，但实际上他的 Prefab 类型是 Model Prefab，是非常特殊的一类 Prefab。而我们通常不推荐开发人员在场景中直接摆放 Model Prefab，而是需要将 Model Prefab 做成 Prefab 后在场景中摆放。所以通过命名区分可以有效的将模型文件和他生成的 Prefab 文件区别开。

我们希望，模型文件带有 **mdl**（普通模型）或者 **smdl**（带有蒙皮信息的模型）前缀。

## 常用命名单词及缩写

常用单词及缩写建议项目组以自身项目为出发点，按照实际情况整理。这里提供一份简单的方案作为参考。

- 角色类
    - **character** / **chr** / **ch** ：角色人物
        - **npc** ：NPC 人物
        - **monster** / **mon** ：怪物
        - **enemy** / **em** ：敌人
        - **animal** / **aml** ：动物
        - **biped** ：二足类
        - **quadruped** ：四足类
        - **avatar** ：替身角色，通常指可装扮的角色原型
- 角色部位
    - **head** ：头部
        - **hair** ：头发
        - **body** ：身体
        - **arm** ：手臂
        - **leg** ：腿部
- 人居环境
    - **city** ：城市
        - **town** ：小镇
        - **village** ：村庄
        - **house** ：独栋别墅
        - **building** ：高楼
- 自然环境
    - **rock** ：岩石
        - **forest** ：树林，森林
        - **cliff** ：悬崖
        - **vegetation** / **veg** ：植被，通常范指草，树，灌木等的总称
- 形容词
    - **tiny** ：极小
        - **small** ：小
        - **normal** / **common** ：普通
        - **large** ：大
        - **huge** ：巨大
- ...

## 美术资产（raw assets）目录结构划分说明

**注意，这里是指 raw assets 美术资产的管理方案**

文件夹目类结构通常分为 1-4 层，各项目需要根据实际资源情况来规划文件夹目录结构，以下为 4 层目录结构说明:

1. 层目录结构通常为 **资源功能** 区分，例如：
    - animation
    - materials
    - models
    - ...
2. 层目录结构通常为 **资源种类** 区分，例如：
    - animation
        - characters
    - materials
        - characters
    - ...
3. 层目录结构通常为 **资源类别细分** 区分，例如：
    - models
        - characters
            - actor
            - boss
            - mod
            - ...
4. 层目录结构通常为 **资源具体资源命名** 区分，例如：
    - models
        - characters
            - actor
                - dragon_x
            - boss
                - ghost_a

再次提示：各项目组可根据自身的项目资源规化情况及项目的成长周期进行调节