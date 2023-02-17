---
--- @author zsh in 2023/1/8 17:34
---


local API = require("chang_mone.dsts.API");
local BALANCE = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.BALANCE;

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
-- 添加新的制作栏
local RecipeTabs = {};

-- 新贴图的除食物类的物品
local key1 = "more_items1";
RecipeTabs[key1] = {
    filter_def = {
        name = "MONE_MORE_ITEMS1",
        atlas = "images/inventoryimages.xml",
        image = "amulet.tex"
    },
    index = nil
}
STRINGS.UI.CRAFTING_FILTERS[RecipeTabs[key1].filter_def.name] = "更多物品·一"
AddRecipeFilter(RecipeTabs[key1].filter_def, RecipeTabs[key1].index)

-- 原版物品修改
local key2 = "more_items2";
RecipeTabs[key2] = {
    filter_def = {
        name = "MONE_MORE_ITEMS2",
        atlas = "images/inventoryimages.xml",
        image = "blueamulet.tex"
    },
    index = nil
}
STRINGS.UI.CRAFTING_FILTERS[RecipeTabs[key2].filter_def.name] = "更多物品·二"
AddRecipeFilter(RecipeTabs[key2].filter_def, RecipeTabs[key2].index)

-- 新贴图的食物类物品
local key3 = "more_items3";
RecipeTabs[key3] = {
    filter_def = {
        name = "MONE_MORE_ITEMS3",
        atlas = "images/inventoryimages.xml",
        image = "greenamulet.tex"
    },
    index = nil
}
STRINGS.UI.CRAFTING_FILTERS[RecipeTabs[key3].filter_def.name] = "更多物品·三"
AddRecipeFilter(RecipeTabs[key3].filter_def, RecipeTabs[key3].index)

-- 更多物品扩展包
local key4 = "more_items4";
RecipeTabs[key4] = {
    filter_def = {
        name = "MONE_MORE_ITEMS4",
        atlas = "images/inventoryimages.xml",
        image = "orangeamulet.tex"
    },
    index = nil
}
STRINGS.UI.CRAFTING_FILTERS[RecipeTabs[key4].filter_def.name] = "更多物品·扩展包"
AddRecipeFilter(RecipeTabs[key4].filter_def, RecipeTabs[key4].index)


---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------

local Recipes = {}
local Recipes_Locate = {};

