---
--- @author zsh in 2023/1/24 16:27
---

local function OnPhaseChange(inst, phase)
    if not phase then
        return ;
    end
    if phase == "night" then
        inst.Light:Enable(true);
        return ;
    end
    inst.Light:Enable(false);
end

-- ������Ҫ Network��
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst.entity:AddLight()
    inst.Light:SetIntensity(0.5) -- ���[0.4,0.6]
    --inst.Light:SetColour(200 / 255, 200 / 255, 200 / 255) -- ѩ�ף�
    inst.Light:SetColour(180 / 255, 195 / 255, 150 / 255) -- ���
    inst.Light:SetFalloff(.9)  -- ���
    inst.Light:SetRadius(4) -- ���[3,5]

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false;

    inst:WatchWorldState("phase", OnPhaseChange);

    --inst.OnPhaseChange = OnPhaseChange;

    -- ִ��һ��
    inst:DoTaskInTime(0, function(inst)
        OnPhaseChange(inst, TheWorld.state.phase);
    end);

    return inst;
end

return Prefab("mone_light_fx", fn);