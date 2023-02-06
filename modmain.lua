---
--- @author zsh in 2023/1/8 5:50
---

-- really important
GLOBAL.setmetatable(env, { __index = function(_, k)
    return GLOBAL.rawget(GLOBAL, k);
end });

-- forget it
if IsRail() then
    error("BAN WeGame");
end

local API = require("chang_mone.dsts.API");

TUNING.MORE_ITEMS_ON = true;

--TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.insight_and_pheromonestone
TUNING.MONE_TUNING = {
    AUTO_SORTER = {
        whetherIsFull = env.GetModConfigData("auto_sorter_mode");
        nFullInterval = env.GetModConfigData("auto_sorter_is_full");
        auto_sorter_light = env.GetModConfigData("auto_sorter_light");
        auto_sorter_no_fuel = env.GetModConfigData("auto_sorter_no_fuel");
        auto_sorter_notags_extra = env.GetModConfigData("auto_sorter_notags_extra");
    };
    GET_MOD_CONFIG_DATA = {
        BALANCE = env.GetModConfigData("balance");

        -- 辅助功能
        container_removable = env.GetModConfigData("container_removable");
        chests_arrangement = env.GetModConfigData("chests_arrangement");
        current_date = env.GetModConfigData("current_date");
        extra_equip_slots = env.GetModConfigData("extra_equip_slots");
        backpacks_light = env.GetModConfigData("backpacks_light");
        arborist_light = env.GetModConfigData("arborist_light");

        -- 模组功能设置
        IGICF = env.GetModConfigData("IGICF");
        IGICF_mone_piggyback = env.GetModConfigData("IGICF_mone_piggyback");
        IGICF_waterchest_inv = env.GetModConfigData("IGICF_waterchest_inv");
        wardrobe_background = env.GetModConfigData("mone_wardrobe_background");
        mone_chests_boxs_capability = env.GetModConfigData("mone_chests_boxs_capability");
        mone_backpack_auto = env.GetModConfigData("mone_backpack_auto");
        mone_wanda_box_itemtestfn_extra1 = env.GetModConfigData("mone_wanda_box_itemtestfn_extra1");
        mone_wanda_box_itemtestfn_extra2 = env.GetModConfigData("mone_wanda_box_itemtestfn_extra2");
        cane_gointo_mone_backpack = env.GetModConfigData("cane_gointo_mone_backpack"); -- 功能已舍弃
        --mone_city_lamp_reskin = env.GetModConfigData("mone_city_lamp_reskin");
        --mone_storage_bag_no_remove = env.GetModConfigData("mone_storage_bag_no_remove");
        greenamulet_pheromonestone = env.GetModConfigData("greenamulet_pheromonestone");


        -- 取消某件物品及其相关内容
        walking_stick = env.GetModConfigData("__walking_stick");
        spear_poison = env.GetModConfigData("__spear_poison");
        harvester_staff = env.GetModConfigData("__harvester_staff");
        halberd = env.GetModConfigData("__halberd");

        pith = env.GetModConfigData("__pith");
        gashat = env.GetModConfigData("__gashat");
        double_umbrella = env.GetModConfigData("__double_umbrella");
        brainjelly = env.GetModConfigData("__brainjelly");
        bathat = env.GetModConfigData("__bathat");

        wathgrithr_box = env.GetModConfigData("__wathgrithr_box");
        wanda_box = env.GetModConfigData("__wanda_box");
        --backpack_piggyback = env.GetModConfigData("__backpack_piggyback");
        backpack = env.GetModConfigData("__backpack");
        piggyback = env.GetModConfigData("__piggyback");
        storage_bag = env.GetModConfigData("__storage_bag");
        piggybag = env.GetModConfigData("__piggybag");
        seasack = env.GetModConfigData("__seasack");
        nightspace_cape = env.GetModConfigData("__nightspace_cape");
        waterchest = env.GetModConfigData("__waterchest");
        mone_seedpouch = env.GetModConfigData("__mone_seedpouch");
        --beef_bell = env.GetModConfigData("__beef_bell");

        chiminea = env.GetModConfigData("__chiminea");
        garlic_structure = env.GetModConfigData("__garlic_structure");
        arborist = env.GetModConfigData("__arborist");
        city_lamp = env.GetModConfigData("__city_lamp");
        chests_boxs = env.GetModConfigData("__chests_boxs");
        firesuppressor = env.GetModConfigData("__firesuppressor");
        moondial = env.GetModConfigData("__moondial");
        wardrobe = env.GetModConfigData("__wardrobe");

        poisonblam = env.GetModConfigData("__poisonblam");
        waterballoon = env.GetModConfigData("__waterballoon");
        pheromonestone = env.GetModConfigData("__pheromonestone");

        mone_beef_wellington = env.GetModConfigData("__mone_beef_wellington");
        mone_chicken_soup = env.GetModConfigData("__mone_chicken_soup");
        mone_lifeinjector_vb = env.GetModConfigData("__mone_lifeinjector_vb");
        mone_honey_ham_stick = env.GetModConfigData("__mone_honey_ham_stick");


        -- 为了我自己玩而写的辅助功能
        trap_auto_reset = env.GetModConfigData("trap_auto_reset");
        wathgrithr_vegetarian = env.GetModConfigData("wathgrithr_vegetarian");
        forced_attack_lightflier = env.GetModConfigData("forced_attack_lightflier");
        forced_attack_bound_beefalo = env.GetModConfigData("forced_attack_bound_beefalo");

        insight_and_pheromonestone_permit = env.GetModConfigData("insight_and_pheromonestone_permit");

        -- Debug
        relic_2 = env.GetModConfigData("__relic_2");
        bushhat = env.GetModConfigData("__bushhat");

        ponds = env.GetModConfigData("__ponds");
        meatrack_hermit = env.GetModConfigData("__meatrack_hermit");
        beebox_hermit = env.GetModConfigData("__beebox_hermit");
        workable_meatrack_hermit_beebox_hermit = env.GetModConfigData("workable_meatrack_hermit_beebox_hermit");
    };
};

