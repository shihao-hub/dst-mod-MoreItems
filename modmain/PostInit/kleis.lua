---
--- @author zsh in 2023/2/3 0:06
---

local config_data = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA;

do
    if config_data.workable_meatrack_hermit_beebox_hermit then
        -- 此处就此over，仅这两个即可。
        local prefabs = {};
        if config_data.meatrack_hermit then
            table.insert(prefabs, "meatrack_hermit");
        end
        if config_data.beebox_hermit then
            table.insert(prefabs, "beebox_hermit");
        end
        for _, v in ipairs(prefabs) do
            env.AddPrefabPostInit(v, function(inst)
                if not TheWorld.ismastersim then
                    return inst;
                end

                local prefabname = inst.prefab;
                inst:AddComponent("lootdropper")
                inst:AddComponent("workable")
                inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
                inst.components.workable:SetWorkLeft(3)
                inst.components.workable:SetOnFinishCallback(prefabname == "meatrack_hermit" and function(inst, worker)
                    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
                        inst.components.burnable:Extinguish()
                    end
                    inst.components.lootdropper:DropLoot()
                    if inst.components.dryer ~= nil then
                        inst.components.dryer:DropItem()
                    end
                    local fx = SpawnPrefab("collapse_small")
                    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                    fx:SetMaterial("wood")
                    inst:Remove()
                end or function(inst, worker)
                    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
                        inst.components.burnable:Extinguish()
                    end
                    inst.SoundEmitter:KillSound("loop")
                    if inst.components.harvestable ~= nil then
                        inst.components.harvestable:Harvest()
                    end
                    inst.components.lootdropper:DropLoot()
                    local fx = SpawnPrefab("collapse_small")
                    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                    fx:SetMaterial("wood")
                    inst:Remove()
                end)
            end)
        end
    end
end