---
--- @author zsh in 2023/2/13 9:24
---

--[[ 有待重写 ]]
-- 1、绝对圆形种植？！！！
-- 2、分类内外圈种植？
-- 3、多层种植？
-- 4、周围较小圈内设置成盲区！

-- 2023-02-13-09:27：计划重写


local assets = {
    Asset("ANIM", "anim/sand_castle.zip"),
}

local API = require("chang_mone.dsts.API");
local TEXT = require("languages.mone.loc");

local containers = require "containers";
local params = containers.params;

local SEEDS = {
    "pinecone", --松果
    "acorn", --桦栗果
    "twiggy_nut", --多枝树球果
    "marblebean" --大理石豆
}

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
            validfn = function(inst)
                return inst.replica.container ~= nil and not inst.replica.container:IsEmpty()
            end
        }
    },
    type = "chest",
    itemtestfn = function(container, item, slot)
        for _, v in ipairs(SEEDS) do
            if item.prefab == v then
                return true;
            end
        end
        return false;
    end
}

for y = 2, -1, -1 do
    for x = -1, 2 do
        table.insert(params.mone_arborist.widget.slotpos, Vector3(80 * x - 40, 80 * y - 40, 0))
    end
end

for _, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

local fns = {};

function fns.onopenfn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
end

function fns.onclosefn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close");
end

function fns.onhammered(inst, worker)
    if inst.components.lootdropper then
        inst.components.lootdropper:DropLoot()
    end

    if inst.components.container then
        inst.components.container:DropEverything();
    end

    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function isLegalSeeds(inst)
    for _, v in ipairs(SEEDS) do

    end
end

local function getSpawnSeedsPosition()

end

-- 种树！
local function plantTrees(inst)
    local container = inst.components.container;
    if not container then
        return ;
    end
    local DIST = 15;


end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("sand_castle.tex")

    inst:SetPhysicsRadiusOverride(0.3)
    MakeObstaclePhysics(inst, inst.physicsradiusoverride)

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
    inst.components.container.onopenfn = fns.onopenfn;
    inst.components.container.onclosefn = fns.onclosefn;

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(fns.onhammered)

    --只允许被玩家摧毁
    if inst.components.workable then
        local old_Destroy = inst.components.workable.Destroy
        function inst.components.workable:Destroy(destroyer)
            if destroyer.components.playercontroller == nil then
                -- DoNothing
            else
                if old_Destroy then
                    old_Destroy(self, destroyer);
                end
            end
        end
    end

    inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(0)

    inst:ListenForEvent("onbuilt", function(inst, data)
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_craft");
    end)

    if TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.arborist_light then
        inst:DoTaskInTime(0.1, function(inst)
            inst._mone_light_fx = inst._mone_light_fx or SpawnPrefab("mone_light_fx");
            -- 修改特效的照明范围和强度
            do
                inst._mone_light_fx.Light:SetRadius(15);
                inst._mone_light_fx.Light:SetIntensity(0.4);
            end
            inst._mone_light_fx._mone_arborist = inst;
            inst._mone_light_fx.entity:SetParent(inst.entity);
        end);
    end

    -- 种树！
    inst:DoTaskInTime(0, function(inst, plantTrees)
        inst:DoPeriodicTask(1, plantTrees); -- NOTE: 这种匿名函数默认会传入一个 inst 的
    end, plantTrees);

    return inst;
end

return Prefab("mone_arborist", fn, assets),
MakePlacer("mone_arborist_placer", "sand_castle", "sand_castle", "full");