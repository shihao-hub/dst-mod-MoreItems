---
--- @author zsh in 2023/2/2 21:08
---

local config_data = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA;

local data = {
    --["ÖĞ¿ÕÊ÷×®"] = {
    --    CanMake = config_data.catcoonden,
    --    fn = function()
    --        return "catcoonden_placer", "catcoon_den", "catcoon_den", "idle";
    --    end
    --},
    --["¸ß½ÅÄñ³²Ñ¨"] = {
    --    CanMake = config_data.tallbirdnest,
    --    fn = function()
    --        return "tallbirdnest_placer", "egg", "tallbird_egg", "eggnest";
    --    end
    --},
    --["òÒòõ¹í³²Ñ¨"] = {
    --    CanMake = config_data.slurtlehole,
    --    fn = function()
    --        return "slurtlehole_placer", "slurtle_mound", "slurtle_mound", "idle";
    --    end
    --},
    --["É±ÈË·ä³²Ñ¨"] = {
    --    CanMake = config_data.wasphive,
    --    fn = function()
    --        return "wasphive_placer", "wasphive", "wasphive", "cocoon_small";
    --    end
    --},
    --["·ä³²"] = {
    --    CanMake = config_data.beehive,
    --    fn = function()
    --        return "beehive_placer", "beehive", "beehive", "cocoon_small";
    --    end
    --},
    --["ºï×Ó"] = {
    --    CanMake = config_data.monkeybarrel,
    --    fn = function()
    --        return "monkeybarrel_placer", "barrel", "monkey_barrel", "idle";
    --    end
    --},


    ["³ØÌÁ1"] = {
        CanMake = config_data.ponds,
        fn = function()
            return "pond_placer", "marsh_tile", "marsh_tile", "idle", true;
        end
    },
    ["³ØÌÁ2"] = {
        CanMake = config_data.ponds,
        fn = function()
            return "pond_cave_placer", "marsh_tile", "marsh_tile", "idle_cave", true; -- µÚÎå¸ö±äÁ¿ÉèÖÃĞı×ª·½Ïò
        end
    },
    ["³ØÌÁ3"] = {
        CanMake = config_data.ponds,
        fn = function()
            return "pond_mos_placer", "marsh_tile", "marsh_tile", "idle_mos", true;
        end
    },

    ["ÕÊÅñ¾í"] = {
        CanMake = false,
        fn = function()
            return "pond_mos_placer", "marsh_tile", "marsh_tile", "idle_mos", true;
        end
    },


    --["Ïã½¶Ê÷"] = {
    --    CanMake = config_data.cave_banana_tree,
    --    fn = function()
    --        return "cave_banana_tree_placer", "cave_banana_tree", "cave_banana_tree", "idle_loop";
    --    end
    --},


    ["ÀÏÄÌÄÌµÄÁÀÈâ¼Ü"] = {
        CanMake = config_data.meatrack_hermit,
        fn = function()
            return "meatrack_hermit_placer", "meatrack_hermit", "meatrack_hermit", "idle_empty";
        end
    },
    ["ÀÏÄÌÄÌµÄ·äÏä"] = {
        CanMake = config_data.beebox_hermit,
        fn = function()
            return "beebox_hermit_placer", "bee_box_hermitcrab", "bee_box_hermitcrab", "idle";
        end
    },


    --["´óÀíÊ¯Ê÷"] = {
    --    CanMake = config_data.marbletree,
    --    fn = function()
    --        return "marbletree_placer", "marble_trees", "marble_trees", "full_1";
    --    end
    --},
    --["ºìÄ¢¹½"] = {
    --    CanMake = config_data.red_mushroom,
    --    fn = function()
    --        return "red_mushroom_placer", "mushrooms", "mushrooms", "red";
    --    end
    --},
    --["ÂÌÄ¢¹½"] = {
    --    CanMake = config_data.green_mushroom,
    --    fn = function()
    --        return "green_mushroom_placer", "mushrooms", "mushrooms", "green";
    --    end
    --},
    --["À¶Ä¢¹½"] = {
    --    CanMake = config_data.blue_mushroom,
    --    fn = function()
    --        return "blue_mushroom_placer", "mushrooms", "mushrooms", "blue";
    --    end
    --},
    --["ºúÂÜ²·"] = {
    --    CanMake = config_data.carrot_planted,
    --    fn = function()
    --        return "carrot_planted_placer", "carrot", "carrot", "planted";
    --    end
    --},
    --["¶àÈâÖ²Îï"] = {
    --    CanMake = config_data.succulent_plant,
    --    fn = function()
    --        return "succulent_plant_placer", "succulent", "succulent", "idle";
    --    end
    --},
}

local placers = {};

for k, v in pairs(data) do
    if v.CanMake then
        table.insert(placers, MakePlacer(v.fn()));
    end
end

return unpack(placers);