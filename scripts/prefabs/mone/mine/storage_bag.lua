---
--- @author zsh in 2023/1/9 2:49
---

local name = "mone_storage_bag";

local config_data = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA;

local containers = require "containers";
local params = containers.params;

local function isIcebox(container, item, slot)
    if item:HasTag("icebox_valid") then
        return true
    end

    --Perishable
    if not (item:HasTag("fresh") or item:HasTag("stale") or item:HasTag("spoiled")) then
        return false
    end

    if item:HasTag("smallcreature") then
        return false
    end

    --Edible
    for k, v in pairs(FOODTYPE) do
        if item:HasTag("edible_" .. v) then
            return true
        end
    end

    return false
end

local function isSaltbox(container, item, slot)
    return ((item:HasTag("fresh") or item:HasTag("stale") or item:HasTag("spoiled"))
            and item:HasTag("cookable")
            and not item:HasTag("deployable")
            and not item:HasTag("smallcreature")
            and item.replica.health == nil)
            or item:HasTag("saltbox_valid")
end

params.mone_storage_bag = {
    widget = {
        slotpos = {
            Vector3(-37.5, 32 + 4, 0),
            Vector3(37.5, 32 + 4, 0),
            Vector3(-37.5, -(32 + 4), 0),
            Vector3(37.5, -(32 + 4), 0)
        },
        animbank = "ui_chest_2x2",
        animbuild = "ui_chest_2x2",
        pos = Vector3(106, 85, 0), --ͷ��λ��
        -- pos = Vector3(156, 85, 0),
        side_align_tip = 160
    },
    type = "hand_inv",
    -- acceptsstacks = false --��չ���ƣ�ֻ�ܷ������ϣ�Ȼ������ֻ�ܴ�һ������������һ�°ɡ������Ƴɵ�һ��ʱ����ʧ��������
    itemtestfn = function(container, item, slot)
        if item.prefab == "heatrock" then
            return false;
        end
        if item.prefab == "cutreeds" or item.prefab == "papyrus" then
            return true;
        end
        return isIcebox(container, item, slot) or isSaltbox(container, item, slot);
    end
}

-- ������������֤ MAXITEMSLOTS �㹻�󣬶����벻Ҫ�� inst.replica.container:WidgetSetup(nil, widgetsetup); ��д��������̫�࣡
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end


--�����Զ��ر�
local function ondropped(inst)
    if inst.components.container then
        inst.components.container:Close()
    end
end

--����ʱ�ж������Ƿ��Ѿ�����
local function onpickupfn(inst, pickupguy, src_pos)
    --������Ϸʱ����ִ�иú���
    if not (inst and inst.prefab and inst.components.container and pickupguy) then
        return
    end

    inst.components.container:Open(pickupguy)

    if true then
        --���´�����ʱ��Ч��
        return
    end
    --��������Ч�����Զ����е�Υ�͸�
    if pickupguy.components.inventory then
        local oneobject = pickupguy.components.inventory:FindItem(
                function(v)
                    if v and v.prefab and v.prefab == inst.prefab then
                        return true
                    end
                    return false
                end
        )
        if oneobject then
            if pickupguy.components.talker then
                pickupguy.components.talker:Say("�ҵ������Ѿ���һ���ˣ���Ҫ̰������Ŷ~")
            end
            local interval = FRAMES or 0
            pickupguy:DoTaskInTime(
                    interval,
                    function()
                        local params = {
                            item = inst,
                            wholestack = true,
                            randomdir = true,
                            pos = nil
                        }
                        pickupguy.components.inventory:DropItem(
                                params.item,
                                params.wholestack,
                                params.randomdir,
                                params.pos
                        )
                    end
            )
        end
    end
end