local config_data = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA;

-- 此处这几个物品中的某一个或几个导致的三维锁定的严重bug的出现！！！
if not API.isDebug(env) then
    config_data.relic_2 = false;
    config_data.bushhat = false;

    config_data.ponds = false;
    config_data.meatrack_hermit = false;
    config_data.beebox_hermit = false;
    config_data.workable_meatrack_hermit_beebox_hermit = false;
end

-- 2023-02-05 已经独立为扩展包
if API.isDebug(env) and not env.GetModConfigData("debug_switch") then
    config_data.relic_2 = false;
    config_data.bushhat = false;

    config_data.ponds = false;
    config_data.meatrack_hermit = false;
    config_data.beebox_hermit = false;
    config_data.workable_meatrack_hermit_beebox_hermit = false;
end

--[[ 模组兼容 ]]
env.modimport("modmain/compatibility.lua");

--[[ PrefabFiles and Assets ]]
env.PrefabFiles = {
    --"mone_prefabs"

    --"mone/mine/halberd", -- 额，铲子也有动画。

    --"mone/mine/goggles/goggles", -- 1、地面动画问题 2、佩戴后贴图问题 3、鼹鼠帽效果生效未成功

    "mone/union/fx/bathat_fx",
    "mone/union/fx/light_fx",
    --"mone/union/fx/bundle_fx",-- 建家东西摆歪了，究竟应该怎么处理好呢？待定...我感觉还是不处理好。。。直接 c_give 材料拉倒。哈哈。

    "mone/union/hats",
    "mone/union/foods",
    "mone/union/food_buffs",

    "mone/union/placers"
}

