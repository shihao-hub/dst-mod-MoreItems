---
--- @author zsh in 2023/1/8 5:50
---

-- 格式乱糟糟，懒得修改了

local L = (locale == "zh" or locale == "zht" or locale == "zhr") and true or false;

local __author = "心悦卿兮";
local __version = "1.3.3";

local folder_name = folder_name or ""; -- 淘宝的云服务器卖家没有导入其他文件，所以那边modinfo.lua会导入失败。

local info = {
    author = __author,
    forumthread = nil,
    --priority = -2 ^ 31,
    priority = 0, -- 如果开启了我的五格装备栏，优先级必须比能力勋章低。。能力勋章好像没判空。。。
    description = function(version, releaseTime, content)
        version = version or "1.0.0"
        releaseTime = releaseTime or "2023";
        content = content or '';
        return (L and "                                                  感谢你的订阅！\n"
                .. content .. "\n"
                .. "                                                【模组】：" .. folder_name .. "\n"
                .. "                                                【作者】：" .. __author .. "\n"
                .. "                                                【版本】：" .. version .. "\n"
                .. "                                                【时间】：" .. releaseTime .. "\n"
                or "                                                Thanks for subscribing!\n"
                .. content .. "\n"
                .. "                                                【mod    】：" .. folder_name .. "\n"
                .. "                                                【author 】：" .. __author .. "\n"
                .. "                                                【version】：" .. version .. "\n"
                .. "                                                【release】：" .. releaseTime .. "\n"
        );

    end,
    api_version = 10,
    icon = "modicon.tex";
    icon_atlas = "modicon.xml";
    dont_starve_compatible = true,
    reign_of_giants_compatible = false, -- 是否兼容巨人国
    dst_compatible = true
}

name = L and "更多物品" or "More Items";
version = __version;

-- emoji.lua + emoji_items.lua !!!
local content = [[
    󰀜󰀝󰀀󰀞󰀘󰀁󰀟󰀠󰀡󰀂
    󰀃󰀄󰀢󰀅󰀣󰀆󰀇󰀈󰀤󰀙
    󰀰󰀉󰀚󰀊󰀋󰀌󰀍󰀥󰀎󰀏
    󰀦󰀐󰀑󰀒󰀧󰀱󰀨󰀓󰀔󰀩
    󰀪󰀕󰀫󰀖󰀛󰀬󰀭󰀮󰀗󰀯
]];
description = info.description(version, "2023-01-08", content);

client_only_mod = false;
all_clients_require_mod = true;

server_filter_tags = { "更多物品", "More Items" };

author = info.author;
forumthread = info.forumthreadl
priority = info.priority;
api_version = info.api_version;
icon = info.icon;
icon_atlas = info.icon_atlas;
dont_starve_compatible = info.dont_starve_compatible;
reign_of_giants_compatible = info.reign_of_giants_compatible;
dst_compatible = info.dst_compatible;

local function Lang(sCh, sEn)
    return L and sCh or sEn;
end

local config = {
    template = function()
        return {
            name = "",
            label = "",
            hover = "",
            options = {
                {
                    description = "",
                    hover = "",
                    data = "0"
                }
            },
            default = "0"
        }
    end,
    addBlockLabel = function(label)
        return {
            name = "",
            label = label or "",
            hover = "",
            options = {
                {
                    description = "",
                    hover = "",
                    data = "0"
                }
            },
            default = "0"
        }
    end,
    option = function(description, data, hover)
        return {
            description = description or "",
            data = data,
            hover = hover or ""
        };
    end,
    OPEN = L and "开启" or "Open",
    CLOSE = L and "关闭" or "Close",
}

local option = config.option;

local function commonItems(name, label, hover)
    return { name = name, label = label, hover = hover or "", options = { option(config.OPEN, true), option(config.CLOSE, false), }, default = true };
end

