---
--- @author zsh in 2023/1/9 2:07
---

--[[ �д���д ]]
-- 1������Բ����ֲ��������
-- 2����������Ȧ��ֲ��
-- 3�������ֲ��
-- 4����Χ��СȦ�����ó�ä����


local TEXT = require("languages.mone.loc");
local API = require("chang_mone.dsts.API");

local containers = require "containers";
local params = containers.params;

params.mone_arborist = {
    widget = {
        slotpos = {},
        animbank = "my_chest_ui_4x4",
        animbuild = "my_chest_ui_4x4",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
        buttoninfo = {
            text = TEXT.TIDY,
            position = Vector3(0, -190, 0),
            fn = function(inst, doer)
                if inst.components.container ~= nil then
                    API.arrangeContainer(inst);
                elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
                    SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
                end
            end,
            --��ť�������
            validfn = function(inst)
                return inst.replica.container ~= nil and not inst.replica.container:IsEmpty()
            end
        }
    },
    type = "chest"
}

local seeds = {
    "pinecone", --�ɹ�
    "acorn", --������
    "twiggy_nut", --��֦�����
    "marblebean" --����ʯ��
}

function params.mone_arborist.itemtestfn(container, item, slot)
    for _, v in ipairs(seeds) do
        if item and item.prefab and item.prefab == v then
            return true
        end
    end
    return false
end

for y = 2, -1, -1 do
    for x = -1, 2 do
        table.insert(params.mone_arborist.widget.slotpos, Vector3(80 * x - 40, 80 * y - 40, 0))
    end
end

-- ������������֤ MAXITEMSLOTS �㹻�󣬶����벻Ҫ�� inst.replica.container:WidgetSetup(nil, widgetsetup); ��д��������̫�࣡
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

local function onhammered(inst, worker)
    if inst.components.lootdropper then
        inst.components.lootdropper:DropLoot()
    end

    if inst.components.container then
        inst.components.container:DropEverything();
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    if x and y and z then
        local fx = SpawnPrefab("collapse_small")
        if fx then
            fx.Transform:SetPosition(x, y, z)
            fx:SetMaterial("wood")
        end
        inst:Remove()
    end
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle")
end

local function onbuilt(inst)
    --inst.AnimState:PlayAnimation("place")
    --inst.AnimState:PushAnimation("idle", false)
    --inst.SoundEmitter:PlaySound("dontstarve/common/chest_craft")

    inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_craft")

    -- ???
    --inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sandcastle")
end

