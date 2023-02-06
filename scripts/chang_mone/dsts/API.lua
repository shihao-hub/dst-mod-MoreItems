---
--- @author zsh in 2023/1/8 14:13
---

local API = {};

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

---�ж�ĳԪ���Ƿ��Ǳ��еļ�
local function containsKey(t, e)
    for k, _ in pairs(t) do
        if k == e then
            return true;
        end
    end
    return false;
end

---�ж�ĳԪ���Ƿ��Ǳ��е�ֵ
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

-- FIXME: __API.xpcall �����⣬����������� pack unpack �����⣬1,2,3,nil,4 �����Ļ���nil ���涼�����ˣ�
-- FIXME: ������ֻ�е�һ���ļ�����Ʒ����ɹ��ˣ�������ļ���ע��ʧ�ܡ�
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
        -- �����ļ������ظ��ļ����빹�ɵ���������
        local fun, msg = loadfile(filepath);
        if not fun then
            print("ERROR!!!", msg);
            return prefabsList;
        end
        if fun then
            -- 2301081700: ����û��Ҫ����д�ɣ��ҵ���Ӧ���Ǳ���ѧϰ��Ŀ��д�ġ�
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

---��Ԥ���������ֵ�����������
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

    -- pairs �������
    for k, _ in pairs(slots) do
        keys[#keys + 1] = k;
    end
    table.sort(keys);

    -- ipairs ��˳���
    for k, v in ipairs(keys) do
        if (k ~= v) then
            -- ���ڿն�
            local item = container:RemoveItemBySlot(v);
            container:GiveItem(item, k); -- TODO:��������ѵ����޻ᷢ��ʲô�� Answer: �����
        end
    end
    -- ��ʱ��slot �����ڿն�
    slots = container.slots;

    -- �ն�������ϣ�����Ԥ��������ֽ����ֵ���
    table.sort(slots, function(entity1, entity2)
        local a, b = tostring(entity1.prefab), tostring(entity2.prefab);

        --[[        -- ���Ԥ��������ĩβ�������֣��ҳ�ĩβ�����⣬��ȣ�����Ŵ�С����
                -- NOTE: û��Ҫ����Ϊ�ַ��������жϴ�С
                local prefix_name1,num1 = string.match(a, '(.-)(%d+)$');
                local prefix_name2,num2 = string.match(b, '(.-)(%d+)$');
                if (prefix_name1 == prefix_name2 and num1 and num2) then
                    return tonumber(num1) < tonumber(num2);
                end]]

        return a < b and true or false; -- �����Լ����
    end)

    -- ��ʱ��slots �Ѿ�������ˣ���ʼ����
    for i, v in ipairs(slots) do
        local item = container:RemoveItemBySlot(i);
        container:GiveItem(item); -- slot == nil�������ÿһ�����Ӱ� item ����ȥ��item == nil������ true
    end

end

---ת�������ڵ�Ԥ����
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

-- TODO: �ǹ̶��˺��� AOE
function API.onattackAOE()

end

-- TODO: ���ӻ��׵��˺�
function API.onattackTrueDamage()

end

---����� inst��owner ���������� OnEquip �����е��õ�
function API.runningOnWater(inst, owner)
    if inst.running_on_water_task then
        inst.running_on_water_task:Cancel()
        inst.running_on_water_task = nil
    end
    inst.delay_count = 0

    inst.running_on_water_task = inst:DoPeriodicTask(0.1, function()
        local is_moving = owner.sg:HasStateTag("moving") --��������ƶ�
        local is_running = owner.sg:HasStateTag("running") --������ڱ���
        local x, y, z = owner.Transform:GetWorldPosition()

        -- ��������ڻ�����
        if x and y and z then
            if owner.components.drownable and owner.components.drownable:IsOverWater() then
                -- ���ӳ�ʪ��
                inst.components.equippable.equippedmoisture = 1
                inst.components.equippable.maxequippedmoisture = 80

                if is_running or is_moving then
                    inst.delay_count = inst.delay_count + 1
                    if inst.delay_count >= 5 then
                        SpawnPrefab("weregoose_splash_less" .. tostring(math.random(2))).entity:SetParent(owner.entity)
                        inst.delay_count = 0
                    end
                end
                -- �µ�˲���Ȼû�� drownable ���
            elseif owner.components.drownable and not owner.components.drownable:IsOverWater() then
                -- ȡ�����ӳ�ʪ��
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
                --������ʱ��x,y,zΪnil��������Ҫ�ж�һ�¡�
                owner.Physics:Teleport(owner.Transform:GetWorldPosition())
            end
        end
    end
end

-- ������ onunequipfn �����е��õ�
function API.runningOnWaterCancel(inst, owner)
    -- ȡ�����ӳ�ʪ��
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
                --������״̬
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

-- ��Ȼ�����п��ܳ������������
-- Aģ�����a��ǩ��Ȼ��ִ���ҵ���ӱ�ǩ���ִ��룬���ܹ�ʶ������˱�ǩ�Ƿ�������ӵġ�ɾ����ʱ��Ҳ���жϳ�����
-- ���Ǽ�������ӱ�ǩ��Aģ��Ҳ����˱�ǩ��Ȼ�����Ƴ���ǩ��ʱ����ڰ�Aģ�����ع���Ҳ�Ƴ��ˡ��ǿ϶��ͳ������ˡ�
-- ������ô˵�أ�����������õ�����ȫ���á���������û�пɲ��У�

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

-- �������ɨ�ѵ��Ǹ��������ˣ����뱣֤ build��bank һ��
-- δ�� TODO�� ͬ������Ʒ�����Ի�Ƥ����������࣬Ƥ�������������࣬Ƥ��������
---@param name string ��Ϸ�ڶ�Ӧ���Ǹ�Ԥ����Ĵ�����
---@param build string �Ǹ���Ӧ��Ԥ����� build
---@param prefabs table[] ����ЩԤ����Ҫ���޸��أ�
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

---����Զ���Ķ���
function API.addCustomActions(env, custom_actions, component_actions)
    --[[
    execute = nil|false|���� true,,
    id = '', -- ���� id����Ҫȫ��д��ĸ
    str = '', -- ��Ϸ����ʾ�Ķ�������

    ---��������ʱִ�еĺ�����ע������ server ��
    fn = function(act) ... return ture|false|nil; end, ---@param act BufferedAction,

    actiondata = {}, -- ��Ҫ��ӵ�һЩ������ز��������磺���ȼ���ʩ�ž����
    state = '', -- Ҫ�󶨵� SG �� state
]]
    custom_actions = custom_actions or {};

    --[[    actiontype = '', -- ������'SCENE'|'USEITEM'|'POINT'|'EQUIPPED'|'INVENTORY'|'ISVALID'
        component = '', -- ָ���� inst �� component����ͬ�����µ� inst ָ����Ŀ�겻ͬ��ע��һ��
        tests = {
            -- ����󶨶�������������������������붯�������У������ִ����һ���������ɶ������ȼ����ж���
            {
                execute = nil|false|���� true,
                id = '', -- ���� id��ͬ��

                ---ע������ client ��
                testfn = function() ... return ture|false|nil; end; -- �������� actiontype ����ͬ��
            },
        }]]

    component_actions = component_actions or {};

    for _, data in pairs(custom_actions) do
        if (data.execute ~= false and data.id and data.str and data.fn and data.state) then
            data.id = string.upper(data.id);

            -- ����Զ��嶯��
            env.AddAction(data.id, data.str, data.fn);

            if (type(data.actiondata) == 'table') then
                for k, v in pairs(data.actiondata) do
                    ACTIONS[data.id][k] = v;
                end
            end

            -- ��Ӷ���������Ϊͼ
            env.AddStategraphActionHandler("wilson", ActionHandler(ACTIONS[data.id], data.state));
            env.AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS[data.id], data.state));
        end
    end

    for _, data in pairs(component_actions) do
        if (data.actiontype and data.component and data.tests) then
            -- ��Ӷ���������������������󶨣�
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

