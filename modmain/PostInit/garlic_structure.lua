---
--- @author zsh in 2023/1/19 15:27
---


for _, p in ipairs({ "bat", "vampirebat" }) do
    env.AddPrefabPostInit(p, function(inst)
        if not TheWorld.ismastersim then
            return inst;
        end
        inst:DoTaskInTime(0.1, function(inst)
            inst:DoPeriodicTask(3, function(inst)
                local x, y, z = inst.Transform:GetWorldPosition();
                local DIST = 12;
                local MUST_TAGS = { "mone_garlic_structure" }; --���ұ�ǩ
                local CANT_TAGS = nil; --���˱�ǩ
                local ents = TheSim:FindEntities(x, y, z, DIST, MUST_TAGS, CANT_TAGS);
                for _, ent in ipairs(ents) do
                    if ent and inst and inst.components and inst.components.health then
                        local maxhealth = inst.components.health.maxhealth;
                        inst.components.health:DoDelta(-maxhealth);
                        break;
                    end
                end
            end)
        end)
    end)
end