---
--- @author zsh in 2023/1/8 14:13
---

local API = {};

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

---判断某元素是否是表中的键
local function containsKey(t, e)
    for k, _ in pairs(t) do
        if k == e then
            return true;
        end
    end
    return false;
end

---判断某元素是否是表中的值
local function containsValue(t, e)
    for _, v in pairs(t) do
        if v == e then
            return true;
        end
    end
    return false;
end

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

---@param env env
---@return boolean
function API.isDebug(env)
    if env.GetModConfigData("debug") and not string.find(env.modname, "workshop") then
        return true;
    end
    return false;
end

---@param env env
---@return boolean
function API.hasBeenReleased(env)
    if string.find(env.modname, "workshop") then
        return true;
    end
    return false;
end

-- FIXME: __API.xpcall 有问题，好像是里面的 pack unpack 的问题，1,2,3,nil,4 这样的话，nil 后面都忽略了？
-- FIXME: 问题是只有第一个文件的物品导入成功了，后面的文件都注册失败。
---@param files table
function API.loadPrefabs(files)
    do
        return ;
    end

    local prefabsList = {};

    local cnt = 0;
    for _, filepath in ipairs(files) do
        cnt = cnt + 1;
        print("---" .. cnt);
        if not string.find(filepath, ".lua$") then
            filepath = filepath .. ".lua";
        end
        -- 加载文件，返回该文件代码构成的匿名函数
        local fun, msg = loadfile(filepath);
        if not fun then
            print("ERROR!!!", msg);
            return prefabsList;
        end
        if fun then
            -- 2301081700: 根本没必要这样写吧，我当初应该是抱着学习的目的写的。
            local test = { __API.xpcall(fun) };
            print("LENGTH: " .. #test);
            for _, prefab in pairs({ __API.xpcall(fun) }) do
                if type(prefab) == "table" and prefab.is_a and prefab:is_a(Prefab) then
                    table.insert(prefabsList, prefab);
                end
            end
            return prefabsList;
        end
    end

end

---按预制物名字字典序整理容器
---@type fun(inst:table):void
---@param inst table
function API.arrangeContainer(inst)
    if not (inst and inst.components.container) then
        return ;
    end

    ---@type Container
    local container = inst.components.container;
    local slots = container.slots;
    local keys = {};

    -- pairs 是随机的
    for k, _ in pairs(slots) do
        keys[#keys + 1] = k;
    end
    table.sort(keys);

    -- ipairs 是顺序的
    for k, v in ipairs(keys) do
        if (k ~= v) then
            -- 存在空洞
            local item = container:RemoveItemBySlot(v);
            container:GiveItem(item, k); -- TODO:如果超过堆叠上限会发生什么？ Answer: 会掉落
        end
    end
    -- 此时，slot 不存在空洞
    slots = container.slots;

    -- 空洞处理完毕，根据预制物的名字进行字典序
    table.sort(slots, function(entity1, entity2)
        local a, b = tostring(entity1.prefab), tostring(entity2.prefab);

        --[[        -- 如果预制物名字末尾存在数字，且除末尾数字外，相等，按序号大小排列
                -- NOTE: 没必要，因为字符串可以判断大小
                local prefix_name1,num1 = string.match(a, '(.-)(%d+)$');
                local prefix_name2,num2 = string.match(b, '(.-)(%d+)$');
                if (prefix_name1 == prefix_name2 and num1 and num2) then
                    return tonumber(num1) < tonumber(num2);
                end]]

        return a < b and true or false; -- 便于自己理解
    end)

    -- 此时，slots 已经排序好了，开始整理
    for i, v in ipairs(slots) do
        local item = container:RemoveItemBySlot(i);
        container:GiveItem(item); -- slot == nil，会遍历每一个格子把 item 塞进去，item == nil，返回 true
    end

end

---转移容器内的预制物
---@param src table
---@param dest table
function API.transferContainerAllItems(src, dest)
    local src_container = src and src.components.container;

    local dest_container = dest and dest.components.container;

    if src_container and dest_container then
        for i = 1, src_container.numslots do
            local item = src_container:RemoveItemBySlot(i);
            dest_container:GiveItem(item);
        end
    end

end

-- TODO: 非固定伤害的 AOE
function API.onattackAOE()

end

-- TODO: 无视护甲的伤害
function API.onattackTrueDamage()

end

---传入的 inst，owner 代表这是在 OnEquip 函数中调用的
function API.runningOnWater(inst, owner)
    if inst.running_on_water_task then
        inst.running_on_water_task:Cancel()
        inst.running_on_water_task = nil
    end
    inst.delay_count = 0

    inst.running_on_water_task = inst:DoPeriodicTask(0.1, function()
        local is_moving = owner.sg:HasStateTag("moving") --玩家正在移动
        local is_running = owner.sg:HasStateTag("running") --玩家正在奔跑
        local x, y, z = owner.Transform:GetWorldPosition()

        -- 如果不是在换人物
        if x and y and z then
            if owner.components.drownable and owner.components.drownable:IsOverWater() then
                -- 增加潮湿度
                inst.components.equippable.equippedmoisture = 1
                inst.components.equippable.maxequippedmoisture = 80

                if is_running or is_moving then
                    inst.delay_count = inst.delay_count + 1
                    if inst.delay_count >= 5 then
                        SpawnPrefab("weregoose_splash_less" .. tostring(math.random(2))).entity:SetParent(owner.entity)
                        inst.delay_count = 0
                    end
                end
                -- 下地瞬间居然没有 drownable 组件
            elseif owner.components.drownable and not owner.components.drownable:IsOverWater() then
                -- 取消增加潮湿度
                inst.components.equippable.equippedmoisture = 0
                inst.components.equippable.maxequippedmoisture = 0
            end
        end
    end)

    -- !!!
    if owner.components.drownable then
        if owner.components.drownable.enabled ~= false then
            owner.components.drownable.enabled = false
            owner.Physics:ClearCollisionMask()
            owner.Physics:CollidesWith(COLLISION.GROUND)
            owner.Physics:CollidesWith(COLLISION.OBSTACLES)
            owner.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
            owner.Physics:CollidesWith(COLLISION.CHARACTERS)
            owner.Physics:CollidesWith(COLLISION.GIANTS)

            local x, y, z = owner.Transform:GetWorldPosition()
            if x and y and z then
                --换人物时，x,y,z为nil，所以需要判断一下。
                owner.Physics:Teleport(owner.Transform:GetWorldPosition())
            end
        end
    end
end

-- 这是在 onunequipfn 函数中调用的
function API.runningOnWaterCancel(inst, owner)
    -- 取消增加潮湿度
    inst.components.equippable.equippedmoisture = 0
    inst.components.equippable.maxequippedmoisture = 0

    if inst.running_on_water_task then
        inst.running_on_water_task:Cancel()
        inst.running_on_water_task = nil
    end
    if owner.components.drownable then
        if owner.components.drownable.enabled == false then
            owner.components.drownable.enabled = true
            if not owner:HasTag("playerghost") then
                --非死亡状态
                owner.Physics:ClearCollisionMask()
                owner.Physics:CollidesWith(COLLISION.WORLD)
                owner.Physics:CollidesWith(COLLISION.OBSTACLES)
                owner.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
                owner.Physics:CollidesWith(COLLISION.CHARACTERS)
                owner.Physics:CollidesWith(COLLISION.GIANTS)
                local x, y, z = owner.Transform:GetWorldPosition()
                if x and y and z then
                    owner.Physics:Teleport(owner.Transform:GetWorldPosition())
                end
            end
        end
    end
end

-- 虽然还是有可能出现如下情况：
-- A模组添加a标签，然后执行我的添加标签部分代码，我能够识别出来此标签是否是我添加的。删除的时候也能判断出来。
-- 但是加入我添加标签后，A模组也添加了标签。然后我移除标签的时候等于把A模组的相关功能也移除了。那肯定就出问题了。
-- 反正怎么说呢，这个方法有用但不完全有用。。。但是没有可不行！

local tags = {};

function API.AddTag(inst, tag)
    if not inst:HasTag(tag) then
        inst:AddTag(tag);
        if tags[inst] == nil then
            tags[inst] = {};
        end
        tags[inst][tag] = true;
    end
end

function API.RemoveTag(inst, tag)
    if inst:HasTag(tag) then
        if tags[inst] and tags[inst][tag] then
            inst:RemoveTag(tag);
            tags[inst][tag] = nil;
        end
    end
end

-- 这是清洁扫把的那个函数罢了，必须保证 build、bank 一致
-- 未来 TODO： 同类型物品都可以换皮肤，比如灯类，皮肤互换。背包类，皮肤互换。
---@param name string 游戏内对应的那个预制物的代码名
---@param build string 那个对应的预制物的 build
---@param prefabs table[] 有哪些预制物要被修改呢？
function API.reskin(prefabname, build, prefabs)
    local name = prefabname;
    local fn_name = name .. '_clear_fn';
    local fn = rawget(_G, fn_name);
    if not fn then
        print('`' .. fn_name .. '` global function does not exist!');
        return ;
    else
        rawset(_G, fn_name, function(inst, def_build)
            if not containsValue(prefabs, inst.prefab) then
                return fn(inst, def_build);
            else
                inst.AnimState:SetBuild(build);
            end
        end);

        if ((rawget(_G, 'PREFAB_SKINS') or {})[name] and (rawget(_G, 'PREFAB_SKINS_IDS') or {})[name]) then
            for _, reskin_prefab in ipairs(prefabs) do
                PREFAB_SKINS[reskin_prefab] = PREFAB_SKINS[name];
                PREFAB_SKINS_IDS[reskin_prefab] = PREFAB_SKINS_IDS[name];
            end
        end
    end
end

---添加自定义的动作
function API.addCustomActions(env, custom_actions, component_actions)
    --[[
    execute = nil|false|其他 true,,
    id = '', -- 动作 id，需要全大写字母
    str = '', -- 游戏内显示的动作名称

    ---动作触发时执行的函数，注意这是 server 端
    fn = function(act) ... return ture|false|nil; end, ---@param act BufferedAction,

    actiondata = {}, -- 需要添加的一些动作相关参数，比如：优先级、施放距离等
    state = '', -- 要绑定的 SG 的 state
]]
    custom_actions = custom_actions or {};

    --[[    actiontype = '', -- 场景，'SCENE'|'USEITEM'|'POINT'|'EQUIPPED'|'INVENTORY'|'ISVALID'
        component = '', -- 指的是 inst 的 component，不同场景下的 inst 指代的目标不同，注意一下
        tests = {
            -- 允许绑定多个动作，如果满足条件都会插入动作序列中，具体会执行哪一个动作则由动作优先级来判定。
            {
                execute = nil|false|其他 true,
                id = '', -- 动作 id，同上

                ---注意这是 client 端
                testfn = function() ... return ture|false|nil; end; -- 参数根据 actiontype 而不同！
            },
        }]]

    component_actions = component_actions or {};

    for _, data in pairs(custom_actions) do
        if (data.execute ~= false and data.id and data.str and data.fn and data.state) then
            data.id = string.upper(data.id);

            -- 添加自定义动作
            env.AddAction(data.id, data.str, data.fn);

            if (type(data.actiondata) == 'table') then
                for k, v in pairs(data.actiondata) do
                    ACTIONS[data.id][k] = v;
                end
            end

            -- 添加动作驱动行为图
            env.AddStategraphActionHandler("wilson", ActionHandler(ACTIONS[data.id], data.state));
            env.AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS[data.id], data.state));
        end
    end

    for _, data in pairs(component_actions) do
        if (data.actiontype and data.component and data.tests) then
            -- 添加动作触发器（动作和组件绑定）
            env.AddComponentAction(data.actiontype, data.component, function(...)
                data.tests = data.tests or {};
                for _, v in pairs(data.tests) do
                    if (v.execute ~= false and v.id and v.testfn and v.testfn(...)) then
                        table.insert((select(-2, ...)), ACTIONS[v.id]);
                    end
                end
            end)
        end
    end