-- TODO: �����Χ��Ʒ̫���ˣ�ÿ����һ�����ʲ���ת����Ʒ�������ܽ�һ���������������˰ɡ�
-- �����Ҿ��ðɣ��벻Ҫ������̨2018������ľɵ��Զ������ᱡ��ȥ�����������ԡ�
-- �Ҿ���û��Ҫ��������Щ���Ծ���nb����ΰ����ˮƽ����ֻ����������Ĵ�ǳ�Ż�������Ҳ��һ���Ż�������أ�
local function entsNumberEstimate(ents)
    local n = #ents;

    return true;
end

---@param con table ������������
local function genericFX(self, con)
    local selfFX = SpawnPrefab("sand_puff_large_front");
    local conFX = SpawnPrefab("sand_puff")
    local scale = 1.5;
    conFX.Transform:SetScale(scale, scale, scale)
    selfFX.Transform:SetScale(scale, scale, scale)
    conFX.Transform:SetPosition(con.Transform:GetWorldPosition())
    selfFX.Transform:SetPosition(self.Transform:GetWorldPosition())
end

---@param self table ��������
---@param con table ������������
---@param slot number Ҫת�Ƶ���Ʒ���ڵĲ�
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
-- Сľ���ϵ���ͼ
local function findMinisignItem(self, con, slot)
    local item = self.components.container:GetItemInSlot(slot);
    local prefabname = item and item.prefab;
end

-- ��ͨ��
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

