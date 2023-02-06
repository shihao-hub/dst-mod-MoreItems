---
--- @author zsh in 2023/1/14 20:26
---


--[[ Show Me ]]
do
    local comm = { "treasurechest", true };
    ---@type table<string,table[]>
    local t = {
        ["mone_backpack"] = comm,
        ["mone_piggyback"] = comm,
        ["mone_piggybag"] = comm,
        ["mone_firesuppressor"] = comm,
        ["mone_treasurechest"] = comm,
        ["mone_dragonfly_chest"] = comm,
        ["mone_icebox"] = comm,
        ["mone_saltbox"] = comm,
        ["mone_wardrobe"] = comm,

        ["mone_arborist"] = comm,
        ["mone_nightspace_cape"] = comm,
        ["mone_seasack"] = comm,
        ["mone_storage_bag"] = comm,
        ["mone_waterchest"] = comm,
        ["mone_seedpouch"] = comm,
    };

    --遍历已开启的mod
    for _, mod in pairs(ModManager.mods) do
        if mod and mod.SHOWME_STRINGS then
            for k, v in pairs(t) do
                if v[2] then
                    mod.postinitfns.PrefabPostInit[k] = mod.postinitfns.PrefabPostInit[v[1]];
                end
            end
        end
    end

    TUNING.MONITOR_CHESTS = TUNING.MONITOR_CHESTS or {};
    for k, v in pairs(t) do
        if v[2] then
            TUNING.MONITOR_CHESTS[k] = true;
        end
    end
end


--[[ 智能箱子 ]]
do
    for _, p in ipairs({
        "mone_treasurechest", "mone_dragonfly_chest",
        --"mone_icebox", "mone_saltbox"
    }) do
        env.AddPrefabPostInit(p, function(inst)
            if not TheWorld.ismastersim then
                return inst;
            end
            if TUNING.SMART_SIGN_DRAW_ENABLE then
                SMART_SIGN_DRAW(inst);
            end
        end)
    end
end

--[[ 能力勋章 ]]
do
    STRINGS.NAMES[("mone_buff_bw_attack"):upper()] = "惠灵顿风干牛排";
    STRINGS.NAMES[("mone_buff_hhs_work"):upper()] = "蜜汁大肉棒";
end