Recipes_Locate["mone_spear_poison"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__spear_poison") ~= false,
    name = "mone_spear_poison",
    ingredients = BALANCE and {
        Ingredient("spear", 2), Ingredient("goldnugget", 5)
    } or {
        Ingredient("spear", 1), Ingredient("goldnugget", 2)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        --atlas = "images/inventoryimages/mandrake_staff.xml",
        --image = "mandrake_staff.tex"
        atlas = "images/DLC0002/inventoryimages.xml",
        image = "spear_poison.tex"
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_harvester_staff"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__harvester_staff") ~= false,
    name = "mone_harvester_staff",
    ingredients = BALANCE and {
        Ingredient("twigs", 4), Ingredient("cutgrass", 4)--, Ingredient("flint", 2)
    } or {
        Ingredient("twigs", 2), Ingredient("cutgrass", 2)--, Ingredient("flint", 1)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        --atlas = "images/inventoryimages/mandrake_staff.xml",
        --image = "mandrake_staff.tex"
        atlas = "images/DLC0002/inventoryimages.xml",
        image = "machete.tex"
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_harvester_staff_gold"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__harvester_staff") ~= false,
    name = "mone_harvester_staff_gold",
    ingredients = BALANCE and {
        Ingredient("twigs", 6), Ingredient("cutgrass", 6), Ingredient("goldnugget", 2)
    } or {
        Ingredient("twigs", 3), Ingredient("cutgrass", 3), Ingredient("goldnugget", 1)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        --atlas = "images/inventoryimages/mandrake_staff.xml",
        --image = "mandrake_staff.tex"
        atlas = "images/DLC0002/inventoryimages.xml",
        image = "goldenmachete.tex"
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_halberd"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__halberd") ~= false,
    name = "mone_halberd",
    ingredients = BALANCE and {
        Ingredient("goldenaxe", 1), Ingredient("goldenpickaxe", 1), Ingredient("hammer", 1),
        Ingredient("marble", 5)
    } or {
        Ingredient("goldenaxe", 1), Ingredient("goldenpickaxe", 1), Ingredient("hammer", 1),
        Ingredient("marble", 2)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/DLC0003/inventoryimages.xml",
        image = "halberd.tex"
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_pith"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__pith") ~= false,
    name = "mone_pith",
    ingredients = BALANCE and {
        Ingredient("cutgrass", 6), Ingredient("twigs", 4)
    } or {
        Ingredient("cutgrass", 6), Ingredient("twigs", 4)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        --atlas = "images/inventoryimages/mandrake_staff.xml",
        --image = "mandrake_staff.tex"
        atlas = "images/DLC0003/inventoryimages.xml",
        image = "pithhat.tex"
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_gashat"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__gashat") ~= false,
    name = "mone_gashat",
    ingredients = BALANCE and {
        Ingredient("green_cap", 20), Ingredient("nightmarefuel", 6), Ingredient("silk", 8),
    } or {
        Ingredient("green_cap", 10), Ingredient("nightmarefuel", 3), Ingredient("silk", 4),
    },
    tech = TECH.MAGIC_THREE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/DLC0003/inventoryimages.xml",
        image = "gashat.tex"
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_double_umbrella"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__double_umbrella") ~= false,
    name = "mone_double_umbrella",
    ingredients = BALANCE and {
        Ingredient("goose_feather", 25), Ingredient("umbrella", 1), Ingredient("strawhat", 1)
    } or {
        Ingredient("goose_feather", 15), Ingredient("umbrella", 1), Ingredient("strawhat", 1)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/DLC0002/inventoryimages.xml",
        image = "double_umbrellahat.tex"
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_brainjelly"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__brainjelly") ~= false,
    name = "mone_brainjelly",
    ingredients = BALANCE and {
        Ingredient("walrushat", 2), Ingredient("beefalohat", 2), Ingredient("beargervest", 2),
        Ingredient("greengem", 2), Ingredient("opalpreciousgem", 2)
    } or {
        Ingredient("walrushat", 1), Ingredient("beefalohat", 1), Ingredient("beargervest", 1),
        Ingredient("greengem", 1)
    },
    tech = TECH.MAGIC_THREE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/DLC0002/inventoryimages.xml",
        image = "brainjellyhat.tex"
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_bathat"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__bathat") ~= false,
    name = "mone_bathat",
    ingredients = BALANCE and {
        Ingredient("batwing", 60), Ingredient("silk", 60)
    } or {
        Ingredient("batwing", 30), Ingredient("silk", 30),
    },
    --tech = TECH.NONE,
    tech = TECH.ANCIENT_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = BALANCE and true or nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/DLC0003/inventoryimages.xml",
        image = "bathat.tex"
    },
    filters = BALANCE and {
        "CRAFTING_STATION"
    } or {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_wathgrithr_box"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__wathgrithr_box") ~= false,
    name = "mone_wathgrithr_box",
    ingredients = {
        Ingredient("wathgrithrhat", 2), Ingredient("papyrus", 2), Ingredient("featherpencil", 2)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = "battlesinger",
        atlas = "images/inventoryimages/mone_wathgrithr_box.xml",
        image = "mone_wathgrithr_box.tex"
    },
    filters = {
        "CHARACTER"
    }
};

Recipes_Locate["mone_wanda_box"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__wanda_box") ~= false,
    name = "mone_wanda_box",
    ingredients = {
        Ingredient("twigs", 12), Ingredient("cutgrass", 12), Ingredient("goldnugget", 4)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = "clockmaker",
        atlas = "images/inventoryimages/mone_wanda_box.xml",
        image = "mone_wanda_box.tex"
    },
    filters = {
        "CHARACTER"
    }
};

