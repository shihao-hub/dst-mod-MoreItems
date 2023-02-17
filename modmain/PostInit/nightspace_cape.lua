---
--- @author zsh in 2023/1/14 1:04
---

local API = require("chang_mone.dsts.API");

--[[ 轻功水上漂 ]]
env.AddPrefabPostInit("mone_nightspace_cape", function(inst)

    if not TheWorld.ismastersim then
        return inst;
    end

    if inst.components.equippable then
        ---@type Equippable
        local equippable = inst.components.equippable;
        local old_onequipfn = equippable.onequipfn;
        equippable.onequipfn = function(inst, owner)
            if old_onequipfn then
                old_onequipfn(inst, owner);
            end
            API.runningOnWater(inst, owner);
        end
        local old_onunequipfn = equippable.onunequipfn;
        equippable.onunequipfn = function(inst, owner)
            if old_onunequipfn then
                old_onunequipfn(inst, owner);
            end
            API.runningOnWaterCancel(inst, owner);
        end
    end
end)