end

function API.modifyOldActions(env, old_actions)
    old_actions = old_actions or {};

    for _, data in pairs(old_actions) do
        if (data.execute ~= false and data.id) then
            local action = ACTIONS[data.id];

            if (type(data.actiondata) == 'table') then
                for k, v in pairs(data.actiondata) do
                    action[k] = v;
                end
            end

            if (type(data.state) == 'table' and action) then
                local testfn = function(sg)
                    local old_handler = sg.actionhandlers[action].deststate;
                    sg.actionhandlers[action].deststate = function(doer, action)
                        if data.state.testfn and data.state.testfn(doer, action) and data.state.deststate then
                            return data.state.deststate(doer, action);
                        end
                        return old_handler(doer, action);
                    end
                end

                if data.state.client_testfn then
                    testfn = data.state.client_testfn;
                end

                env.AddStategraphPostInit("wilson", testfn);
                env.AddStategraphPostInit("wilson_client", testfn);
            end
        end
    end
end

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

API.AutoSorter = {};

-- TODO: 如果周围物品太多了，每次有一定概率不会转移物品。这总能进一步降低性能消耗了吧。
-- 但是我觉得吧，请不要用我这台2018年出厂的旧电脑而且是轻薄本去评价其他电脑。
-- 我觉得没必要。首先那些电脑绝对nb，其次半吊子水平的我只能做到表面的粗浅优化，而且也不一定优化得如何呢！
local function entsNumberEstimate(ents)
    local n = #ents;

    return true;