Recipes_Locate["mone_storage_bag"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__storage_bag") ~= false,
    name = "mone_storage_bag",
    ingredients = BALANCE and {
        Ingredient("papyrus", 3), Ingredient("petals", 6)
    } or {
        Ingredient("papyrus", 1), Ingredient("petals", 3)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/DLC0002/inventoryimages.xml",
        image = "thatchpack.tex"
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_piggybag"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__piggybag") ~= false,
    name = "mone_piggybag",
    ingredients = BALANCE and {
        Ingredient("pigskin", 15)
    } or {
        Ingredient("pigskin", 10)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages/mone_piggybag.xml",
        image = "mone_piggybag.tex"
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_waterchest_inv"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__waterchest") ~= false,
    name = "mone_waterchest_inv",
    ingredients = BALANCE and {
        Ingredient("boards", 40), Ingredient("bluegem", 20), Ingredient("minotaurhorn", 4)
    } or {
        Ingredient("boards", 20), Ingredient("bluegem", 10), Ingredient("minotaurhorn", 2)
    },
    tech = TECH.ANCIENT_TWO, -- ?
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = BALANCE and true or nil, -- 所以这个到底啥意思？nounlock？锁住？感觉没啥用呀。
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/DLC0002/inventoryimages.xml",
        image = "waterchest.tex"
    },
    filters = BALANCE and {
        "CRAFTING_STATION"
    } or {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_seasack"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__seasack") ~= false,
    name = "mone_seasack",
    ingredients = BALANCE and {
        Ingredient("kelp", 40), Ingredient("rope", 10)
    } or {
        Ingredient("kelp", 20), Ingredient("rope", 5)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/DLC0003/inventoryimages.xml",
        image = "seasack.tex"
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_nightspace_cape"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__nightspace_cape") ~= false,
    name = "mone_nightspace_cape",
    ingredients = BALANCE and {
        Ingredient("armorskeleton", 2), Ingredient("malbatross_feather", 20), Ingredient("greengem", 2)
    } or {
        Ingredient("armorskeleton", 1), Ingredient("malbatross_feather", 10), Ingredient("greengem", 1)
    },
    tech = TECH.MAGIC_THREE,
    --tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages/ndnr_armorvortexcloak.xml",
        image = "ndnr_armorvortexcloak.tex"
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_chiminea"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__chiminea") ~= false,
    name = "mone_chiminea",
    ingredients = BALANCE and {
        Ingredient("boards", 4), Ingredient("cutstone", 2)
    } or {
        Ingredient("boards", 2), Ingredient("cutstone", 1)
    },
    tech = TECH.NONE,
    config = {
        placer = "mone_chiminea_placer",
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/DLC0002/inventoryimages.xml",
        image = "chiminea.tex"
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_arborist"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__arborist") ~= false,
    name = "mone_arborist",
    ingredients = BALANCE and {
        Ingredient("pinecone", 30), Ingredient("acorn", 30), Ingredient("marblebean", 15)
    } or {
        Ingredient("pinecone", 20), Ingredient("acorn", 20), Ingredient("marblebean", 5)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mone_arborist_placer",
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/DLC0002/inventoryimages.xml",
        image = "sand_castle.tex"
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_city_lamp"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__city_lamp") ~= false,
    name = "mone_city_lamp",
    ingredients = BALANCE and {
        Ingredient("lantern", 1), Ingredient("transistor", 2), Ingredient("cutstone", 2)
    } or {
        Ingredient("lantern", 1), Ingredient("transistor", 1), Ingredient("cutstone", 1)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mone_city_lamp_placer",
        min_spacing = 1,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/DLC0003/inventoryimages.xml",
        image = "city_lamp.tex"
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_pheromonestone"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__pheromonestone") ~= false,
    name = "mone_pheromonestone",
    ingredients = BALANCE and {
        Ingredient("opalpreciousgem", 2), Ingredient("greengem", 4),
        Ingredient("bluegem", 20), Ingredient("redgem", 20),
    } or {
        Ingredient("greengem", 2),
        Ingredient("bluegem", 10), Ingredient("redgem", 10),
    },
    tech = TECH.ANCIENT_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = BALANCE and true or nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/DLC0003/inventoryimages.xml",
        image = "pheromonestone.tex"
    },
    filters = BALANCE and {
        "CRAFTING_STATION"
    } or {
        "MONE_MORE_ITEMS1"
    }
};

Recipes_Locate["mone_walking_stick"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__walking_stick") ~= false,
    name = "mone_walking_stick",
    ingredients = BALANCE and {
        Ingredient("cutgrass", 8), Ingredient("twigs", 8), Ingredient("goldnugget", 4)
    } or {
        Ingredient("cutgrass", 4), Ingredient("twigs", 4), Ingredient("goldnugget", 2)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/DLC0003/inventoryimages_2.xml",
        image = "walkingstick.tex"
    },
    filters = {
        "MONE_MORE_ITEMS1"
    }
};

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------

