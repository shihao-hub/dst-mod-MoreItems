---
--- @author zsh in 2023/1/14 1:05
---

--[[ 本模组的箱子而已 ]]
local chests = {
    "mone_treasurechest", -- 箱子
    "mone_dragonflychest", -- 龙鳞宝箱
};

for _, che in ipairs(chests) do
    env.AddPrefabPostInit(che, function(inst)
        if not TheWorld.ismastersim then
            local old_OnEntityReplicated = inst.OnEntityReplicated
            inst.OnEntityReplicated = function(inst)
                if old_OnEntityReplicated then
                    old_OnEntityReplicated(inst)
                end
                if inst and inst.replica and inst.replica.container then
                    inst.replica.container:WidgetSetup(inst.prefab);
                end
            end
            return inst;
        end

        if inst.components.container then
            inst.components.container:WidgetSetup(inst.prefab);
        end
    end)
end