-- TEMP: �д���д
local function MyGetSpawnPoint(startPt, radius)
    local x, y, z = startPt:Get()

    if not (x and y and z and TheWorld and TheWorld.Map and PI) then
        return nil
    end

    --����������겻��½���ϣ��� FindNearbyLand(...) �ҵ�������½������㣬δ�ҵ��Ļ����Ե�ǰ�����Ϊ��ʼ�����
    if not TheWorld.Map:IsAboveGroundAtPoint(x, y, z, false) then
        startPt = FindNearbyLand(startPt) or startPt
    end

    local params = {}

    -- local random_start_angle = math.random() * 2 * PI --����Ƕȡ����þֲ���������������������������Ҫ�����Ҫ��Ȼ�㡣

    -- FindWalkableOffset(...)
    -- This function fans out a search from a starting position/direction and looks for a walkable
    -- position, and returns the valid offset, valid angle and whether the original angle was obstructed.
    -- start_angle is in radians

    -- print("--1")
    --�Դ������ radius Ϊ�뾶�����һ�����νǶ�/attempts�����Ҹ��������򣨻��� ������ PI�� ��һ����
    params[1] = {
        position = startPt,
        start_angle = math.random() * 2 * PI,
        radius = radius,
        attempts = 12, --nil��Ϊ8
        check_los = true
    }
    local offset = FindWalkableOffset(
            params[1].position,
            params[1].start_angle,
            params[1].radius,
            params[1].attempts,
            params[1].check_los
    )
    -- print("--12")
    if offset then
        -- print("--122")
        offset.x = offset.x + startPt.x
        offset.z = offset.z + startPt.z
        return offset
    end

    --print("--2")

    -- TEMP
    if true then
        --���²��ֻ���û��ִ�й��������Ȳ�ִ�С�
        return nil
    end

    -- FindValidPositionByFan(...)
    -- Use this function to fan out a search for a point that meets a condition.
    -- If your condition is basically "walkable ground" use FindWalkableOffset instead.
    -- test_fn takes a parameter "offset" which is check_angle*radius.

    -- print("--11")
    --ͬ�������һ�����νǶȣ�����������ֻ������Ҫ�ж�������IsAboveGroundAtPoint(...)
    local max_search_number = 10 --old_value:10
    for i = 1, max_search_number do
        params[2] = {
            start_angle = math.random() * 2 * PI,
            radius = radius,
            attempts = nil,
            test_fn = function(offset)
                --offset = Vector3(radius * math.cos(check_angle), 0, -radius * math.sin(check_angle))
                local params = {
                    x = startPt.x + offset.x,
                    y = startPt.y + offset.y,
                    z = startPt.z + offset.z,
                    allow_water = false
                }
                return TheWorld.Map:IsAboveGroundAtPoint(params.x, params.y, params.z, allow_water)
            end
        }
        local nextOffset = FindValidPositionByFan(params[2].start_angle, params[2].radius, params[2].attempts, params[2].test_fn)

        if nextOffset then
            nextOffset.x = nextOffset.x + startPt.x
            nextOffset.z = nextOffset.z + startPt.z
            return nextOffset
        end
    end

    -- print("--111")
    --�뾶�Լ���1 �ݼ�ʽ������ʽ ������Χ���ҳ���Ч���ɵ�
    for r = radius, 0, -1 do
        params[3] = {
            position = startPt,
            start_angle = math.random() * 2 * PI,
            radius = r,
            attempts = 12,
            check_los = true,
            ignore_walls = true,
            customcheckfn = nil,
            allow_water = false
        }
        local offset = FindWalkableOffset(
                params[3].position,
                params[3].start_angle,
                params[3].radius,
                params[3].attempts,
                params[3].check_los,
                params[3].ignore_walls,
                params[3].customcheckfn,
                params[3].allow_water
        )
        if offset then
            offset.x = offset.x + startPt.x
            offset.z = offset.z + startPt.z
            return offset
        end
    end

    return nil
end

-- TEMP: �д���д
local function MySpawnPrefab(inst, name, x, y, z)
    local spawnPrefab = SpawnPrefab(name)

    if not (inst and spawnPrefab) then
        return nil
    end

    if not (x and y and z) then
        print("x,y,z == nil")
    end

    local temp_x, temp_y, temp_z = inst.Transform:GetWorldPosition()

    if not (temp_x and temp_y and temp_z) then
        return
    end

    spawnPrefab.Transform:SetPosition(x or temp_x, y or temp_y, z or temp_z)

    return spawnPrefab
end

local PeriodicTime = 1
local max_radius = 15 --�뾶
local find_range = max_radius --һ���ƤΪ 4
local burnable_count = nil --������


