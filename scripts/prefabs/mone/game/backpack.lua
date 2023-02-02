---
--- @author zsh in 2023/1/8 17:08
---


local TEXT = require("languages.mone.loc");
local API = require("chang_mone.dsts.API");

local name = "mone_backpack";

local assets = {
    Asset("ANIM", "anim/backpack.zip"),
    Asset("ANIM", "anim/swap_backpack.zip"),
    Asset("ANIM", "anim/ui_backpack_2x4.zip"),
}

local prefabs = {
    "ash",
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("backpack", "swap_backpack", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_backpack", "swap_body")

    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end
end

local function ondropped(inst)
    if inst.components.container then
        inst.components.container:Close()
    end
end

local function onpickupfn(inst, pickupguy, src_pos)
    --������Ϸʱ����ִ�иú���
    if not (inst and inst.prefab and inst.components.container and pickupguy) then
        return
    end
    inst.components.container:Open(pickupguy)
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
    if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end
end

local function onburnt(inst)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end

    SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())

    inst:Remove()
end

local function onignite(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = false
    end
end

local function onextinguish(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = true
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("backpack.png")

    inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_backpack")
    inst.AnimState:PlayAnimation("anim")

    inst.foleysound = "dontstarve/movement/foley/backpack"

    local swap_data = { bank = "backpack1", anim = "anim" }
    MakeInventoryFloatable(inst, "small", 0.2, nil, nil, nil, swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        local old_OnEntityReplicated = inst.OnEntityReplicated

        inst.OnEntityReplicated = function(inst)

            if old_OnEntityReplicated then
                old_OnEntityReplicated(inst)
            end
            if inst and inst.replica and inst.replica.container then
                inst.replica.container:WidgetSetup("mone_backpack");
            end
        end
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.canonlygoinpocket = true;
    inst.components.inventoryitem:ChangeImageName("backpack");
    inst.components.inventoryitem:SetOnDroppedFn(ondropped);
    inst.components.inventoryitem:SetOnPickupFn(onpickupfn);

    --inst:AddComponent("equippable")
    --inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    --inst.components.equippable:SetOnEquip(onequip)
    --inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("mone_backpack");
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    inst.components.burnable:SetOnBurntFn(onburnt)
    inst.components.burnable:SetOnIgniteFn(onignite)
    inst.components.burnable:SetOnExtinguishFn(onextinguish)

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab(name, fn, assets, prefabs)
