---
--- @author zsh in 2023/1/9 17:05
---

local API = require("chang_mone.dsts.API");

--[[ �������õı��� mod����� mone_portable_container ��ǩ]]
do
    for _, p in ipairs({
        "mone_backpack", "mone_storage_bag", "mone_piggybag", "mone_piggyback"
    }) do
        env.AddPrefabPostInit(p, function(inst)
            inst:AddTag("mone_portable_container");
        end)
    end
end

-- ע�������������ǳ���Ҫ
TUNING.MONE_TUNING.IGICF_FLAG_NAME = "mone_priority_container_flag";
TUNING.MONE_TUNING.IGICF_TAG = "mone_item_go_into_container_first_tag";

--[[ ��Ʒ���Ƚ����� ]]
do
    if TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.IGICF then
        env.AddPrefabPostInitAny(function(inst)
            if not TheWorld.ismastersim then
                return inst;
            end

            -- �ǵø�ָ�����Ǹ�Ԥ������������ǩ
            if inst:HasTag(TUNING.MONE_TUNING.IGICF_TAG) and inst.components.container then
                local old_onopenfn = inst.components.container.onopenfn;
                inst.components.container.onopenfn = function(inst, data)
                    if old_onopenfn then
                        old_onopenfn(inst, data);
                    end

                    if inst.task then
                        inst.task:Cancel();
                        inst.task = nil;
                    end

                    inst.task = inst:DoPeriodicTask(API.ItemsGICF.redirectItemFlagAndGetTime(inst), function()
                        API.ItemsGICF.redirectItemFlagAndGetTime(inst);
                    end)
                end

                local old_onclosefn = inst.components.container.onclosefn;
                inst.components.container.onclosefn = function(inst, data)
                    if old_onclosefn then
                        old_onclosefn(inst, data);
                    end

                    if inst.task then
                        inst.task:Cancel();
                        inst.task = nil;
                    end

                    API.ItemsGICF.redirectItemFlagAndGetTime(inst);
                end

                API.ItemsGICF.setListenForEvent(inst);
            end
        end)

        ---֮ǰ���и�С���⣬���� ��ֻΪ����������ķ�����ʱ����ˡ����д��Ż�
        env.AddComponentPostInit("inventory", function(self)
            local priority = {
                --["mone_waterchest_inv"] = -1,
                --["mone_piggyback"] = 0,
                ["mone_wathgrithr_box"] = 0.5,
                ["mone_backpack"] = 1,
                ["mone_storage_bag"] = 2,
                ["mone_piggybag"] = 3,
                ["mone_seedpouch"] = 4,
                ["mone_wanda_box"] = 5,
            };

            if TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.IGICF_mone_piggyback then
                priority["mone_piggyback"] = 0;
            end

            if TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.IGICF_waterchest_inv then
                priority["mone_waterchest_inv"] = -1;
            end

            --[[ ��������ѫ�� ]]
            if TUNING.FUNCTIONAL_MEDAL_IS_OPEN then
                priority["medal_box"] = 999
            end

            API.ItemsGICF.itemsGoIntoContainersFirst(self, priority);
        end)

    end

    local need_tag_prefabs = {
        "mone_waterchest_inv",
        "mone_piggyback",
        "mone_wathgrithr_box",
        "mone_backpack",
        "mone_storage_bag",
        "mone_piggybag",
        "mone_seedpouch",
        "mone_wanda_box"
    };

    --[[ ��������ѫ�� ]]
    if TUNING.FUNCTIONAL_MEDAL_IS_OPEN then
        table.insert(need_tag_prefabs, "medal_box");
    end

    for _, p in ipairs(need_tag_prefabs) do
        env.AddPrefabPostInit(p, function(inst)
            inst:AddTag(TUNING.MONE_TUNING.IGICF_TAG);
        end)
    end
end


--[[ �������������ᱻ�رգ�����һ�����´� ]]
do
    local function isMyContainers(inst)
        local cons = {
            "mone_backpack",
            "mone_piggyback",
            "mone_storage_bag",
            "mone_piggybag",
            "mone_wathgrithr_box",
            "mone_wanda_box",
        };
        for _, v in ipairs(cons) do
            if inst.prefab == v then
                return true;
            end
        end
        return false;
    end
    local function hideHook(self)
        local old_Hide = self.Hide
        function self:Hide()
            --�Ƚ���������Ч�����رյ�����������
            local cons = {}
            for k, _ in pairs(self.opencontainers) do
                if isMyContainers(k) then
                    if k.components.container.openlist then
                        for opener, _ in pairs(k.components.container.openlist) do
                            if k.components.inventoryitem and k.components.inventoryitem:IsHeldBy(opener) then
                                table.insert(cons, { container = k, doer = opener })
                            end
                        end
                    end
                end
            end
            if old_Hide then
                old_Hide(self);
            end
            for _, v in ipairs(cons) do
                if v.container and v.doer then
                    if not v.container.components.container:IsOpen() then
                        v.container.components.container:Open(v.doer)
                    end
                end
            end
        end
    end
    env.AddComponentPostInit("inventory", hideHook);
end

--[[ ��ֹ�ҵ������ںڰ����Զ��ر� ]]
do
    env.AddComponentPostInit("inventoryitem", function(self)
        local old_IsHeldBy = self.IsHeldBy
        self.IsHeldBy = function(self, guy)
            if self.owner and self.owner.components.container then
                if self.owner.components.inventoryitem and self.owner.components.inventoryitem.owner == guy then
                    return true
                end
            end
            return old_IsHeldBy(self, guy)
        end
    end)
end

--[[ ���Ӳ���͵ ]]
do
    for _, p in ipairs({
        "mone_backpack", "mone_piggyback", "mone_nightspace_cape", "mone_seasack",
        "mone_storage_bag", "mone_brainjelly", "mone_bathat",
        "mone_piggybag", "mone_waterchest_inv"
    }) do
        env.AddPrefabPostInit(p, function(inst)
            inst:AddTag("nosteal");
        end)
    end
end