end

---@param con table 检索到的容器
local function genericFX(self, con)
    local selfFX = SpawnPrefab("sand_puff_large_front");
    local conFX = SpawnPrefab("sand_puff")
    local scale = 1.5;
    conFX.Transform:SetScale(scale, scale, scale)
    selfFX.Transform:SetScale(scale, scale, scale)
    conFX.Transform:SetPosition(con.Transform:GetWorldPosition())
    selfFX.Transform:SetPosition(self.Transform:GetWorldPosition())
end

---@param self table 容器自身
---@param con table 检索到的容器
---@param slot number 要转移的物品所在的槽
local function findSameObjectAndTransfer(self, con, slot)
    local item = self.components.container:GetItemInSlot(slot);
    local src_pos = self:GetPosition();
    src_pos = nil;
    if item and con and con.components.container and con.components.container:Has(item.prefab, 1)
            and con.prefab ~= self.prefab and item.components.inventoryitem.cangoincontainer then
        item = self.components.container:RemoveItemBySlot(slot);
        item.prevslot = nil;
        item.prevcontainer = nil;
        if con.components.container:GiveItem(item, nil, src_pos) then
            return true;
        else
            self.components.container:GiveItem(item, slot);
            return false;
        end
    end
    return false;
end

local function isIceboxOrSaltboxETC(con)
    if con.components.preserver or con:HasTag("fridge") then
        return true;
    end
    return false;