local assets = {
    --Asset("ANIM", "anim/ndnr_thatchpack.zip"),
    Asset("ANIM", "anim/swap_thatchpack.zip"),
    --Asset("IMAGE", "images/inventoryimages/ndnr_thatchpack.tex"),
    --Asset("ATLAS", "images/inventoryimages/ndnr_thatchpack.xml"),
    --Asset("ATLAS_BUILD", "images/inventoryimages/ndnr_thatchpack.xml", 256)
}
local function func()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("thatchpack.tex")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med")

    --inst.AnimState:SetBank("ndnr_thatchpack")
    --inst.AnimState:SetBuild("ndnr_thatchpack")
    --inst.AnimState:PlayAnimation("anim")
    inst.AnimState:SetBank("thatchpack")
    inst.AnimState:SetBuild("swap_thatchpack")
    inst.AnimState:PlayAnimation("anim")

    --inst:AddTag("fridge")
    -- ֻҪ�����ǩ����Ϳ��Ե������˰ɣ�����ֻ�����䣬�ޱ��ʣ�
    -- �ǵġ�������preserver֮����鶼��ʼ�����ˡ�����ν�ˣ����ô���
    -- ...��perishable��������Update�ֲ�������֪���ˡ�����temperature���
    inst:AddTag("lowcool")

    inst.entity:SetPristine()

    inst.mone_repair_materials = config_data.BALANCE and { papyrus = 0.5, cutreeds = 0.125 } or { papyrus = 1, cutreeds = 0.25 };
    inst:AddTag("mone_can_be_repaired");

    if not TheWorld.ismastersim then
        local old_OnEntityReplicated = inst.OnEntityReplicated

        inst.OnEntityReplicated = function(inst)

            if old_OnEntityReplicated then
                old_OnEntityReplicated(inst)
            end
            if inst.replica.container then
                inst.replica.container:WidgetSetup("mone_storage_bag");
            end
        end
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    --inst.components.inventoryitem.imagename = "ndnr_thatchpack"
    --inst.components.inventoryitem.atlasname = "images/inventoryimages/ndnr_thatchpack.xml"
    inst.components.inventoryitem.imagename = "thatchpack"
    inst.components.inventoryitem.atlasname = "images/DLC0002/inventoryimages.xml"

    inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    inst.components.inventoryitem:SetOnPickupFn(onpickupfn)
    --inst.components.inventoryitem.canonlygoinpocket = true --�Ƿ�ֻ�ܴ�������

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("mone_storage_bag");
    inst.components.container.onopenfn = function(inst)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
    end
    inst.components.container.onclosefn = function(inst)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
    end

    inst.MONE_PRESERVER = 0.5 / 3;
    inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(inst.MONE_PRESERVER);

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(10)
    inst.components.finiteuses:SetUses(10)
    inst.components.finiteuses.onfinished = function(inst)
        if inst.components.container then
            local pt = inst:GetPosition()
            if pt.x and pt.y and pt.z then
                inst.components.container:DropEverything(inst:GetPosition()) --!!!
            end
        end
        -- �����ˣ�̫�鷳
        -- �;�Ϊ 0 ����ʧ��ʧȥ����
        --if config_data.mone_storage_bag_no_remove then
        --    return ;
        --end
        inst:Remove()
    end

    -- �����ˣ�̫�鷳
    --inst:ListenForEvent("percentusedchange", function(inst, data)
    --    local percent = data and data.percent;
    --    if percent then
    --        if percent > 0 then
    --            if inst.components.preserver == nil then
    --                --inst:AddTag("fridge");
    --                inst:AddComponent("preserver");
    --                inst.components.preserver:SetPerishRateMultiplier(inst.MONE_PRESERVER);
    --            end
    --        else
    --            inst:RemoveTag("fridge");
    --            inst:RemoveComponent("preserver");
    --        end
    --    end
    --end);

    local oneday = 30 * 2 * 8;

    local interval = FRAMES or 0;

    inst:DoTaskInTime(interval, function(inst)
        if inst.components.timer and not inst.components.timer:TimerExists("mone_storage_bag_timer") then
            inst.components.timer:StartTimer("mone_storage_bag_timer", oneday / 2)
        end
    end)

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", function(inst, data)
        if data and data.name and data.name == "mone_storage_bag_timer" and inst.components.finiteuses then
            if inst.components.finiteuses:GetUses() > 0 then
                inst.components.timer:StartTimer("mone_storage_bag_timer", oneday / 2)
            end
            inst.components.finiteuses:Use(1)

            -- TEST
            --inst.components.finiteuses:Use(10)
        end
    end)

    --inst:ListenForEvent("itemget", function(inst, data)
    --    if data then
    --        local slot = data.slot;
    --        local item = data.item;
    --        local src_pos = data.src_pos;
    --
    --    end
    --end);

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab(name, func, assets);
