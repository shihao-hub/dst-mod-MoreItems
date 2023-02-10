---
--- @author zsh in 2023/2/10 10:07
---

---
--- @author zsh in 2023/2/6 11:03
---

local L = (locale == "zh" or locale == "zht" or locale == "zhr") and true or false;

local vars = {
    OPEN = L and "开启" or "Open";
    CLOSE = L and "关闭" or "Close";
};

local function option(description, data, hover)
    return {
        description = description or "",
        data = data,
        hover = hover or ""
    };
end

local fns = {
    description = function(folder_name, author, version, start_time, content)
        content = content or "";
        return (L and "                                                  感谢你的订阅！\n"
                .. content .. "\n"
                .. "                                                【模组】：" .. folder_name .. "\n"
                .. "                                                【作者】：" .. author .. "\n"
                .. "                                                【版本】：" .. version .. "\n"
                .. "                                                【时间】：" .. start_time .. "\n"
                or "                                                Thanks for subscribing!\n"
                .. content .. "\n"
                .. "                                                【mod    】：" .. folder_name .. "\n"
                .. "                                                【author 】：" .. author .. "\n"
                .. "                                                【version】：" .. version .. "\n"
                .. "                                                【release】：" .. start_time .. "\n"
        );
    end,
    largeLabel = function(label)
        return {
            name = "",
            label = label or "",
            hover = "",
            options = {
                option("", 0)
            },
            default = 0
        }
    end,
    common_item = function(name, label, hover)
        return {
            name = name;
            label = label or "";
            hover = hover or "";
            options = {
                option(vars.OPEN, true),
                option(vars.CLOSE, false),
            },
            default = true;
        }
    end,
    blank = function()
        return {
            name = "";
            label = "";
            hover = "";
            options = {
                option("", 0)
            },
            default = 0
        }
    end
};

local __name = L and "更多物品" or "More Items";
local __author = "心悦卿兮";
local __version = "2.0.1";
local __server_filter_tags = { "更多物品", "More Items" };

local start_time = "2023-01-08";
local folder_name = folder_name or "workshop"; -- 淘宝的云服务器卖家没有导入其他文件，所以那边 modinfo.lua 会导入失败。
local content = [[
    󰀜󰀝󰀀󰀞󰀘󰀁󰀟󰀠󰀡󰀂
    󰀃󰀄󰀢󰀅󰀣󰀆󰀇󰀈󰀤󰀙
    󰀰󰀉󰀚󰀊󰀋󰀌󰀍󰀥󰀎󰀏
    󰀦󰀐󰀑󰀒󰀧󰀱󰀨󰀓󰀔󰀩
    󰀪󰀕󰀫󰀖󰀛󰀬󰀭󰀮󰀗󰀯
]]; -- emoji.lua + emoji_items.lua


name = __name;
author = __author;
version = __version;
description = fns.description(folder_name, author, version, start_time, content);

server_filter_tags = __server_filter_tags;

client_only_mod = false;
all_clients_require_mod = true;

icon = "modicon.tex";
icon_atlas = "modicon.xml";

forumthread = "";
api_version = 10;
priority = 0; -- 如果开启了我的五格装备栏，优先级必须比能力勋章低。所以能力勋章为什么会报错呢？我也想优先级低啊！

dont_starve_compatible = false;
reign_of_giants_compatible = false;
dst_compatible = true;