end

local function noFindObjectAndTransfer(self, con, slot)
    local item = self.components.container:GetItemInSlot(slot);
    local src_pos = self:GetPosition();
    src_pos = nil;
    if item and con and con.components.container and con.prefab ~= self.prefab
            and item.components.inventoryitem.cangoincontainer then
        item = self.components.container:RemoveItemBySlot(slot);
        item.prevslot = nil;
        item.prevcontainer = nil;
        if item.components.perishable then
            if isIceboxOrSaltboxETC(con) and con.components.container:GiveItem(item, nil) then
                return true;
            else
                self.components.container:GiveItem(item, slot);
                return false;
            end
        else
            if not isIceboxOrSaltboxETC(con) and con.components.container:GiveItem(item, nil, src_pos) then
                return true;
            else
                self.components.container:GiveItem(item, slot);
                return false;
            end
        end
    end
end

-- TODO
-- 小木牌上的贴图
local function findMinisignItem(self, con, slot)
    local item = self.components.container:GetItemInSlot(slot);
    local prefabname = item and item.prefab;
end

-- 非通用
local function transferIntoSomeCon(self, con, slot)
    --if findMinisignItem(self, con, slot) then
    --    return true;
    --end

    if con.prefab == "mone_wardrobe" then
        local item = self.components.container:GetItemInSlot(slot);
        local src_pos = self:GetPosition();
        src_pos = nil;
        if item and item:HasTag("_equippable") and con and con.components.container and con.prefab ~= self.prefab and item.components.inventoryitem.cangoincontainer then
            item = self.components.container:RemoveItemBySlot(slot);
            item.prevslot = nil;
            item.prevcontainer = nil;
            if con.components.container:GiveItem(item, nil, src_pos) then
                return true;
            else
                self.components.container:GiveItem(item, slot);
                return false;
            end
        end
    end
    return false;
end