Recipes_Locate["mone_backpack"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__backpack") ~= false,
    name = "mone_backpack",
    ingredients = BALANCE and {
        Ingredient("cutgrass", 12), Ingredient("twigs", 12), Ingredient("goldnugget", 4),
    } or {
        Ingredient("cutgrass", 6), Ingredient("twigs", 6)
    },
    tech = TECH.SCIENCE_ONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages1.xml",
        image = "backpack.tex"
    },
    filters = {
        "MONE_MORE_ITEMS2"
    }
};

Recipes_Locate["mone_piggyback"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__piggyback") ~= false,
    name = "mone_piggyback",
    ingredients = BALANCE and {
        Ingredient("pigskin", 40), Ingredient("silk", 40), Ingredient("rope", 40)
    } or {
        Ingredient("pigskin", 20), Ingredient("silk", 20), Ingredient("rope", 20)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages.xml",
        image = "piggyback.tex"
    },
    filters = {
        "MONE_MORE_ITEMS2"
    }
};

Recipes_Locate["mone_candybag"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__candybag") ~= false,
    name = "mone_candybag",
    ingredients = BALANCE and {
        Ingredient("cutgrass", 10),
        Ingredient("twigs", 10),
        Ingredient("flint", 10),
        Ingredient("rocks", 10),
        Ingredient("goldnugget", 4),
        Ingredient("log", 10),
    } or {
        Ingredient("cutgrass", 10),
        Ingredient("twigs", 10),
        Ingredient("flint", 10),
        Ingredient("rocks", 10),
        Ingredient("goldnugget", 2),
        Ingredient("log", 10),
    },
    tech = TECH.SCIENCE_ONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages.xml",
        image = "candybag.tex"
    },
    filters = {
        "MONE_MORE_ITEMS2"
    }
};

Recipes_Locate["mone_seedpouch"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__mone_seedpouch") ~= false,
    name = "mone_seedpouch",
    ingredients = BALANCE and {
        Ingredient("bundlewrap", 8), Ingredient("gears", 8), Ingredient("seeds", 40),
        Ingredient("goldnugget", 10)
    } or {
        Ingredient("bundlewrap", 4), Ingredient("gears", 4), Ingredient("seeds", 20),
        Ingredient("goldnugget", 5)
    },
    tech = TECH.SCIENCE_TWO,
    -- tech = TECH.MAGIC_THREE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages2.xml",
        image = "seedpouch.tex"
    },
    filters = {
        "MONE_MORE_ITEMS2"
    }
};

local MCB_capability = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.mone_chests_boxs_capability;

Recipes_Locate["mone_treasurechest"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__chests_boxs") ~= false,
    name = "mone_treasurechest",
    ingredients = MCB_capability and {
        Ingredient("boards", 9)
    } or {
        Ingredient("boards", 6)
    },
    tech = TECH.SCIENCE_ONE,
    config = {
        placer = "mone_treasurechest_placer",
        min_spacing = 1,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages.xml",
        image = "treasurechest.tex"
    },
    filters = {
        "MONE_MORE_ITEMS2"
    }
};

Recipes_Locate["mone_dragonflychest"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__chests_boxs") ~= false,
    name = "mone_dragonflychest",
    ingredients = MCB_capability and {
        Ingredient("dragon_scales", 2), Ingredient("boards", 8), Ingredient("goldnugget", 20)
    } or {
        Ingredient("dragon_scales", 1), Ingredient("boards", 6), Ingredient("goldnugget", 10)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mone_dragonflychest_placer",
        min_spacing = 1.5,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages.xml",
        image = "dragonflychest.tex"
    },
    filters = {
        "MONE_MORE_ITEMS2"
    }
};

Recipes_Locate["mone_icebox"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__chests_boxs") ~= false,
    name = "mone_icebox",
    ingredients = MCB_capability and {
        Ingredient("goldnugget", 6), Ingredient("gears", 3), Ingredient("cutstone", 3)
    } or {
        Ingredient("goldnugget", 4), Ingredient("gears", 2), Ingredient("cutstone", 2)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mone_icebox_placer",
        min_spacing = 1.5,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages.xml",
        image = "icebox.tex"
    },
    filters = {
        "MONE_MORE_ITEMS2"
    }
};