env.Assets = {
    Asset("ANIM", "anim/my_chest_ui_4x4.zip"),
    Asset("ANIM", "anim/my_chest_ui_5x5.zip"),
    Asset("ANIM", "anim/my_chest_ui_6x6.zip"),
    Asset("ANIM", "anim/big_box_ui_120.zip"),
    Asset("ANIM", "anim/ui_bigbag_3x8.zip"),
    Asset("ANIM", "anim/ui_chest_4x5.zip"),
    Asset("ANIM", "anim/ui_chest_5x8.zip"),
    Asset("ANIM", "anim/ui_chest_5x12.zip"),
    Asset("ANIM", "anim/ui_chest_5x16.zip"),
    Asset("ANIM", "anim/mone_seedpouch.zip"),

    Asset("IMAGE", "images/inventoryimages/mone_minotaurchest.tex"),
    Asset("ATLAS", "images/inventoryimages/mone_minotaurchest.xml"),

    Asset("IMAGE", "images/uiimages/back.tex"),
    Asset("ATLAS", "images/uiimages/back.xml"),
    Asset("IMAGE", "images/uiimages/neck.tex"),
    Asset("ATLAS", "images/uiimages/neck.xml"),

    Asset("IMAGE", "images/uiimages/krampus_sack_bg.tex"),
    Asset("ATLAS", "images/uiimages/krampus_sack_bg.xml"),

    Asset("IMAGE", "images/DLC0000/inventoryimages.tex"),
    Asset("ATLAS", "images/DLC0000/inventoryimages.xml"),

    Asset("IMAGE", "images/DLC0001/inventoryimages.tex"),
    Asset("ATLAS", "images/DLC0001/inventoryimages.xml"),

    Asset("IMAGE", "images/DLC0002/inventoryimages.tex"),
    Asset("ATLAS", "images/DLC0002/inventoryimages.xml"),

    Asset("IMAGE", "images/DLC0003/inventoryimages.tex"),
    Asset("ATLAS", "images/DLC0003/inventoryimages.xml"),
    Asset("IMAGE", "images/DLC0003/inventoryimages_2.tex"),
    Asset("ATLAS", "images/DLC0003/inventoryimages_2.xml"),
}

if config_data.relic_2 then
    table.insert(env.Assets, Asset("ANIM", "anim/my_ui_cookpot_1x1.zip"));
end


--[[ require and import ]]
do
    require("languages.mone.loc");
    require("definitions.mone.containers_ui");

    env.modimport("modmain/recipes.lua");
    env.modimport("modmain/minimap.lua");
    env.modimport("modmain/actions.lua");
    env.modimport("modmain/reskin.lua");

    env.modimport("modmain/PostInit/containers_commonly.lua");
    env.modimport("modmain/PostInit/mone_lifeinjector_vb.lua");
    env.modimport("modmain/PostInit/bushhat.lua");
    env.modimport("modmain/PostInit/kleis.lua");
end

--[[ prefabs ]]
do
    if config_data.walking_stick then
        table.insert(env.PrefabFiles, "mone/mine/walking_stick");
    end
    if config_data.spear_poison then
        table.insert(env.PrefabFiles, "mone/mine/spear_poison");
    end
    if config_data.harvester_staff then
        table.insert(env.PrefabFiles, "mone/mine/harvester_staff");
    end
    if config_data.halberd then
        table.insert(env.PrefabFiles, "mone/mine/halberd");
    end

    -- 都在 hats.lua 文件中
    --if config_data.pith then
    --    table.insert(env.PrefabFiles, "mone/mine/pith");
    --end
    --if config_data.gashat then
    --    table.insert(env.PrefabFiles, "mone/mine/pith");
    --end
    --if config_data.double_umbrella then
    --    table.insert(env.PrefabFiles, "mone/mine/pith");
    --end
    if config_data.brainjelly then
        env.modimport("modmain/PostInit/brainjelly.lua");
    end
    if config_data.bathat then
        env.modimport("modmain/PostInit/bathat.lua");
    end

    if config_data.wathgrithr_box then
        table.insert(env.PrefabFiles, "mone/real_mine/wathgrithr_box");
    end
    if config_data.wanda_box then
        env.modimport("modmain/PostInit/wanda_box.lua");
        table.insert(env.PrefabFiles, "mone/real_mine/wanda_box");
    end
    if config_data.backpack or config_data.piggyback then
        env.modimport("modmain/PostInit/backpack_piggyback.lua");
        if config_data.backpack then
            table.insert(env.PrefabFiles, "mone/game/backpack");
        end
        if config_data.piggyback then
            table.insert(env.PrefabFiles, "mone/game/piggyback");
        end
    end
    if config_data.storage_bag then
        --env.modimport("modmain/AUXmods/find_best_container.lua"); -- 无效
        table.insert(env.PrefabFiles, "mone/mine/storage_bag");
    end
    if config_data.piggybag then
        env.modimport("modmain/PostInit/piggybag.lua");
        table.insert(env.PrefabFiles, "mone/real_mine/piggybag");
    end
    if config_data.seasack then
        table.insert(env.PrefabFiles, "mone/mine/seasack");
    end
    if config_data.nightspace_cape then
        env.modimport("modmain/PostInit/nightspace_cape.lua");
        table.insert(env.PrefabFiles, "mone/mine/nightspace_cape");
    end
    if config_data.waterchest then
        table.insert(env.PrefabFiles, "mone/mine/waterchest");
    end
    if config_data.mone_seedpouch then
        table.insert(env.PrefabFiles, "mone/game/seedpouch");
    end

    if config_data.chiminea then
        table.insert(env.PrefabFiles, "mone/mine/chiminea");
    end
    if config_data.garlic_structure then
        env.modimport("modmain/PostInit/garlic_structure.lua");
        table.insert(env.PrefabFiles, "mone/game/garlic_structure");
    end
    if config_data.arborist then
        table.insert(env.PrefabFiles, "mone/mine/arborist");
    end
    if config_data.city_lamp then
        table.insert(env.PrefabFiles, "mone/mine/city_lamp");
    end
    if config_data.chests_boxs then
        env.modimport("modmain/PostInit/chests.lua");
        env.modimport("modmain/PostInit/boxs.lua");
        table.insert(env.PrefabFiles, "mone/game/treasurechest");
        table.insert(env.PrefabFiles, "mone/game/dragonfly_chest");
        table.insert(env.PrefabFiles, "mone/game/icebox");
        table.insert(env.PrefabFiles, "mone/game/saltbox");
    end
    if config_data.firesuppressor then
        table.insert(env.PrefabFiles, "mone/game/firesuppressor");
    end
    if config_data.moondial then
        table.insert(env.PrefabFiles, "mone/game/moondial");
    end
    if config_data.wardrobe then
        table.insert(env.PrefabFiles, "mone/game/wardrobe");
    end
    --if config_data.beef_bell then
    --    table.insert(env.PrefabFiles, "mone/game/beef_bell");
    --end
    if config_data.relic_2 then
        table.insert(env.PrefabFiles, "mone/mine/relic_2");
        table.insert(env.PrefabFiles, "mone/mine/relic_2_flame");
        env.modimport("modmain/PostInit/relic_2.lua");
    end

    if config_data.poisonblam then
        env.modimport("modmain/PostInit/poisonblam.lua");
        table.insert(env.PrefabFiles, "mone/mine/poisonblam");
    end
    if config_data.waterballoon then
        env.modimport("modmain/PostInit/waterballoon.lua");
        table.insert(env.PrefabFiles, "mone/game/waterballoon");
    end
    if config_data.pheromonestone then
        env.modimport("modmain/PostInit/pheromonestone.lua");
        table.insert(env.PrefabFiles, "mone/mine/pheromonestone");
    end
