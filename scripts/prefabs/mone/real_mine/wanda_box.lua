---
--- @author zsh in 2023/1/23 4:31
---

local name = "mone_wanda_box";

local assets = {
    Asset("ANIM", "anim/wanda_box.zip"),
    Asset("IMAGE", "images/inventoryimages/mone_wanda_box.tex"),
    Asset("ATLAS", "images/inventoryimages/mone_wanda_box.xml"),
};

local function ondropped(inst)
    if inst.components.container then
        inst.components.container:Close()
    end
end

-- ������Ϸʱ����ִ�иú���
local function onpickupfn(inst, pickupguy, src_pos)
    if inst and inst.prefab and inst.components.container and pickupguy then
        inst.components.container:Open(pickupguy);
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.MiniMapEntity:SetIcon("mone_wanda_box.tex")

    inst.AnimState:SetBank("wanda_box")
    inst.AnimState:SetBuild("wanda_box")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("mone_wanda_box");

    MakeInventoryFloatable(inst);

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        local old_OnEntityReplicated = inst.OnEntityReplicated
        inst.OnEntityReplicated = function(inst)
            if old_OnEntityReplicated then
                old_OnEntityReplicated(inst)
            end
            if inst and inst.replica and inst.replica.container then
                inst.replica.container:WidgetSetup("mone_wanda_box");
            end
        end
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "mone_wanda_box"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/mone_wanda_box.xml"
    inst.components.inventoryitem.canonlygoinpocket = true; -- ����ֻ�ܷ��ڿڴ������
    inst.components.inventoryitem:SetOnDroppedFn(ondropped);
    inst.components.inventoryitem:SetOnPickupFn(onpickupfn); -- �е����ܡ�
    --inst:DoTaskInTime(0.1,function(inst) -- �Ӹ��ӳٰɣ�ȷʵ���ԡ�
    --    if inst.components.container then
    --        inst.components.container:Close();
    --    end
    --end)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("mone_wanda_box");
    inst.components.container.onopenfn = function(inst)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
    end
    inst.components.container.onclosefn = function(inst)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
    end

    MakeHauntableLaunch(inst);
    return inst;
end

return Prefab(name, fn, assets);