Recipes_Locate["mone_saltbox"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__chests_boxs") ~= false,
    name = "mone_saltbox",
    ingredients = MCB_capability and {
        Ingredient("saltrock", 30), Ingredient("bluegem", 3), Ingredient("cutstone", 3)
    } or {
        Ingredient("saltrock", 20), Ingredient("bluegem", 2), Ingredient("cutstone", 2)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mone_saltbox_placer",
        min_spacing = 1.5,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages2.xml",
        image = "saltbox.tex"
    },
    filters = {
        "MONE_MORE_ITEMS2"
    }
};

Recipes_Locate["mone_firesuppressor"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__firesuppressor") ~= false,
    name = "mone_firesuppressor",
    ingredients = BALANCE and {
        Ingredient("gears", 2), Ingredient("transistor", 2), Ingredient("boards", 10)
    } or {
        Ingredient("gears", 2), Ingredient("transistor", 2), Ingredient("boards", 10)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mone_firesuppressor_placer",
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages.xml",
        image = "firesuppressor.tex"
    },
    filters = {
        "MONE_MORE_ITEMS2"
    }
};

Recipes_Locate["mone_moondial"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__moondial") ~= false,
    name = "mone_moondial",
    ingredients = BALANCE and {
        Ingredient("bluemooneye", 1), Ingredient("bluegem", 2), Ingredient("ice", 10)
    } or {
        Ingredient("bluemooneye", 1), Ingredient("bluegem", 2), Ingredient("ice", 10)
    },
    --tech = TECH.SCIENCE_TWO,
    tech = TECH.MAGIC_THREE,
    config = {
        placer = "mone_moondial_placer",
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages.xml",
        image = "moondial.tex"
    },
    filters = {
        "MONE_MORE_ITEMS2"
    }
};

Recipes_Locate["mone_wardrobe"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__wardrobe") ~= false,
    name = "mone_wardrobe",
    ingredients = BALANCE and {
        Ingredient("boards", 12), Ingredient("cutgrass", 3)
    } or {
        Ingredient("boards", 12), Ingredient("cutgrass", 3)
    },
    tech = TECH.SCIENCE_TWO,
    -- tech = TECH.MAGIC_THREE,
    config = {
        placer = "mone_wardrobe_placer",
        min_spacing = 1.5,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages.xml",
        image = "wardrobe.tex"
    },
    filters = {
        "MONE_MORE_ITEMS2"
    }
};

Recipes_Locate["mone_garlic_structure"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__garlic_structure") ~= false,
    name = "mone_garlic_structure",
    ingredients = BALANCE and {
        Ingredient("garlic", 5), Ingredient("garlic_seeds", 3), Ingredient("beeswax", 1)
    } or {
        Ingredient("garlic", 5), Ingredient("garlic_seeds", 3), Ingredient("beeswax", 1)
    },
    tech = TECH.SCIENCE_TWO,
    config = {
        placer = "mone_garlic_structure_placer",
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages/garlic_bat.xml",
        image = "garlic_bat.tex"
    },
    filters = {
        "MONE_MORE_ITEMS2"
    }
};

Recipes_Locate["mone_waterballoon"] = true;
if not BALANCE then
    Recipes[#Recipes + 1] = {
        CanMake = env.GetModConfigData("__waterballoon") ~= false,
        name = "mone_waterballoon",
        ingredients = {
            Ingredient("greengem", 1)
        },
        tech = TECH.MAGIC_THREE,
        config = {
            placer = nil,
            min_spacing = nil,
            nounlock = nil,
            numtogive = BALANCE and 2 or 3,
            builder_tag = nil,
            atlas = "images/inventoryimages.xml",
            image = "waterballoon.tex"
        },
        filters = {
            "MONE_MORE_ITEMS2"
        }
    };
end

--Recipes_Locate["mone_beef_bell"] = true;
--Recipes[#Recipes + 1] = {
--    CanMake = env.GetModConfigData("__beef_bell") ~= false,
--    name = "mone_beef_bell",
--    ingredients = {
--        Ingredient("goldnugget", 15), Ingredient("flint", 5)
--    },
--    tech = TECH.NONE,
--    config = {
--        placer = nil,
--        min_spacing = nil,
--        nounlock = nil,
--        numtogive = 1,
--        builder_tag = nil,
--        atlas = "images/inventoryimages1.xml",
--        image = "beef_bell.tex"
--    },
--    filters = {
--        "MONE_MORE_ITEMS2"
--    }
--};

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------

