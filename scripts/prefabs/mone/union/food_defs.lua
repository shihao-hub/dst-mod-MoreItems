---
--- @author zsh in 2023/1/18 10:40
---

local foods = {};

local config_data = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA;

foods["mone_beef_wellington"] = {
    CanMake = config_data.mone_beef_wellington,
    name = "mone_beef_wellington",
    assets = {
        Asset("ANIM", "anim/mone_beef_wellington.zip"),
        Asset("IMAGE", "images/foodimages/mone_beef_wellington.tex"),
        Asset("ATLAS", "images/foodimages/mone_beef_wellington.xml")
    },
    tags = { "mone_beef_wellington", "non_preparedfood" },
    animdata = { bank = "mone_beef_wellington", build = "mone_beef_wellington", animation = "idle" },
    cs_fn = function(inst)

    end,
    client_fn = function(inst)

    end,
    server_fn = function(inst)
        inst.components.inventoryitem.imagename = "mone_beef_wellington";
        inst.components.inventoryitem.atlasname = "images/foodimages/mone_beef_wellington.xml";

        inst.components.edible.hungervalue = 150;
        inst.components.edible.sanityvalue = 150;
        inst.components.edible.healthvalue = 150;
        inst.components.edible.foodtype = FOODTYPE.MEAT;
        inst.components.edible:SetOnEatenFn(function(inst, eater)
            if eater.components.talker then
                eater.components.talker:Say("惠灵顿牛排真好吃，我感觉我充满了力量！")
            end
            if eater.components.debuffable and eater.components.debuffable:IsEnabled() and
                    not (eater.components.health and eater.components.health:IsDead()) and
                    not eater:HasTag("playerghost") and
                    eater.components.combat then
                eater.mone_buff_bw_attack = { totaltime = TUNING.SEG_TIME * 8 } -- TEMP
                eater.components.debuffable:AddDebuff("mone_buff_bw_attack", "mone_buff_bw_attack");
            end
        end)
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM;
    end
}

foods["mone_chicken_soup"] = {
    CanMake = config_data.mone_chicken_soup,
    name = "mone_chicken_soup",
    assets = {
        Asset("ANIM", "anim/mone_chicken_soup.zip"),
        Asset("IMAGE", "images/foodimages/mone_chicken_soup.tex"),
        Asset("ATLAS", "images/foodimages/mone_chicken_soup.xml")
    },
    tags = { "mone_chicken_soup", "non_preparedfood" },
    animdata = { bank = "mone_chicken_soup", build = "mone_chicken_soup", animation = "idle" },
    cs_fn = function(inst)

    end,
    client_fn = function(inst)

    end,
    server_fn = function(inst)
        inst.components.inventoryitem.imagename = "mone_chicken_soup";
        inst.components.inventoryitem.atlasname = "images/foodimages/mone_chicken_soup.xml";

        inst.components.edible.hungervalue = 3;
        inst.components.edible.sanityvalue = 3;
        inst.components.edible.healthvalue = 3;
        inst.components.edible.foodtype = FOODTYPE.MEAT;
        inst.components.edible:SetOnEatenFn(function(inst, eater)
            if math.random() < 0.1 then
                if eater.components.talker then
                    eater.components.talker:Say("啊，美味的馊鸡汤！")
                end
                if eater:HasTag("player") and eater.components.hunger and eater.components.sanity and eater.components.health then
                    eater.components.hunger:SetPercent(1);
                    eater.components.sanity:SetPercent(1);
                    eater.components.health:SetPercent(1);
                end
            else
                if eater.components.talker then
                    eater.components.talker:Say("只有一股馊味...")
                end
            end
        end)
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_TINYITEM;
    end
}

foods["mone_lifeinjector_vb"] = {
    CanMake = config_data.mone_lifeinjector_vb,
    name = "mone_lifeinjector_vb",
    assets = {
        Asset("ANIM", "anim/mone_lifeinjector_vb.zip"),
        Asset("IMAGE", "images/foodimages/mone_lifeinjector_vb.tex"),
        Asset("ATLAS", "images/foodimages/mone_lifeinjector_vb.xml")
    },
    tags = { "mone_lifeinjector_vb", "non_preparedfood" },
    animdata = { bank = "mone_lifeinjector_vb", build = "mone_lifeinjector_vb", animation = "idle" },
    cs_fn = function(inst)

    end,
    client_fn = function(inst)

    end,
    server_fn = function(inst)
        inst.components.inventoryitem.imagename = "mone_lifeinjector_vb";
        inst.components.inventoryitem.atlasname = "images/foodimages/mone_lifeinjector_vb.xml";

        --inst.components.edible.hungervalue = 45;
        --inst.components.edible.healthvalue = -15;
        --inst.components.edible.sanityvalue = -30;
        inst.components.edible.hungervalue = 0;
        inst.components.edible.healthvalue = 0;
        inst.components.edible.sanityvalue = 0;
        inst.components.edible.foodtype = FOODTYPE.GOODIES;
        inst.components.edible:SetOnEatenFn(function(inst, eater)
            if eater and eater.components.mone_lifeinjector_vb then
                if eater.mone_vb_non_ban then
                    eater.components.mone_lifeinjector_vb:HPIncrease();
                elseif eater.components.talker then
                    eater.components.talker:Say("我吃了没有任何效果...");
                end
            end
        end)
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM;

        -- 添加新鲜度组件
        inst:AddComponent("perishable");
        inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW / 8);
        inst.components.perishable:StartPerishing();
        inst.components.perishable.onperishreplacement = "lifeinjector";

    end
}

foods["mone_honey_ham_stick"] = {
    CanMake = config_data.mone_honey_ham_stick,
    name = "mone_honey_ham_stick",
    assets = {
        Asset("ANIM", "anim/bs_food_58.zip"),
        Asset("IMAGE", "images/foodimages/bs_food_58.tex"),
        Asset("ATLAS", "images/foodimages/bs_food_58.xml")
    },
    tags = { "mone_honey_ham_stick", "non_preparedfood" },
    animdata = { bank = "bs_food_58", build = "bs_food_58", animation = "idle" },
    cs_fn = function(inst)

    end,
    client_fn = function(inst)

    end,
    server_fn = function(inst)
        inst.components.inventoryitem.imagename = "bs_food_58";
        inst.components.inventoryitem.atlasname = "images/foodimages/bs_food_58.xml";

        inst.components.edible.hungervalue = 75;
        inst.components.edible.sanityvalue = 75;
        inst.components.edible.healthvalue = -15;
        inst.components.edible.foodtype = FOODTYPE.MEAT;
        inst.components.edible:SetOnEatenFn(function(inst, eater)
            if eater.components.talker then
                eater.components.talker:Say("蜜汁大肉棒真好吃，我感觉我充满的干劲！")
            end
            if eater.components.debuffable and eater.components.debuffable:IsEnabled() and
                    not (eater.components.health and eater.components.health:IsDead()) and
                    not eater:HasTag("playerghost") then
                eater.mone_buff_hhs_work = { totaltime = TUNING.SEG_TIME * 8 } -- TEMP
                eater.components.debuffable:AddDebuff("mone_buff_hhs_work", "mone_buff_hhs_work");
            end
        end)

        inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM;

        inst:AddComponent("perishable");
        inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW / 8 * 3);
        inst.components.perishable:StartPerishing();
        inst.components.perishable.onperishreplacement = "spoiled_food";
    end
}

return foods;