-- �����ܾ���������
function API.AutoSorter.beginTransfer(inst)
    local x, y, z = inst.Transform:GetWorldPosition();
    local DIST = 18; -- ת�ƵĻ�����Χ��һ���
    local MUST_TAGS = { "_container" };
    local CANT_TAGS = {
        "INLIMBO", "NOCLICK", "knockbackdelayinteraction", "catchable", "mineactive",
        inst.prefab,
        "stewer",
        "_inventoryitem", "_health",
        "mone_chiminea",
        "pets_container_tag", -- �ҵĳ��������ı�ǩ
    };
    if x and y and z then
        local ents = TheSim:FindEntities(x, y, z, DIST, MUST_TAGS, CANT_TAGS);

        -- ����һ�����Ӵ���֮�������ڵ��ϣ��������� FindEntities ��������ռ��ռ�����ܣ�
        local excludes = TheSim:FindEntities(x, y, z, DIST, { "mone_seedpouch" }, nil--[[{ "INLIMBO", "NOCLICK" }]]);
        for _, v in ipairs(excludes) do
            if v then
                table.insert(ents, 1, v);
            end
        end

        if entsNumberEstimate(ents) then
            -- ��һ�α�����ת�ƽ�ָ������
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
            -- �ڶ��α�����ת��ͬ����Ʒ
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
            -- �����α�����ת��ʣ����Ʒ
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
    -- ת�ƽ���������������Ʒ
    --inst.components.container:DropEverything(); -- ������ˣ�����
end

local function isExcludedSomething(inst)
    -- ��ţ�������ˣ����Ա����� A:������׾��������������ô���µ���˵�����������������
    -- �ų���ǩ���ɡ�����
    --if string.find(inst.prefab, "saddle") then
    --    --print("saddle---------");
    --    return true;
    --end
    local prefabslist = {
        "terrarium", --����̩��
        "glommerflower", --����ķ��
        "chester_eyebone", --�۹�
        "hutch_fishbowl", --�ǿ�
        "beef_bell", --Ƥ��¦ţ��
        "heatrock", --ůʯ
        "moonrockseed", --���屦��
        "fruitflyfruit", --�Ѻù�Ӭ��
        "singingshell_octave3", --����
        "singingshell_octave4",
        "singingshell_octave5",
        "powcake", --֥ʿ���⣨����Ӧ����Ӻ�����������صĶ�����
        "farm_plow_item", --���ػ���ԭ�棩
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
    local src_pos = inst:GetPosition(); -- Question: ����Ȼ��
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
    -- ���Խ����Ʒ���Ƚ������ʧ�ܡ�̫�鷳�ˡ���Ϊ����ôһ����Ʒ����û��Ҫ��������
    local function stewer(self, inst, slot, src_pos)
        do
            -- ��Ҳ���ԣ���Ҳ���ԡ��Ҳ���ÿ�ζ���������Ȼ�������ˡ�
            -- print 2Сʱ������ֻ��20������д���롣����
            return false;
        end

        -- �������Ӵ򿪺��񲢲��� inventory.opencontainers ���棬�������أ�
        -- inventory_replica ���� GetOpenContainers �������ɣ� HUD !!!!!!

        local player = self.inst;

        -- �������ԣ��������д����̫�Ծ������� -- NOTE: ������ǰ�汻ִ�й��ˡ�������Բ����أ����ˡ���˵�ɡ�
        -- ��Ҫ�ο�����mod������˵����дmod��û��˼�����ο�Ҫ���þ��Լ�ȥ�������ο��ɣ�̫��ʱ�䡣ѧϰ������Ҫ�ġ�ģ���Ǵ�Ҫ�ġ�

        --print("0:"..tostring(player.components.inventory_replica)); -- nil .....д����
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

    -- ��˵������(inventory)����������ɣ��һ���û�����������ͻ�����������������ѷ����Ѱ졣
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

        --[[ ֻ�д˴���� if �ж�������ҵ����ݣ������ǹٷ����� ]]

        if stewer(self, inst, slot, src_pos) --[[ ���Դ˺�����ֻ������������ ]] then
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
                        -- tips: self.inst �����PushEvent ���Է�������
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

-- 2023-01-27 �пյĻ��Ż�һ�£�����
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

        --[[ ֻ�д˴���� if �ж�������ҵ����ݣ������ǹٷ����� ]]
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
                        -- tips: self.inst �����PushEvent ���Է�������
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

---ȫ������һ����ǣ������Ѿ����������ˡ��������Ա�֤ shift+��� �ܹ��������г�ȥ��
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

---��������λ�ã�Ԥ�����ļ�ĩβ���������ĸ�������
---���ã�ȡ����ǡ���ǵ����ã��������ǵ�Ԥ��������ùٷ���ԭ����������������д�Ĳ��֡�
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