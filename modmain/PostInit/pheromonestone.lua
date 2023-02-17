---
--- @author zsh in 2023/1/12 18:42
---

--[[ 20230122 补充限制：一些物品不允许被无耐久，内容写在 actions.lua  ]]

-- 装备进阶
env.AddPrefabPostInit("mone_pheromonestone", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    if inst.components.mone_pheromonestone == nil then
        inst:AddComponent("mone_pheromonestone"); -- 仅仅只是用于动作添加的组件
    end
end)

for _, com in ipairs({ "fueled", "finiteuses", "armor" }) do
    env.AddComponentPostInit(com, function(self)
        self.inst:AddComponent("mone_pheromonestone_infinite"); -- 用于使装备无耐久的组件
    end)
end

-- 我已经忘了我为什么要这样写了。。。为什么要分开？（想起来了，equippable组件可能再perishable之后添加！）
env.AddComponentPostInit("perishable", function(self)
    self.inst:DoTaskInTime(0, function()
        if self.inst and self.inst.components.equippable then
            self.inst:AddComponent("mone_pheromonestone_infinite"); -- 用于使装备无耐久的组件
        end
    end)
end)

-- 202301181035 想限制一下添加 mone_pheromonestone_infinite 组件的都是 equippable 的，先不改了。