local function CheckFire(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    if x and y and z then
        local find_tags = { "green_green_green_CheckFire" }

        local ents = TheSim:FindEntities(x, y, z, find_range, find_tags)

        for _, v in ipairs(ents) do
            if v and v:HasTag("green_green_green_CheckFire") then
                if v.components.burnable then
                    if v.components.burnable:IsSmoldering() then
                        v.components.burnable:SmotherSmolder() --����
                    end
                    if v.components.burnable:IsBurning() then
                        local max_interval = 3

                        if PeriodicTime >= max_interval then
                            v.components.burnable:Extinguish()
                            return
                        end

                        if burnable_count == nil then
                            burnable_count = 1
                        else
                            burnable_count = burnable_count + 1
                        end

                        if burnable_count * PeriodicTime >= max_interval then
                            --math.floor(...)����ȡ��
                            burnable_count = nil
                            v.components.burnable:Extinguish() --���
                        end
                    end
                end
            end
        end
    end
end

local function PlantTrees(inst)
    if not (inst and inst.components.container) then
        return
    end

    -- TEMP
    --������Χ�ڵ����壬���
    --if TUNING.ACB_green_green_green_CheckFire then
    --    CheckFire(inst) --�����ص�
    --end

    local inside_seed = inst.components.container:FindItem(
            function(v)
                for _, seed in ipairs(seeds) do
                    if v.prefab == seed then
                        return true
                    end
                end
                return false
            end
    )

    if not (inside_seed and inside_seed.prefab and inside_seed.components and inside_seed.components.deployable) then
        return
    end

    for radius = 1, max_radius do
        local pt = MyGetSpawnPoint(inst:GetPosition(), radius) --��ȡ�������ɵ㣬�ؼ�����

        if pt == nil then
            return
        else
            local deployable = inside_seed.components.deployable:CanDeploy(pt, nil, inst)

            if deployable then
                local sapling = MySpawnPrefab(inst, inside_seed.prefab .. "_sapling", pt.x, pt.y, pt.z)

                if sapling then
                    sapling:StartGrowing()

                    --������Ч
                    inst.SoundEmitter:PlaySound("dontstarve/common/plant")

                    if inside_seed.components.stackable then
                        inside_seed.components.stackable:Get():Remove()
                    else
                        inside_seed:Remove()
                    end
                end

                break --���ڼ�����Χ���뾶�����ӣ��ҵ���Ч�������ɵ㣬ͬʱ�����ڲ����ӿ��Բ�������ѭ����
            end
        end
    end
end

local assets = {
    --Asset("ANIM", "anim/aip_woodener.zip"),
    Asset("ANIM", "anim/sand_castle.zip"),
    --Asset("IMAGE", "images/inventoryimages/aip_woodener.tex"),
    --Asset("ATLAS", "images/inventoryimages/aip_woodener.xml")
}

local scale = 1.5;
scale = 1;

local function func()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("sand_castle.tex")

    inst:SetPhysicsRadiusOverride(0.3) --? ��Ч��

    inst.Transform:SetScale(scale, scale, scale);

    --inst.entity:AddLight()
    --inst.Light:SetIntensity(0.75)
    --inst.Light:SetRadius(5)
    --inst.Light:SetFalloff(0.85)
    --inst.Light:SetColour(0.65, 0.65, 0.5)

    -- MakeObstaclePhysics(inst, .3)

    --inst.AnimState:SetBank("aip_woodener")
    --inst.AnimState:SetBuild("aip_woodener")
    --inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetBank("sand_castle")
    inst.AnimState:SetBuild("sand_castle")
    inst.AnimState:PlayAnimation("full")

    inst:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        local old_OnEntityReplicated = inst.OnEntityReplicated

        inst.OnEntityReplicated = function(inst)

            if old_OnEntityReplicated then
                old_OnEntityReplicated(inst)
            end
            if inst and inst.replica and inst.replica.container then
                inst.replica.container:WidgetSetup("mone_arborist");
            end
        end
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("mone_arborist");
    inst.components.container.onopenfn = function(inst)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
    end
    inst.components.container.onclosefn = function(inst)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
    end

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(onhammered)
    --inst.components.workable:SetOnWorkCallback(onhit)

    --ֻ������Ҵݻ�
    if inst.components.workable then
        local old_Destroy = inst.components.workable.Destroy
        function inst.components.workable:Destroy(destroyer)
            if destroyer.components.playercontroller == nil then
                return
            end
            return old_Destroy(self, destroyer)
        end
    end

    inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(0)

    -- inst:AddComponent("hauntable")
    -- inst.components.hauntable.cooldown = TUNING.HAUNT_COOLDOWN_HUGE

    inst:ListenForEvent("onbuilt", onbuilt)

    -- !!!
    inst:DoPeriodicTask(PeriodicTime, PlantTrees)

    -- mine
    if TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.arborist_light then
        inst:DoTaskInTime(0.1, function(inst)
            inst._mone_light_fx = inst._mone_light_fx or SpawnPrefab("mone_light_fx");
            -- �޸���Ч��������Χ��ǿ��
            do
                inst._mone_light_fx.Light:SetRadius(15);
                inst._mone_light_fx.Light:SetIntensity(0.4);
            end
            inst._mone_light_fx._mone_arborist = inst;
            inst._mone_light_fx.entity:SetParent(inst.entity);
        end);
    end

    return inst
end

return Prefab("mone_arborist", func, assets), MakePlacer("mone_arborist_placer", "sand_castle", "sand_castle", "full", nil, nil, nil, scale)