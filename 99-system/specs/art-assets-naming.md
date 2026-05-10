---
created: 2026-04-20
---
## 准则

制定美术资源命名规范是为了让团队成员贡献的美术资源在项目中能够被有效管理，方便其他工作人员识别和排查资源相关问题。美术资源命名规范主要侧重于：

## 文件夹规范

文件夹使用 **驼峰命名法（CamelCase）** ，目前我们在项目中已知的通用文件夹有：

- **Auto** / **AutoGen** / **Out** ： 存放自动生成，引擎生成，或者由其他工具间接生成的美术资源
- **Models** ：存放外部导入的模型文件（通常为 fbx，obj，blend 等模型格式文件）
- **Characters** ：存放带有骨骼绑定信息的模型文件
- **Materials** ：存放材质球
- **Textures** ：存放贴图文件
- **Scenes** ：存放场景文件
- **Collisions** ：存放碰撞信息文件
- **Prefabs** ：存放预制体
- **Shaders** ：存放 Shader 文件
- **Lights** ：存放光照相关文件
- **Sky** ：存放天空盒文件
- **SFX** ：存放特效文件
- **Vendors** / **3rd**: 存放第三方资源，或者参考资源
- **Temp** ：存放临时资源

## 文件命名规范

文件尽可能以 **snake_case** 命名，如果文件命名特殊，也允许以 **驼峰命名法（CamelCase）** 命名。一般格式如下：

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
- **sta** ：StaticObject，静态生成的 Prefab
- **dyn** ：DynamicObject，动态生成的 Prefab
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
	- **Character** /  **chr**  / **ch** ：角色人物
		- **NPC** ：NPC 人物
		- **Monster** / **mon** ：怪物
		- **Enemy** / **em** ：敌人
		- **Animal** / **aml** ：动物
		- **Biped** ：二足类
		- **Quadruped** ：四足类
		- **Avatar** ：替身角色，通常指可装扮的角色原型
- 角色部位
	- **Head** ：头部
		- **Hair** ：头发
		- **Body** ：身体
		- **Arm** ：手臂
		- **Leg** ：腿部
- 人居环境
	- **City** ：城市
		- **Town** ：小镇
		- **Village** ：村庄
		- **House** ：独栋别墅
		- **Building** ：高楼
- 自然环境
	- **Rock** ：岩石
		- **Forest** ：树林，森林
		- **Cliff** ：悬崖
		- **Vegetation** / **veg** ：植被，通常范指草，树，灌木等的总称
- 形容词
	- **Tiny** ：极小
		- **Small** ：小
		- **Normal** / **Common** ：普通
		- **Large** ：大
		- **Huge** ：巨大
- ...

## 文件夹目录结构划分说明

文件夹目类结构通常分为 1-4 层，各项目需要根据实际资源情况来规划文件夹目录结构，以下为 4 层目录结构说明:

1. 层目录结构通常为 **资源功能** 区分，例如：
    - Animation
    - Materials
    - Models
    - ...
2. 层目录结构通常为 **资源种类** 区分，例如：
    - Animaiton
        - Characters
    - Materials
        - Characters
    - ...
3. 层目录结构通常为 **资源类别细分** 区分，例如：
    - Models
    	- Characters
        	- Actor
        	- Boss
        	- Mod
        	- ...
4. 层目录结构通常为 **资源具体资源命名** 区分，例如：
    - Models
    	- Characters
        	- Actor
            	- dragonX
            - Boss
                - ghostA

再次提示：各项目组可根据自身的项目资源规化情况及项目的成长周期进行调节