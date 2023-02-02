---
--- @author zsh in 2023/1/9 1:45
---


-- �д��Ż�

do
    return nil;
end

local assets = {}

local function fn1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med")

    inst.AnimState:SetBank("bundle")
    inst.AnimState:SetBuild("bundle")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("acb_pack_everything")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    --���䣬�ÿ����������ʾ
    inst.components.inventoryitem.imagename = "bundlewrap"
    inst.components.inventoryitem.atlasname = "images/inventoryimages.xml"

    inst:AddComponent("acb_pack_for_action")

    return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med")

    inst.AnimState:SetBank("bundle")
    inst.AnimState:SetBuild("bundle")
    inst.AnimState:PlayAnimation("idle_large")

    inst:AddTag("acb_pack_everything_full")

    --���屦���������ǩ
    -- inst:AddTag("irreplaceable")
    -- inst:AddTag("nonpotatable")

    --�����жϱ�ǩ
    inst:AddTag("bundle")
    inst:AddTag("nobundling")

    --�����жϱ�ǩ
    inst:AddTag("nonpackable")

    --���ͻ�����
    inst._name = net_string(inst.GUID, "acb_pack_everything_full._name")
    inst.displaynamefn = function(inst)
        if #inst._name:value() > 0 then
            return "������� " .. inst._name:value()
        else
            return "δ֪�����"
        end
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    --����� inst.UpdateInventoryImage = UpdateInventoryImage �漰
    inst.components.inventoryitem:ChangeImageName("bundle_large")

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = function(inst, pt, deployer)
        if inst.components.acb_pack_everything then
            inst.components.acb_pack_everything:Release(pt) --�ͷ�

            inst:Remove()

            if deployer and deployer.components.inventory then
                --�ͷź󣬽������������
                local acb_pack_everything = SpawnPrefab("acb_pack_everything")
                if acb_pack_everything then
                    deployer.components.inventory:GiveItem(acb_pack_everything)
                end
            end
        end
    end
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.NONE)

    inst:AddComponent("acb_pack_everything")

    return inst
end

return Prefab("acb_pack_everything", fn1, assets), Prefab("acb_pack_everything_full", fn2, assets), MakePlacer(
        "acb_pack_everything_full_placer",
        "bundle",
        "bundle",
        "idle_large"
)
