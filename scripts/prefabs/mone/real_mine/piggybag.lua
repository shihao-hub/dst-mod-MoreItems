---
--- @author zsh in 2023/1/16 20:43
---

local assets = {
    Asset("ANIM", "anim/mone_piggybag.zip"),
    Asset("IMAGE", "images/inventoryimages/mone_piggybag.tex"),
    Asset("ATLAS", "images/inventoryimages/mone_piggybag.xml")
}

local function auto(inst, pickupguy)
    if inst.components.container and pickupguy then
        local numslots = inst.components.container:GetNumSlots();
        local find_backpack = false;
        local find_storage = false;
        --local find_piggyback = false;
        local find_wanda_box = false;
        for i = 1, numslots do
            local item = inst.components.container:GetItemInSlot(i)
            if not find_backpack and item and item.prefab == "mone_backpack" and item.components.container then
                find_backpack = true;
                item.components.container:Open(pickupguy);
            end
            if not find_storage and item and item.prefab == "mone_storage_bag" and item.components.container then
                find_storage = true;
                item.components.container:Open(pickupguy);
            end
            -- 太大了，没必要自动打开。
            --if not find_piggyback and item and item.prefab == "mone_piggyback" and item.components.container then
            --    find_piggyback = true;
            --    item.components.container:Open(pickupguy);
            --end
            -- 只允许放在身上
            --if not find_wanda_box and item and item.prefab == "mone_wanda_box" and item.components.container then
            --    find_wanda_box = true;
            --    item.components.container:Open(pickupguy);
            --end
        end
    end
end

local function onpickupfn(inst, pickupguy, src_pos)
    --重载游戏时，会执行该函数
    if inst.components.container then
        inst.components.container:Open(pickupguy);
        -- 由于重载游戏时，会执行一下此处的函数。所以遍历一下，打开第一个找到的某些指定容器
        auto(inst, pickupguy);
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

    inst.AnimState:SetBank("mone_piggybag")
    inst.AnimState:SetBuild("mone_piggybag")
    inst.AnimState:PlayAnimation("idle")

    inst.MiniMapEntity:SetIcon("mone_piggybag.tex")

    inst:AddTag("nosteal")


    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        local old_OnEntityReplicated = inst.OnEntityReplicated

        inst.OnEntityReplicated = function(inst)
            if old_OnEntityReplicated then
                old_OnEntityReplicated(inst)
            end
            if inst and inst.replica and inst.replica.container then
                inst.replica.container:WidgetSetup("mone_piggybag")
            end
        end

        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "mone_piggybag"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/mone_piggybag.xml"
    inst.components.inventoryitem.canonlygoinpocket = true
    inst.components.inventoryitem:SetOnPickupFn(onpickupfn)
    inst.components.inventoryitem:SetOnDroppedFn(
            function(inst)
                if inst.components.container then
                    inst.components.container:Close()
                end
                -- chang
                if inst.components.container then
                    local old_slots = inst.components.container.slots
                    for _, v in pairs(old_slots) do
                        if v.components.container and v.components.container:IsOpen() then
                            v.components.container:Close()
                        end
                    end
                end
            end
    )

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("mone_piggybag")
    inst.components.container.onopenfn = function(inst,data)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")

        auto(inst, data and data.doer);
    end
    inst.components.container.onclosefn = function(inst,data)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
        -- chang
        if inst.components.container then
            local old_slots = inst.components.container.slots
            for _, v in pairs(old_slots) do
                if v.components.container and v.components.container:IsOpen() then
                    v.components.container:Close()
                end
            end
        end
    end

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("mone_piggybag", fn, assets)