end

--[[ AUXmods ]]
-- 我需要思考一个问题，AddPrefabPostInit 类似的函数，先不说其他模组，就说我着一个模组
-- 加入后执行的一个没有 hook，而是直接覆盖掉了。那肯定会出问题吧？
-- 因此我认为 AUXmods 部分应该也必须放在 modmain.lua 末尾加载？
-- 好麻烦，所有我认为应该养成一个习惯。任何情况下，只要是修改的函数，必须hook。多少会好一点！
do
    -- 大杂烩
    env.modimport("modmain/hodgepodge.lua");

    -- true、false、1
    if config_data.container_removable then
        env.modimport("modmain/AUXmods/container_removable.lua");
    end

    if config_data.chests_arrangement then
        env.modimport("modmain/AUXmods/chests_arrangement.lua");
    end

    if config_data.current_date then
        env.modimport("modmain/AUXmods/current_date.lua");
    end

    if config_data.backpacks_light then
        env.modimport("modmain/AUXmods/backpacks_light.lua");
    end

    if config_data.extra_equip_slots then
        env.modimport("modmain/AUXmods/extra_equip_slots.lua");
    end

    if config_data.trap_auto_reset then
        env.modimport("modmain/AUXmods/trap_auto_reset.lua");
    end

    if config_data.wathgrithr_vegetarian ~= 0 then
        env.modimport("modmain/AUXmods/wathgrithr_vegetarian.lua");
    end
end

--[[ Debug ]]
do
    if API.isDebug(env) then
        -- looktietu
        if env.GetModConfigData("looktietu") then
            env.modimport("modmain/AUXmods/looktietu.lua");
        end
        -- show mod folder name
        --if env.GetModConfigData("show_mod_folder_name") then
        --    env.modimport("modmain/AUXmods/show_mod_folder_name.lua");
        --end
        -- todo
        if env.GetModConfigData("todo") then
            env.modimport("modmain/AUXmods/todo.lua");
        end
    end
end











