---
--- @author zsh in 2023/1/12 23:33
---


local assets = {
    Asset("ANIM", "anim/halberd.zip"),
    Asset("ANIM", "anim/swap_halberd.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, nil, nil, nil, true, 1, {
        anim = "idle_water"
    })

    inst.AnimState:SetBank("halberd")
    inst.AnimState:SetBuild("halberd")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("tool")
    inst:AddTag("weapon")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(function(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "swap_halberd", "swap_halberd")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    end)
    inst.components.equippable:SetOnUnequip(function(inst, owner)
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")
    end)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(17)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "halberd"
    inst.components.inventoryitem.atlasname = "images/DLC0003/inventoryimages.xml"

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 1 * 2.5)
    inst.components.tool:SetAction(ACTIONS.MINE, 1 * 2.5)
    inst.components.tool:SetAction(ACTIONS.HAMMER)
    --inst.components.tool:SetAction(ACTIONS.DIG, 1)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(108)
    inst.components.finiteuses:SetUses(108)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 0.6 / 3)
    inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 0.6 / 3)
    inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 0.3 / 3)
    --inst.components.finiteuses:SetConsumption(ACTIONS.DIG, 0.6)

    MakeHauntableLaunch(inst)
    return inst;
end

return Prefab("mone_halberd", fn, assets);