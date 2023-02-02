---
--- @author zsh in 2023/1/22 21:59
---

local config_data = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA;

--[[ 女武神可以吃素，但是生存天数超过一定天数后就不能再吃素了 ]]
env.AddPrefabPostInit("wathgrithr", function(inst)
    if not TheWorld.ismastersim then
        return inst;
    end

    inst:AddComponent("mone_wathgrithr_vegetarian");
    inst:DoTaskInTime(0, function(inst)
        local vb = inst.components.mone_wathgrithr_vegetarian;

        vb.mone_survival_time = inst.components.age and inst.components.age:GetDisplayAgeInDays();
        if not vb:IsTooLongToLive() then
            vb:SetDiet({ FOODGROUP.OMNI }, { FOODTYPE.MEAT, FOODTYPE.GOODIES, FOODTYPE.VEGGIE });
        elseif not (config_data.wathgrithr_vegetarian == 2) then
            vb:SetDiet({ FOODGROUP.OMNI }, { FOODTYPE.MEAT, FOODTYPE.GOODIES });
        end

    end);

    inst:WatchWorldState("cycles", function(inst)
        local vb = inst.components.mone_wathgrithr_vegetarian;
        vb.mone_survival_time = inst.components.age and inst.components.age:GetDisplayAgeInDays();
        if not vb:IsTooLongToLive() then
            vb:SetDiet({ FOODGROUP.OMNI }, { FOODTYPE.MEAT, FOODTYPE.GOODIES, FOODTYPE.VEGGIE });
        elseif not (config_data.wathgrithr_vegetarian == 2) then
            if vb.mone_survival_time == vb.SURVIVAL_TIME + 1 then
                inst.components.talker:Say("保护期已过，我已经不能再吃素了！");
            end
            vb:SetDiet({ FOODGROUP.OMNI }, { FOODTYPE.MEAT, FOODTYPE.GOODIES });
        end

    end);
end)