Recipes_Locate["mone_chicken_soup"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__mone_chicken_soup") ~= false,
    name = "mone_chicken_soup",
    ingredients = BALANCE and {
        Ingredient("drumstick", 1)
    } or {
        Ingredient("drumstick", 1)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 1,
        builder_tag = nil,
        atlas = "images/foodimages/mone_chicken_soup.xml",
        image = "mone_chicken_soup.tex"
    },
    filters = {
        "MONE_MORE_ITEMS3"
    }
};

Recipes_Locate["mone_lifeinjector_vb"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__mone_lifeinjector_vb") ~= false,
    name = "mone_lifeinjector_vb",
    ingredients = BALANCE and {
        Ingredient("spoiled_food", 10) -- 20
    } or {
        Ingredient("spoiled_food", 5)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 1,
        builder_tag = nil,
        atlas = "images/foodimages/mone_lifeinjector_vb.xml",
        image = "mone_lifeinjector_vb.tex"
    },
    filters = {
        "MONE_MORE_ITEMS3"
    }
};

Recipes_Locate["mone_guacamole"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__mone_guacamole") ~= false,
    name = "mone_guacamole",
    ingredients = {
        Ingredient("mole", 1), Ingredient("lightbulb", 10)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 2,
        builder_tag = nil,
        atlas = "images/inventoryimages.xml",
        image = "guacamole.tex"
    },
    filters = {
        "MONE_MORE_ITEMS3"
    }
};

Recipes_Locate["mone_honey_ham_stick"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__mone_honey_ham_stick") ~= false,
    name = "mone_honey_ham_stick",
    ingredients = {
        Ingredient("hambat", 1), Ingredient("honey", 10), Ingredient("green_cap", 3)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 1,
        builder_tag = nil,
        atlas = "images/foodimages/bs_food_58.xml",
        image = "bs_food_58.tex"
    },
    filters = {
        "MONE_MORE_ITEMS3"
    }
};

Recipes_Locate["mone_beef_wellington"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__mone_beef_wellington") ~= false,
    name = "mone_beef_wellington",
    ingredients = BALANCE and {
        Ingredient("cookedmeat", 20), Ingredient("beefalowool", 25), Ingredient("horn", 2)
    } or {
        Ingredient("cookedmeat", 10), Ingredient("beefalowool", 15), Ingredient("horn", 1)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = BALANCE and 4 or 3,
        builder_tag = nil,
        atlas = "images/foodimages/mone_beef_wellington.xml",
        image = "mone_beef_wellington.tex"
    },
    filters = {
        "MONE_MORE_ITEMS3"
    }
};