configuration_options = {
    --config.addBlockLabel("Label_1"),
    --[[    {
            name = "language",
            label = L and "语言" or "Language",
            hover = "",
            options = {
                option(L and "中文简体" or "Simple Chinese", "zh"),
                option("English", "en"),
            },
            default = "zh"
        },]]
    {
        name = "balance",
        label = "内容平衡",
        hover = "制作物品需要不同科技等级和材料难度等。\n如：有些是boss掉落物。有些必须在远古科技台才能制作。", -- Lang("根据作者的想法平衡一下模组内容，诸如制作难度等", "Balance the content of the module according to the author's idea, such as crafting difficulty, etc"),
        options = {
            option(config.OPEN, true),
            option(config.CLOSE, false),
        },
        default = true
    },
    config.addBlockLabel(L and "辅助功能" or "auxiliary function"),
    {
        name = "backpacks_light",
        label = "󰀉 背包发光",
        hover = "装备背包时，夜间自动发光。\n反正已经很变态了，我还能再变态一点。",
        options = {
            option(config.OPEN, true, "轻易不要开，莫要衰减游戏寿命！"),
            option(config.CLOSE, false, "轻易不要开，莫要衰减游戏寿命！"),
        },
        default = false
    },
    {
        name = "extra_equip_slots",
        label = "󰀉 五格装备栏",
        hover = "(这是作者自己的，目前作者自己用起来是正常的)\n修复其他五格装备栏不能直接消耗箱子里的材料制作物品的bug，且兼容了很多其他模组的物品",
        options = {
            option(config.OPEN, true, "(但是！注意不要和同类模组一起使用)"),
            option(config.CLOSE, false, "(但是！注意不要和同类模组一起使用)"),
        },
        default = false
    },
    {
        name = "container_removable",
        label = "容器 UI 可以移动",
        hover = "如果你开启了本地模组：UI拖拽缩放镜像，该选项自动失效！\n建议订阅那个模组，挺好用的。",
        options = {
            option(config.OPEN, true, "右键按住可以移动，键盘 home 键复原"),
            option(config.CLOSE, false, "右键按住可以移动，键盘 home 键复原"),
            option("该功能仍生效", 1, "该功能仍生效，但是需要关闭那个模组的容器UI支持选项！"),
        },
        default = true
    },
    {
        name = "current_date",
        label = "屏幕上方显示当前时间",
        hover = "顾名思义，作者自己想用。",
        options = {
            option(config.OPEN, true),
            option(config.CLOSE, false),
        },
        default = true
    },
    {
        name = "chests_arrangement",
        label = "箱子冰箱等关闭后自动整理",
        hover = L and "箱子、龙鳞宝箱、冰箱、盐箱 + 豪华系列" or "Chest, Dragon scale treasure chest, refrigerator, salt chest",
        options = {
            option(config.OPEN, true),
            option(config.CLOSE, false),
        },
        default = true
    },

    config.addBlockLabel("模组功能设置"),
    {
        name = "arborist_light",
        label = "󰀉 树木栽培家发光",
        hover = "其实我还想加个自动灭火的，算了算了。",
        options = {
            option(config.OPEN, true, "轻易不要开，莫要衰减游戏寿命！"),
            option(config.CLOSE, false, "轻易不要开，莫要衰减游戏寿命！"),
        },
        default = false
    },
    {
        name = "mone_chests_boxs_capability",
        label = L and "豪华系列容器容量设置" or "Luxury Series container capacity Settings",
        hover = "16 or 25",
        options = {
            option("5x5", true),
            option("4x4", false),
        },
        default = true -- true 为 5x5
    },
    {
        name = "cane_gointo_mone_backpack",
        label = "步行手杖可以放入装备袋",
        hover = "没啥太大意义，就加个开关而已。\n如果你身上带太多装备袋，说不一定需要这个。",
        options = {
            option(config.OPEN, true),
            option(config.CLOSE, false),
        },
        default = true
    },
    {
        name = "mone_backpack_auto",
        label = "装备袋中的装备自动切换",
        hover = "装备损坏时，自动查找装备袋中有无同名装备，然后装备上。\n如果出现问题关闭该选项即可。",
        options = {
            option(config.OPEN, true, "此功能写于2023-01-19，采用的是覆盖法"),
            option(config.CLOSE, false, "此功能写于2023-01-19，采用的是覆盖法"),
        },
        default = true
    },
    {
        name = "mone_wardrobe_background",
        label = "你的装备柜格子有背景图片",
        hover = "",
        options = {
            option(config.OPEN, true),
            option(config.CLOSE, false),
        },
        default = true
    },
    {
        name = "greenamulet_pheromonestone",
        label = "󰀉 素石可以对建造护符使用",
        hover = "虽然素石已经很过分了。但是对建造护符使用的话那就更过分了。",
        options = {
            option(config.OPEN, true, "轻易不要开，莫要衰减游戏寿命！"),
            option(config.CLOSE, false, "轻易不要开，莫要衰减游戏寿命！"),
        },
        default = false
    },
    {
        name = "mone_wanda_box_itemtestfn_extra1",
        label = "倒走表可以放入旺达钟表盒",
        hover = "如果你开启了快捷键使用倒走表的相关模组的话，那倒是挺方便的。",
        options = {
            option(config.OPEN, true),
            option(config.CLOSE, false),
        },
        default = false
    },
    {
        name = "mone_wanda_box_itemtestfn_extra2",
        label = "裂缝表和溯源表可以放入旺达钟表盒",
        hover = "如果你开启了旺达的表可以命名的相关模组的话，那倒是挺方便的。",
        options = {
            option(config.OPEN, true),
            option(config.CLOSE, false),
        },
        default = false
    },
    --{
    --    name = "mone_storage_bag_no_remove", -- 不干了，太麻烦
    --    label = "保鲜袋耐久为0不消失",
    --    hover = "耐久为0时物品会全掉落，然后失去保鲜效果。",
    --    options = {
    --        option(config.OPEN, true),
    --        option(config.CLOSE, false),
    --    },
    --    default = false
    --},
    --{
    --    name = "mone_city_lamp_reskin",
    --    label = "路灯套皮",
    --    hover = "就是路灯可以换蘑菇灯或者菌伞灯的皮肤",
    --    options = {
    --        option(config.CLOSE, 0),
    --        option("蘑菇灯", 1),
    --        option("菌伞灯", 2),
    --    },
    --    default = 0
    --},
    --{
    --    name = "mone_waterchest_chartlet_change",
    --    label = "海上箱子贴图更换",
    --    hover = "",
    --    options = {
    --        option(config.OPEN, true),
    --        option(config.CLOSE, false),
    --    },
    --    default = true
    --},
    config.addBlockLabel("物品优先进容器相关设置"),
    {
        name = "IGICF",
        label = "开关",
        hover = "如果不习惯，关闭即可\n装备袋、保鲜袋、收纳袋、猪猪袋、海上箱子",
        options = {
            option(config.OPEN, true),
            option(config.CLOSE, false),
        },
        default = true
    },
    {
        name = "IGICF_mone_piggyback",
        label = "收纳袋",
        hover = "物品也会优先进入收纳袋？",
        options = {
            option(config.OPEN, true),
            option(config.CLOSE, false),
        },
        default = false
    },
    {
        name = "IGICF_waterchest_inv",
        label = "海上箱子",
        hover = "物品也会优先进入海上箱子？",
        options = {
            option(config.OPEN, true),
            option(config.CLOSE, false),
        },
        default = false
    },
    config.addBlockLabel("升级版·雪球发射机相关设置"),
    {
        name = "auto_sorter_mode",
        label = "模式",
        hover = "全自动：每隔一段时间帮忙捡起周围的东西并转移物品\n半自动：点击按钮捡起，关闭容器分拣",
        options = {
            option("灵活自动", 1,
                    "打开灭火器全自动；关闭灭火器半自动！(这有点白白耗燃料)"),
            option("全自动", 2),
            option("半自动", 3),
        },
        default = 1
    },
    {
        name = "auto_sorter_light",
        label = "󰀉 发光",
        hover = "夜晚自动发光，而且还能让作物在夜晚也能生长。",
        options = {
            option(config.OPEN, true, "轻易不要开，莫要衰减游戏寿命！"),
            option(config.CLOSE, false, "轻易不要开，莫要衰减游戏寿命！"),
        },
        default = false
    },
    {
        name = "auto_sorter_no_fuel",
        label = "󰀉 不消耗燃料",
        hover = "即：不会扣除燃料\n主要为了方便。",
        options = {
            option(config.OPEN, true),
            option(config.CLOSE, false),
        },
        default = false
    },
    {
        name = "auto_sorter_is_full",
        label = "全自动的时间间隔",
        hover = "间隔时间越长，越不占用电脑性能\n进一步优化：只有附近有人存在时才会执行功能！",
        options = {
            option("1s", 1),
            option("3s" or "", 3),
            option("5s" or "", 5),
            option("10s" or "", 10),
            option("20s" or "", 20),
        },
        default = 5
    },
    config.addBlockLabel(L and "取消某件物品及其相关内容" or "Cancel an item and its associated contents"),
    commonItems("__spear_poison", "󰀉 毒矛"),
    commonItems("__halberd", "多功能·戟"),
    commonItems("__walking_stick", "󰀉 临时加速手杖"),
    commonItems("__harvester_staff", "收割者的砍刀系列"),
    { name = "", label = "", hover = "", options = { { description = "", data = 0 } }, default = 0 },
    commonItems("__pith", "小草帽"),
    commonItems("__double_umbrella", "双层伞帽"),
    commonItems("__brainjelly", "󰀉 智慧帽"),
    commonItems("__gashat", "󰀉 梦魇的噩梦"),
    commonItems("__bathat", "󰀉 蝙蝠帽·测试版"),
    commonItems("__bushhat", "升级版·灌木丛帽"),
    { name = "", label = "", hover = "", options = { { description = "", data = 0 } }, default = 0 },
    --commonItems("__backpack_piggyback", "装备袋和收纳袋", "暂时只能两个一起，因为这两个物品是写在一起的..."),
    commonItems("__backpack", "装备袋"),
    commonItems("__piggyback", "收纳袋"),
    commonItems("__piggybag", "猪猪袋"),
    commonItems("__seasack", "海上麻袋"),
    commonItems("__storage_bag", "󰀉 保鲜袋"),
    commonItems("__wanda_box", "旺达钟表盒", "作者只玩女武神和旺达..."),
    commonItems("__waterchest", "󰀉 海上箱子"),
    commonItems("__nightspace_cape", "暗夜空间斗篷"),
    commonItems("__mone_seedpouch", "妈妈放心种子袋"),
    commonItems("__wathgrithr_box", "薇格弗德歌谣盒", "作者只玩女武神和旺达..."),
    { name = "", label = "", hover = "", options = { { description = "", data = 0 } }, default = 0 },
    commonItems("__city_lamp", "路灯"),
    commonItems("__chests_boxs", "豪华系列", "豪华箱子、豪华龙鳞宝箱、豪华冰箱、豪华盐箱"),
    commonItems("__garlic_structure", "大蒜·建筑"),
    commonItems("__chiminea", "垃圾焚化炉"),
    commonItems("__arborist", "树木栽培家"),
    commonItems("__wardrobe", "你的装备柜"),
    commonItems("__relic_2", "神秘的图腾"),
    commonItems("__moondial", "升级版·月晷"),
    commonItems("__firesuppressor", "升级版·雪球发射机"),
    { name = "", label = "", hover = "", options = { { description = "", data = 0 } }, default = 0 },
    commonItems("__poisonblam", "毒药膏"),
    commonItems("__pheromonestone", "󰀉 素石"),
    commonItems("__waterballoon", "󰀉 生命水球"),
    { name = "", label = "", hover = "", options = { { description = "", data = 0 } }, default = 0 },
    commonItems("__mone_chicken_soup", "馊鸡汤"),
    commonItems("__mone_lifeinjector_vb", "强心素食堡", "请不要和其他也改变人物血量上限的模组一起使用\n不然肯定会出现奇怪的现象"),
    commonItems("__mone_beef_wellington", "󰀉 惠灵顿风干牛排"),

    config.addBlockLabel(L and "作者的辅助功能" or "The author's auxiliary function"),
    {
        name = "wathgrithr_vegetarian",
        label = "󰀉 女武神可吃素",
        hover = "生存天数超过20天则失效(为了单人永不妥协)",
        options = {
            option("不会失效", 2),
            option(config.OPEN, 1),
            option(config.CLOSE, 0),
        },
        default = 0
    },
    {
        name = "trap_auto_reset",
        label = "狗牙陷阱自动重置",
        hover = "狗牙陷阱触发后 3 秒自动重置",
        options = {
            option(config.OPEN, true),
            option(config.CLOSE, false),
        },
        default = false
    },
    -- 待优化：我觉得至少是 ctrl+F 可以攻击才对
    {
        name = "forced_attack_lightflier",
        label = "强制攻击才能打球状光虫", -- 食人花、墙已经有本地模组了
        hover = "按住 ctrl 然后鼠标点击才能攻击",
        options = {
            option(config.OPEN, true),
            option(config.CLOSE, false),
        },
        default = false
    },
    -- 写得有问题！！！
    --{
    --    name = "forced_attack_bound_beefalo",
    --    label = "强制攻击才能打被绑定过的牛",
    --    hover = "按住 ctrl 然后鼠标点击才能攻击",
    --    options = {
    --        option(config.OPEN, true),
    --        option(config.CLOSE, false),
    --    },
    --    default = false
    --},
    config.addBlockLabel("开发者模式（忽略即可）"),
    {
        name = "debug",
        label = "Debug",
        hover = "",
        options = {
            option(config.OPEN, true),
            option(config.CLOSE, false),
        },
        default = true
    },
    {
        name = "looktietu",
        label = "looktietu",
        hover = "",
        options = {
            option("NO ANIM", 1),
            option(config.OPEN, true),
            option(config.CLOSE, false),
        },
        default = true
    },
    {
        name = "todo",
        label = "todo",
        hover = "", --"控制台：c_taskadd('添加一个备忘')、c_taskdel(数字)删除指定备忘、\nc_taskclear()清空、c_taskhide()隐藏、c_taskshow()显示",
        options = {
            option(config.OPEN, true), --"较简陋版本，有待完善"),
            option(config.CLOSE, false), --"较简陋版本，有待完善"),
        },
        default = true
    },
    --{
    --    name = "show_mod_folder_name", -- 服务端无意义。。。
    --    label = "folder_name",
    --    hover = "",
    --    options = {
    --        option(config.OPEN, true),
    --        option(config.CLOSE, false),
    --    },
    --    default = true
    --},
};

--mod_dependencies = {
--    {
--        ["workshop-"] = false;
--    }
--}

--错误追踪适配
--链接：https://dont-starve-mod.github.io/lw/zh/bugtracker_api/
bugtracker_config = {
    email = "chang123456789zsh@163.com", --接收日志的邮箱
    lang = "CHI" --
}