configuration_options = {
    {
        name = "balance",
        label = "内容平衡",
        hover = "制作物品需要不同科技等级和材料难度等。\n如：有些是boss掉落物。有些必须在远古科技台才能制作。", -- Lang("根据作者的想法平衡一下模组内容，诸如制作难度等", "Balance the content of the module according to the author's idea, such as crafting difficulty, etc"),
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },

    fns.largeLabel("辅助功能"),
    {
        name = "backpacks_light",
        label = "背包发光",
        hover = "装备背包时，夜间自动发光。\n反正已经很变态了，我还能再变态一点。",
        options = {
            option(vars.OPEN, true, "轻易不要开，莫要衰减游戏寿命！"),
            option(vars.CLOSE, false, "轻易不要开，莫要衰减游戏寿命！"),
        },
        default = false
    },
    {
        name = "extra_equip_slots",
        label = "五格装备栏",
        hover = "(这是作者自己的，目前作者自己用起来是正常的)\n修复其他五格装备栏不能直接消耗箱子里的材料制作物品的bug，且兼容了很多其他模组的物品",
        options = {
            option(vars.OPEN, true, "(但是！注意不要和同类模组一起使用)"),
            option(vars.CLOSE, false, "(但是！注意不要和同类模组一起使用)"),
        },
        default = false
    },
    {
        name = "container_removable",
        label = "容器 UI 可以移动",
        hover = "如果你开启了本地模组：UI拖拽缩放镜像，该选项自动失效！\n建议订阅那个模组，挺好用的。",
        options = {
            option(vars.OPEN, true, "右键按住可以移动，键盘 home 键复原"),
            option(vars.CLOSE, false, "右键按住可以移动，键盘 home 键复原"),
            option("该功能仍生效", 1, "该功能仍生效，但是需要关闭那个模组的容器UI支持选项！"),
        },
        default = true
    },
    {
        name = "current_date",
        label = "屏幕上方显示当前时间",
        hover = "顾名思义，作者自己想用。",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    {
        name = "chests_arrangement",
        label = "箱子冰箱等关闭后自动整理",
        hover = L and "箱子、龙鳞宝箱、冰箱、盐箱 + 豪华系列" or "Chest, Dragon scale treasure chest, refrigerator, salt chest",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },

    fns.largeLabel("模组内容设置"),
    {
        name = "arborist_light",
        label = "树木栽培家发光",
        hover = "其实我还想加个自动灭火的，算了算了。",
        options = {
            option(vars.OPEN, true, "轻易不要开，莫要衰减游戏寿命！"),
            option(vars.CLOSE, false, "轻易不要开，莫要衰减游戏寿命！"),
        },
        default = false
    },
    {
        name = "mone_chests_boxs_capability",
        label = "豪华系列容器容量设置",
        hover = "16 or 25",
        options = {
            option("5x5", true),
            option("4x4", false),
        },
        default = true -- true 为 5x5
    },

    fns.largeLabel("素石-物品设置"),
    {
        name = "greenamulet_pheromonestone",
        label = "素石可以对建造护符使用",
        hover = "虽然素石已经很过分了。但是对建造护符使用的话那就更过分了。",
        options = {
            option(vars.OPEN, true, "轻易不要开，莫要衰减游戏寿命！"),
            option(vars.CLOSE, false, "轻易不要开，莫要衰减游戏寿命！"),
        },
        default = false
    },
    {
        name = "insight_and_pheromonestone_permit",
        label = "开启Insight后还是可以使用素石",
        hover = "因为有玩家说他在开启Insight后，并不会出现问题。\n我也不是很确定，可能是Insight修复了这个bug了？",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },

    fns.largeLabel("装备袋-物品设置"),
    {
        name = "mone_backpack_auto",
        label = "装备袋中的装备自动切换",
        hover = "装备损坏时，自动查找装备袋中有无同名装备，然后装备上。\n如果出现问题关闭该选项即可。",
        options = {
            option(vars.OPEN, true, "此功能写于2023-01-19，采用的是覆盖法"),
            option(vars.CLOSE, false, "此功能写于2023-01-19，采用的是覆盖法"),
        },
        default = true
    },
    {
        name = "cane_gointo_mone_backpack",
        label = "步行手杖可以放入装备袋",
        hover = "没啥太大意义，就加个开关而已。\n如果你身上带太多装备袋，说不一定需要这个。",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    fns.largeLabel("你的装备柜-物品设置"),
    {
        name = "mone_wardrobe_background",
        label = "你的装备柜格子有背景图片",
        hover = "",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },

    fns.largeLabel("旺达钟表盒-物品设置"),
    {
        name = "mone_wanda_box_itemtestfn_extra1",
        label = "倒走表可以放入旺达钟表盒",
        hover = "如果你开启了快捷键使用倒走表的相关模组的话，那倒是挺方便的。",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },
    {
        name = "mone_wanda_box_itemtestfn_extra2",
        label = "裂缝表和溯源表可以放入旺达钟表盒",
        hover = "如果你开启了旺达的表可以命名的相关模组的话，那倒是挺方便的。",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },

    fns.largeLabel("物品优先进容器-功能设置"),
    {
        name = "IGICF",
        label = "开关",
        hover = "如果不习惯，关闭即可\n装备袋、保鲜袋、收纳袋、猪猪袋、海上箱子",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    {
        name = "IGICF_mone_piggyback",
        label = "收纳袋",
        hover = "物品也会优先进入收纳袋？",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },
    {
        name = "IGICF_waterchest_inv",
        label = "海上箱子",
        hover = "物品也会优先进入海上箱子？",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },

    fns.largeLabel("升级版·雪球发射机-物品设置"),
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
        label = "发光",
        hover = "夜晚自动发光，而且还能让作物在夜晚也能生长。",
        options = {
            option(vars.OPEN, true, "轻易不要开，莫要衰减游戏寿命！"),
            option(vars.CLOSE, false, "轻易不要开，莫要衰减游戏寿命！"),
        },
        default = false
    },
    {
        name = "auto_sorter_notags_extra",
        label = "不熄灭火坑",
        hover = "",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    {
        name = "auto_sorter_no_fuel",
        label = "不消耗燃料",
        hover = "即：不会扣除燃料\n主要为了方便。",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
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
        default = 3
    },

    fns.largeLabel("取消某件物品及其相关内容"),
    fns.common_item("__spear_poison", "毒矛"),
    fns.common_item("__halberd", "多功能·戟"),
    fns.common_item("__walking_stick", "临时加速手杖"),
    fns.common_item("__harvester_staff", "收割者的砍刀系列"),
    fns.blank(),
    fns.common_item("__pith", "小草帽"),
    fns.common_item("__double_umbrella", "双层伞帽"),
    fns.common_item("__brainjelly", "智慧帽"),
    fns.common_item("__gashat", "梦魇的噩梦"),
    fns.common_item("__bathat", "蝙蝠帽·测试版"),
    fns.blank(),
    fns.common_item("__backpack", "装备袋"),
    fns.common_item("__piggyback", "收纳袋"),
    fns.common_item("__piggybag", "猪猪袋"),
    fns.common_item("__seasack", "海上麻袋"),
    fns.common_item("__storage_bag", "保鲜袋"),
    fns.common_item("__wanda_box", "旺达钟表盒", "作者只玩女武神和旺达..."),
    fns.common_item("__waterchest", "海上箱子"),
    fns.common_item("__nightspace_cape", "暗夜空间斗篷"),
    fns.common_item("__mone_seedpouch", "妈妈放心种子袋"),
    fns.common_item("__wathgrithr_box", "薇格弗德歌谣盒", "作者只玩女武神和旺达..."),
    fns.blank(),
    fns.common_item("__city_lamp", "路灯"),
    fns.common_item("__chests_boxs", "豪华系列", "豪华箱子、豪华龙鳞宝箱、豪华冰箱、豪华盐箱"),
    fns.common_item("__garlic_structure", "大蒜·建筑"),
    fns.common_item("__chiminea", "垃圾焚化炉"),
    fns.common_item("__arborist", "树木栽培家"),
    fns.common_item("__wardrobe", "你的装备柜"),
    fns.common_item("__moondial", "升级版·月晷"),
    fns.common_item("__firesuppressor", "升级版·雪球发射机"),
    fns.blank(),
    fns.common_item("__pheromonestone", "素石"),
    fns.common_item("__poisonblam", "毒药膏"),
    fns.common_item("__waterballoon", "生命水球"),
    fns.blank(),
    fns.common_item("__mone_chicken_soup", "馊鸡汤"),
    fns.common_item("__mone_lifeinjector_vb", "强心素食堡", "请不要和其他也改变人物血量上限的模组一起使用\n不然肯定会出现奇怪的现象"),
    fns.common_item("__mone_honey_ham_stick", "蜜汁大肉棒"),
    fns.common_item("__mone_beef_wellington", "惠灵顿风干牛排"),

    fns.largeLabel("作者的辅助功能"),
    {
        name = "wathgrithr_vegetarian",
        label = "女武神可吃素",
        hover = "生存天数超过20天则失效(为了单人永不妥协)",
        options = {
            option("不会失效", 2),
            option(vars.OPEN, 1),
            option(vars.CLOSE, 0),
        },
        default = 0
    },
    {
        name = "trap_auto_reset",
        label = "狗牙陷阱自动重置",
        hover = "狗牙陷阱触发后 3 秒自动重置",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },
    -- 待优化：我觉得至少是 ctrl+F 可以攻击才对
    {
        name = "forced_attack_lightflier",
        label = "强制攻击才能打球状光虫", -- 食人花、墙已经有本地模组了
        hover = "按住 ctrl 然后鼠标点击才能攻击",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = false
    },
    -- 写得有问题！！！
    --{
    --    name = "forced_attack_bound_beefalo",
    --    label = "强制攻击才能打被绑定过的牛",
    --    hover = "按住 ctrl 然后鼠标点击才能攻击",
    --    options = {
    --        option(vars.OPEN, true),
    --        option(vars.CLOSE, false),
    --    },
    --    default = false
    --},

    fns.largeLabel("开发者模式（忽略即可）"),
    {
        name = "debug",
        label = "Debug",
        hover = "",
        options = {
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = true
    },
    {
        name = "looktietu",
        label = "looktietu",
        hover = "",
        options = {
            option("NO ANIM", 1),
            option(vars.OPEN, true),
            option(vars.CLOSE, false),
        },
        default = 1
    },
    {
        name = "todo",
        label = "todo",
        hover = "", --"控制台：c_taskadd('添加一个备忘')、c_taskdel(数字)删除指定备忘、\nc_taskclear()清空、c_taskhide()隐藏、c_taskshow()显示",
        options = {
            option(vars.OPEN, true), --"较简陋版本，有待完善"),
            option(vars.CLOSE, false), --"较简陋版本，有待完善"),
        },
        default = true
    },
}