Recipes_Locate["mone_poisonblam"] = true;
Recipes[#Recipes + 1] = {
    CanMake = env.GetModConfigData("__poisonblam") ~= false,
    name = "mone_poisonblam",
    ingredients = {
        Ingredient(CHARACTER_INGREDIENT.HEALTH, 10)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = 1,
        builder_tag = nil,
        atlas = "images/DLC0003/inventoryimages.xml",
        image = "poisonbalm.tex"
    },
    filters = {
        "MONE_MORE_ITEMS3"
    }
};

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
-- 此处这几个物品中的某一个或几个导致的三维锁定的严重bug的出现！！！
if API.isDebug(env) and env.GetModConfigData("debug_switch") then
    --[[ 以后加个火焰在图层上方 ]]
    Recipes_Locate["mone_relic_2"] = true;
    Recipes[#Recipes + 1] = {
        CanMake = env.GetModConfigData("__relic_2") ~= false,
        name = "mone_relic_2",
        ingredients = {
            Ingredient("redgem", 2), Ingredient("goldnugget", 10)
        },
        tech = TECH.SCIENCE_TWO,
        config = {
            placer = "mone_relic_2_placer",
            min_spacing = 1,
            nounlock = nil,
            numtogive = nil,
            builder_tag = nil,
            atlas = "images/DLC0003/inventoryimages.xml",
            image = "relic_2.tex"
        },
        filters = {
            "MONE_MORE_ITEMS1"
        }
    };

    Recipes_Locate["mone_bushhat"] = true;
    Recipes[#Recipes + 1] = {
        CanMake = env.GetModConfigData("__bushhat") ~= false,
        name = "mone_bushhat",
        ingredients = BALANCE and {
            Ingredient("dug_berrybush", 25) -- 一个大地图变异的大概39个，没变异的213、150个。。。
        } or {
            Ingredient("dug_berrybush", 15)
        },
        tech = TECH.NONE,
        config = {
            placer = nil,
            min_spacing = nil,
            nounlock = nil,
            numtogive = 1,
            builder_tag = nil,
            atlas = "images/inventoryimages.xml",
            image = "bushhat.tex"
        },
        filters = {
            "MONE_MORE_ITEMS2"
        }
    };

    Recipes_Locate["pond"] = true; -- pond、pond_cave、pond_mos
    Recipes[#Recipes + 1] = {
        CanMake = env.GetModConfigData("__ponds") ~= false,
        name = "pond",
        ingredients = BALANCE and {
            Ingredient("pondfish", 30)
        } or {
            Ingredient("pondfish", 15)
        },
        tech = TECH.NONE,
        config = {
            placer = "pond_placer",
            min_spacing = 1.5,
            nounlock = nil,
            numtogive = nil,
            builder_tag = nil,
            atlas = "minimap/minimap_data.xml",
            image = "pond.png"
        },
        filters = {
            "MONE_MORE_ITEMS4"
        }
    };

    Recipes_Locate["pond_cave"] = true; -- pond、pond_cave、pond_mos
    Recipes[#Recipes + 1] = {
        CanMake = env.GetModConfigData("__ponds") ~= false,
        name = "pond_cave",
        ingredients = BALANCE and {
            Ingredient("pondfish", 30)
        } or {
            Ingredient("pondfish", 15)
        },
        tech = TECH.NONE,
        config = {
            placer = "pond_cave_placer",
            min_spacing = 1.5,
            nounlock = nil,
            numtogive = nil,
            builder_tag = nil,
            atlas = "minimap/minimap_data.xml",
            image = "pond_cave.png"
        },
        filters = {
            "MONE_MORE_ITEMS4"
        }
    };

    Recipes_Locate["pond_mos"] = true; -- pond、pond_cave、pond_mos
    Recipes[#Recipes + 1] = {
        CanMake = env.GetModConfigData("__ponds") ~= false,
        name = "pond_mos",
        ingredients = BALANCE and {
            Ingredient("mosquito", 30)
        } or {
            Ingredient("pondfish", 15)
        },
        tech = TECH.NONE,
        config = {
            placer = "pond_mos_placer",
            min_spacing = 1.5,
            nounlock = nil,
            numtogive = nil,
            builder_tag = nil,
            atlas = "minimap/minimap_data.xml",
            image = "pond_mos.png"
        },
        filters = {
            "MONE_MORE_ITEMS4"
        }
    };

    Recipes_Locate["meatrack_hermit"] = true;
    Recipes[#Recipes + 1] = {
        CanMake = env.GetModConfigData("__meatrack_hermit") ~= false,
        name = "meatrack_hermit",
        ingredients = {
            Ingredient("twigs", 3), Ingredient("charcoal", 2), Ingredient("rope", 3)
        },
        tech = TECH.NONE,
        config = {
            placer = "meatrack_hermit_placer",
            min_spacing = 3.2,
            nounlock = nil,
            numtogive = nil,
            builder_tag = nil,
            atlas = "minimap/minimap_data.xml",
            image = "meatrack_hermit.png"
        },
        filters = {
            "MONE_MORE_ITEMS4"
        }
    };

    Recipes_Locate["beebox_hermit"] = true;
    Recipes[#Recipes + 1] = {
        CanMake = env.GetModConfigData("__beebox_hermit") ~= false,
        name = "beebox_hermit",
        ingredients = {
            Ingredient("boards", 2), Ingredient("honeycomb", 1), Ingredient("bee", 4)
        },
        tech = TECH.NONE,
        config = {
            placer = "beebox_hermit_placer",
            min_spacing = 3.2,
            nounlock = nil,
            numtogive = nil,
            builder_tag = nil,
            atlas = "minimap/minimap_data.xml",
            image = "beebox_hermitcrab.png"
        },
        filters = {
            "MONE_MORE_ITEMS4"
        }
    };
end

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
-- 全部设置成不要科技
if not TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.BALANCE then
    for _, v in pairs(Recipes) do
        v.tech = TECH.NONE;
    end
end

-- TEST
--for _, v in pairs(Recipes) do
--    v.filters = { "MONE_MORE_ITEMS1" };
--end

for _, v in pairs(Recipes) do
    if v.CanMake ~= false then
        env.AddRecipe2(v.name, v.ingredients, v.tech, v.config, v.filters);
    end
end