-- 这性能绝对垃圾！
function API.AutoSorter.beginTransfer(inst)
    local x, y, z = inst.Transform:GetWorldPosition();
    local DIST = 18; -- 转移的话，范围大一点点
    local MUST_TAGS = { "_container" };
    local CANT_TAGS = {
        "INLIMBO", "NOCLICK", "knockbackdelayinteraction", "catchable", "mineactive",
        inst.prefab,
        "stewer",
        "_inventoryitem", "_health",
        "mone_chiminea",
        "pets_container_tag", -- 我的宠物容器的标签
    };
    if x and y and z then
        local ents = TheSim:FindEntities(x, y, z, DIST, MUST_TAGS, CANT_TAGS);

        -- 补充一个种子袋（之后限制在地上？），所以 FindEntities 函数到底占不占用性能？
        local excludes = TheSim:FindEntities(x, y, z, DIST, { "mone_seedpouch" }, nil--[[{ "INLIMBO", "NOCLICK" }]]);
        for _, v in ipairs(excludes) do
            if v then
                table.insert(ents, 1, v);
            end
        end

        if entsNumberEstimate(ents) then
            -- 第一次遍历：转移进指定容器
            local slotsNum = inst.components.container:GetNumSlots();
            slotsNum = inst.components.container:GetNumSlots();
            for i = 1, slotsNum do
                for _, v in ipairs(ents) do
                    if transferIntoSomeCon(inst, v, i) then
                        --print("transferIntoSomeCon---[" .. tostring(i) .. "]");
                        genericFX(inst, v);
                        break ;
                    end
                end
            end
            -- 第二次遍历：转移同类物品
            slotsNum = inst.components.container:GetNumSlots();
            for i = 1, slotsNum do
                for _, v in ipairs(ents) do
                    if findSameObjectAndTransfer(inst, v, i) then
                        --print("findSameObjectAndTransfer---[" .. tostring(i) .. "]");
                        genericFX(inst, v);
                        break ;
                    end
                end
            end
            -- 第三次遍历：转移剩余物品
            slotsNum = inst.components.container:GetNumSlots();
            for i = 1, slotsNum do
                for _, v in ipairs(ents) do
                    if noFindObjectAndTransfer(inst, v, i) then
                        --print("noFindObjectAndTransfer---[" .. tostring(i) .. "]");
                        genericFX(inst, v);
                        break ;
                    end
                end
            end
        end
    end
    -- 转移结束，掉落所有物品
    --inst.components.container:DropEverything(); -- 别掉落了，不好
end

local function isExcludedSomething(inst)
    -- 把牛鞍收走了？所以崩溃吗？ A:罪魁祸首就是这个！具体怎么导致的再说。反正不能有这个。
    -- 排除标签即可。。。
    --if string.find(inst.prefab, "saddle") then
    --    --print("saddle---------");
    --    return true;
    --end
    local prefabslist = {
        "terrarium", --盒中泰拉
        "glommerflower", --格罗姆花
        "chester_eyebone", --眼骨
        "hutch_fishbowl", --星空
        "beef_bell", --皮弗娄牛铃
        "heatrock", --暖石
        "moonrockseed", --天体宝珠
        "fruitflyfruit", --友好果蝇果
        "singingshell_octave3", --贝壳
        "singingshell_octave4",
        "singingshell_octave5",
        "powcake", --芝士蛋糕（后续应该添加和猪人陷阱相关的东西）
        "farm_plow_item", --耕地机（原版）
    };
    for _, v in ipairs(prefabslist) do
        if inst.prefab == v then
            return true;
        end
    end
    if inst:HasTag("trap") then
        return true;
    end
    --if string.find(inst.prefab,"wx78module_") then
    --    return true;
    --end
    return false;
end

local function pickObjectOnFloorCommonly(inst, MUST_TAGS, CANT_TAGS)
    local x, y, z = inst.Transform:GetWorldPosition();
    local src_pos = inst:GetPosition(); -- Question: 不自然！
    src_pos = nil;
    local DIST = 15;
    --local MUST_TAGS = MUST_TAGS;
    --local CANT_TAGS = CANT_TAGS;
    if x and y and z then
        local ents = TheSim:FindEntities(x, y, z, DIST, MUST_TAGS, CANT_TAGS);
        for _, v in ipairs(ents) do
            if not isExcludedSomething(v) then
                if v.components.inventoryitem and v.components.inventoryitem.canbepickedup and
                        v.components.inventoryitem.cangoincontainer and not v.components.inventoryitem.canonlygoinpocket and
                        not v.components.inventoryitem:IsHeld() and not v:HasTag("_container")
                then
                    if inst.components.container:GiveItem(v, nil, src_pos) then
                        local fx = SpawnPrefab("sand_puff");
                        local scale = 1.5;
                        fx.Transform:SetScale(scale, scale, scale);
                        fx.Transform:SetPosition(v.Transform:GetWorldPosition());
                    end
                end
            end
        end
    end
end

function API.AutoSorter.pickObjectOnFloor(inst)
    local MUST_TAGS = { "_inventoryitem" };
    local CANT_TAGS = {
        "INLIMBO", "NOCLICK", "knockbackdelayinteraction", "catchable", "mineactive",
        "mone_auto_sorter_exclude_prefabs", "irreplaceable", "nonpotatable",
        "_equippable", "_container"
    };
    pickObjectOnFloorCommonly(inst, MUST_TAGS, CANT_TAGS);
end

function API.AutoSorter.pickObjectOnFloorOnClick(inst)
    local MUST_TAGS = { "_inventoryitem" };
    local CANT_TAGS = {
        "INLIMBO", "NOCLICK", "knockbackdelayinteraction", "catchable", "mineactive",
        "mone_auto_sorter_exclude_prefabs", "irreplaceable", "nonpotatable"
    };
    pickObjectOnFloorCommonly(inst, MUST_TAGS, CANT_TAGS);
end

function API.AutoSorter.surroundIsFull(inst)

end

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

API.ItemsGICF = {};

---@param inventory Inventory
---@param priority table<string,number>
function API.ItemsGICF.itemsGoIntoContainersFirst(inventory, priority)
    -- 尝试解决物品优先进入锅。失败。太麻烦了。就为了这么一个物品。我没必要这样做。
    local function stewer(self, inst, slot, src_pos)
        do
            -- 这也不对，那也不对。我不想每次都重启饥荒然后闪退了。
            -- print 2小时，可能只有20分钟在写代码。。。
            return false;
        end

        -- 锅和箱子打开好像并不在 inventory.opencontainers 里面，在哪里呢？
        -- inventory_replica 调用 GetOpenContainers 函数即可？ HUD !!!!!!

        local player = self.inst;

        -- 经过测试，发现这个写法不太对劲。。。 -- NOTE: 好像在前面被执行过了。。。额，对不对呢？算了。再说吧。
        -- 需要参考其他mod，所以说啊，写mod好没意思，不参考要花好久自己去看。不参考吧，太花时间。学习才是主要的。模组是次要的。

        --print("0:"..tostring(player.components.inventory_replica)); -- nil .....写错了
        --print("0:"..tostring(player.replica.inventory)); -- table
        local opencontainers = player and player.replica.inventory and player.replica.inventory:GetOpenContainers() or {};
        print("1:" .. tostring(#opencontainers));
        for k, _ in pairs(opencontainers) do
            print("2:" .. tostring(k.prefab));
            if k:HasTag("stewer") and k.components.container and k.components.container:CanTakeItemInSlot(inst, nil) then
                print("3:" .. tostring(k.prefab));
                local item = inst.components.stackable:Get();
                k.components.container:GiveItem(item, nil, src_pos);
                return true;
            end
        end
        return false;
    end

    local old_GiveItem = inventory.GiveItem;

    -- 话说，这里(inventory)是主机代码吧？我还是没懂，饥荒主客机交互。这就是理论匮乏的难办。
    inventory.GiveItem = function(self, inst, slot, src_pos)
        if inst and (inst.components.inventoryitem == nil or not inst:IsValid()) then
            print("Warning: Can't give item because it's not an inventory item.")
            return
        end
        local eslot = self:IsItemEquipped(inst)

        if eslot then
            self:Unequip(eslot)
        end

        local new_item = inst ~= self.activeitem
        if new_item then
            for k, v in pairs(self.equipslots) do
                if v == inst then
                    new_item = false
                    break
                end
            end
        end

        if inst.components.inventoryitem.owner and inst.components.inventoryitem.owner ~= self.inst then
            inst.components.inventoryitem:RemoveFromOwner(true)
        end

        local objectDestroyed = inst.components.inventoryitem:OnPickup(self.inst, src_pos)
        if objectDestroyed then
            return
        end

        local can_use_suggested_slot = false

        if not slot and inst.prevslot and not inst.prevcontainer then
            slot = inst.prevslot
        end

        if not slot and inst.prevslot and inst.prevcontainer then
            if inst.prevcontainer.inst:IsValid() and inst.prevcontainer:IsOpenedBy(self.inst) then
                local item = inst.prevcontainer:GetItemInSlot(inst.prevslot)
                if item == nil then
                    if inst.prevcontainer:GiveItem(inst, inst.prevslot) then
                        return true
                    end
                elseif item.prefab == inst.prefab and item.skinname == inst.skinname and
                        item.components.stackable ~= nil and
                        inst.prevcontainer:AcceptsStacks() and
                        inst.prevcontainer:CanTakeItemInSlot(inst, inst.prevslot) and
                        item.components.stackable:Put(inst) == nil then
                    return true
                end
            end
            inst.prevcontainer = nil
            inst.prevslot = nil
            slot = nil
        end

        if slot then
            local olditem = self:GetItemInSlot(slot)
            can_use_suggested_slot = slot ~= nil
                    and slot <= self.maxslots
                    and (olditem == nil or (olditem and olditem.components.stackable and olditem.prefab == inst.prefab and olditem.skinname == inst.skinname))
                    and self:CanTakeItemInSlot(inst, slot)
        end

        --[[ 只有此处这个 if 判断语句是我的内容，其余是官方代码 ]]

        if stewer(self, inst, slot, src_pos) --[[ 忽略此函数，只是留作长记性 ]] then
            -- DoNothing
            print("stewer(self, inst, slot, src_pos) return true");
            return true;
        elseif (not slot and not inst[TUNING.MONE_TUNING.IGICF_FLAG_NAME]) then

            local opencontainers = self.opencontainers;

            local vip_containers = {};
            local priority_containers = priority;

            for c, v in pairs(opencontainers) do
                if c and v then
                    if containsKey(priority_containers, c.prefab) then
                        vip_containers[#vip_containers + 1] = c;
                    end
                end
            end

            table.sort(vip_containers, function(entity1, entity2)
                local p1, p2;
                if entity1 and entity2 then
                    p1, p2 = priority_containers[entity1.prefab], priority_containers[entity2.prefab];
                end
                if p1 and p2 then
                    return p1 > p2;
                end
            end);

            for _, c in ipairs(vip_containers) do
                ---@type Container
                local container = c and c.components.container;
                if container and container:IsOpen() then
                    if container:GiveItem(inst, nil, src_pos) then
                        -- tips: self.inst 是人物，PushEvent 可以发出声音
                        -- self.inst:PushEvent("gotnewitem", { item = inst, slot = slot })

                        if TheFocalPoint and TheFocalPoint.SoundEmitter then
                            TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/collect_resource");
                        end
                        return true;
                    end
                end
            end
        end
        return old_GiveItem(self, inst, slot, src_pos);
    end
end

-- 2023-01-27 有空的话优化一下！！！
function API.ItemsGICF.itemsGoIntoContainersFirst2(inventory, priority)
    local old_GiveItem = inventory.GiveItem;

    inventory.GiveItem = function(self, inst, slot, src_pos)
        if inst and (inst.components.inventoryitem == nil or not inst:IsValid()) then
            print("Warning: Can't give item because it's not an inventory item.")
            return
        end

        local eslot = self:IsItemEquipped(inst)

        if eslot then
            self:Unequip(eslot)
        end

        local new_item = inst ~= self.activeitem
        if new_item then
            for k, v in pairs(self.equipslots) do
                if v == inst then
                    new_item = false
                    break
                end
            end
        end

        if inst.components.inventoryitem.owner and inst.components.inventoryitem.owner ~= self.inst then
            inst.components.inventoryitem:RemoveFromOwner(true)
        end

        local objectDestroyed = inst.components.inventoryitem:OnPickup(self.inst, src_pos)
        if objectDestroyed then
            return
        end

        local can_use_suggested_slot = false

        if not slot and inst.prevslot and not inst.prevcontainer then
            slot = inst.prevslot
        end

        if not slot and inst.prevslot and inst.prevcontainer then
            if inst.prevcontainer.inst:IsValid() and inst.prevcontainer:IsOpenedBy(self.inst) then
                local item = inst.prevcontainer:GetItemInSlot(inst.prevslot)
                if item == nil then
                    if inst.prevcontainer:GiveItem(inst, inst.prevslot) then
                        return true
                    end
                elseif item.prefab == inst.prefab and item.skinname == inst.skinname and
                        item.components.stackable ~= nil and
                        inst.prevcontainer:AcceptsStacks() and
                        inst.prevcontainer:CanTakeItemInSlot(inst, inst.prevslot) and
                        item.components.stackable:Put(inst) == nil then
                    return true
                end
            end
            inst.prevcontainer = nil
            inst.prevslot = nil
            slot = nil
        end

        if slot then
            local olditem = self:GetItemInSlot(slot)
            can_use_suggested_slot = slot ~= nil
                    and slot <= self.maxslots
                    and (olditem == nil or (olditem and olditem.components.stackable and olditem.prefab == inst.prefab and olditem.skinname == inst.skinname))
                    and self:CanTakeItemInSlot(inst, slot)
        end

        --[[ 只有此处这个 if 判断语句是我的内容，其余是官方代码 ]]
        if (not slot and not inst[TUNING.MONE_TUNING.IGICF_FLAG_NAME]) then

            local opencontainers = self.opencontainers;

            local vip_containers = {};
            local priority_containers = priority;

            for c, v in pairs(opencontainers) do
                if c and v then
                    if containsKey(priority_containers, c.prefab) then
                        vip_containers[#vip_containers + 1] = c;
                    end
                end
            end

            table.sort(vip_containers, function(entity1, entity2)
                local p1, p2;
                if entity1 and entity2 then
                    p1, p2 = priority_containers[entity1.prefab], priority_containers[entity2.prefab];
                end
                if p1 and p2 then
                    return p1 > p2;
                end
            end);

            for _, c in ipairs(vip_containers) do
                ---@type Container
                local container = c and c.components.container;
                if container and container:IsOpen() then
                    if container:GiveItem(inst, nil, src_pos) then
                        -- tips: self.inst 是人物，PushEvent 可以发出声音
                        -- self.inst:PushEvent("gotnewitem", { item = inst, slot = slot })

                        if TheFocalPoint and TheFocalPoint.SoundEmitter then
                            TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/collect_resource");
                        end
                        return true;
                    end
                end
            end
        end

        return old_GiveItem(self, inst, slot, src_pos);
    end
end

---全部设置一个标记，表明已经在容器中了。这样可以保证 shift+左键 能够从容器中出去。
function API.ItemsGICF.redirectItemFlagAndGetTime(inst)
    if not (inst and inst.components.container) then
        return 2 ^ 31 - 1;
    end

    local container = inst.components.container;

    for _, v in pairs(container.slots) do
        v[TUNING.MONE_TUNING.IGICF_FLAG_NAME] = true;
    end

    if (container.numslots < 47) then
        return 1;
    else
        return 2;
    end
end

function API.ItemsGICF.clearAllFlag(inst)
    ---@type Container
    local container = inst.components.container;
    if container then
        for _, v in pairs(container.slots) do
            v[TUNING.MONE_TUNING.IGICF_FLAG_NAME] = nil;
        end
    end
end

---函数调用位置：预制物文件末尾，设置这四个监听器
---作用：取消标记。标记的作用：有这个标记的预制物，将调用官方的原函数，而不是我重写的部分。
function API.ItemsGICF.setListenForEvent(inst)
    inst:ListenForEvent("dropitem", function(inst, data)
        if data and data.item then
            data.item[TUNING.MONE_TUNING.IGICF_FLAG_NAME] = nil;
        end
    end)
    inst:ListenForEvent("itemlose", function(inst, data)
        inst:DoTaskInTime(0, function()
            if data and data.prev_item then
                data.prev_item[TUNING.MONE_TUNING.IGICF_FLAG_NAME] = nil;
            end
        end)
    end)
    inst:ListenForEvent("gotnewitem", function(inst, data)
        if data and data.item then
            data.item[TUNING.MONE_TUNING.IGICF_FLAG_NAME] = true;
        end
    end)
    inst:ListenForEvent("itemget", function(inst, data)
        if data and data.item then
            data.item[TUNING.MONE_TUNING.IGICF_FLAG_NAME] = true;
        end
    end)
end

return API;