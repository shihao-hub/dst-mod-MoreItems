---
--- @author zsh in 2023/1/10 4:52
---



local API = require("chang_mone.dsts.API");
local TEXT = require("languages.mone.loc");

local function fn(inst, doer)
    if inst.components.container ~= nil then
        API.arrangeContainer(inst);
    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
        SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
    end
end

local function validfn(inst)
    return inst.replica.container ~= nil and not inst.replica.container:IsEmpty();
end

local containers = require("containers");
local params = containers.params;

-- ����
--params.mone_treasurechest = {
--    widget = {
--        slotpos = {},
--        animbank = "my_chest_ui_6x6",
--        animbuild = "my_chest_ui_6x6",
--        pos = Vector3(0, 250, 0),
--        buttoninfo = {
--            text = TEXT.TIDY,
--            position = Vector3(75 * 0, -75 * 3 - 37.5 + 5, 0),
--            fn = fn,
--            validfn = validfn
--        }
--    },
--    type = "chest"
--}
--for y = 2, -3, -1 do
--    for x = -3, 2 do
--        table.insert(params.mone_treasurechest.widget.slotpos, Vector3(75 * x + 37.5, 75 * y + 37.5, 0))
--    end
--end

-- ���۱���
if TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.mone_chests_boxs_capability then
    params.mone_dragonflychest = {
        widget = {
            slotpos = {},
            animbank = "my_chest_ui_5x5",
            animbuild = "my_chest_ui_5x5",
            pos = Vector3(0, 200, 0),
            buttoninfo = {
                text = TEXT.TIDY,
                position = Vector3(0, -75 * 3 + 10, 0),
                fn = fn,
                validfn = validfn
            }
        },
        type = "chest",
    }

    for y = 2, -2, -1 do
        for x = -2, 2 do
            table.insert(params.mone_dragonflychest.widget.slotpos, Vector3(75 * x, 75 * y, 0))
        end
    end
else
    params.mone_dragonflychest = {
        widget = {
            slotpos = {},
            animbank = "my_chest_ui_4x4",
            animbuild = "my_chest_ui_4x4",
            pos = Vector3(0, 200, 0),
            buttoninfo = {
                text = TEXT.TIDY,
                position = Vector3(0, -190, 0),
                fn = fn,
                validfn = validfn
            }
        },
        type = "chest",
    }

    for y = 2, -1, -1 do
        for x = -1, 2 do
            table.insert(params.mone_dragonflychest.widget.slotpos, Vector3(80 * x - 40, 80 * y - 40, 0))
        end
    end
end

-- �޸ģ�
params.mone_treasurechest = deepcopy(params.mone_dragonflychest);
params.mone_icebox = deepcopy(params.mone_dragonflychest);
params.mone_saltbox = deepcopy(params.mone_dragonflychest);

function params.mone_icebox.itemtestfn(container, item, slot)
    if item:HasTag("icebox_valid") then
        return true
    end

    --Perishable
    if not (item:HasTag("fresh") or item:HasTag("stale") or item:HasTag("spoiled")) then
        return false
    end

    if item:HasTag("smallcreature") then
        return false
    end

    --Edible
    for k, v in pairs(FOODTYPE) do
        if item:HasTag("edible_" .. v) then
            return true
        end
    end

    return false
end

function params.mone_saltbox.itemtestfn(container, item, slot)
    return ((item:HasTag("fresh") or item:HasTag("stale") or item:HasTag("spoiled"))
            and item:HasTag("cookable")
            and not item:HasTag("deployable")
            and not item:HasTag("smallcreature")
            and item.replica.health == nil)
            or item:HasTag("saltbox_valid")
end

params.mone_waterchest = {
    widget = {
        slotpos = {},
        animbank = "big_box_ui_120",
        animbuild = "big_box_ui_120",
        pos = Vector3(0, 0 + 100, 0),
        buttoninfo = {
            text = TEXT.TIDY,
            position = Vector3(-5, 193, 0), --���ֹ�����Ϊ����ͼ���Ĳ���
            fn = fn,
            validfn = validfn
        }
    },
    type = "chest",
    itemtestfn = function(container, item, slot)
        if item.prefab == "mone_waterchest_inv" then
            return false;
        end
        if item:HasTag("_container") then
            return false;
        end
        return true;
    end
}

local spacer = 30 --���
local posX = nil --x
local posY = nil --y
for z = 0, 2 do
    for y = 7, 0, -1 do
        for x = 0, 4 do
            posX = 80 * x - 600 + 80 * 5 * z + spacer * z
            posY = 80 * y - 100

            if y > 3 then
                posY = posY + spacer
            end

            table.insert(params.mone_waterchest.widget.slotpos, Vector3(posX, posY, 0))
        end
    end
end

-- �޸ģ�
params.mone_minotaurchest = deepcopy(params.mone_waterchest);

local GetNumSlots = 40
local my_storeroom_animbank = nil
local my_storeroom_animbuild = nil
local my_storeroom_X = nil
local my_storeroom_Y = nil
local my_storeroom_posX = nil
local my_storeroom_posY = nil
local my_storeroom_button_pos = nil

if GetNumSlots == 20 then
    my_storeroom_animbank = "ui_chest_4x5"
    my_storeroom_animbuild = "ui_chest_4x5"
    my_storeroom_X = 4
    my_storeroom_Y = 3
    my_storeroom_posX = 90
    my_storeroom_posY = 130
    my_storeroom_button_pos = Vector3(80 * my_storeroom_X / 2 - 346 * 2 + my_storeroom_posX, 80 * 0 - 100 * 2 + my_storeroom_posY - 53, 0)
elseif GetNumSlots == 40 and true then
    my_storeroom_animbank = "ui_chest_5x8"
    my_storeroom_animbuild = "ui_chest_5x8"
    my_storeroom_X = 7
    my_storeroom_Y = 4
    my_storeroom_posX = 109
    my_storeroom_posY = 42
    my_storeroom_button_pos = Vector3(80 * my_storeroom_X / 2 - 346 * 2 + my_storeroom_posX, 80 * 0 - 100 * 2 + my_storeroom_posY - 53, 0)
elseif GetNumSlots == 60 and true then
    my_storeroom_animbank = "ui_chest_5x12"
    my_storeroom_animbuild = "ui_chest_5x12"
    my_storeroom_X = 11
    my_storeroom_Y = 4
    my_storeroom_posX = 98
    my_storeroom_posY = 42
    my_storeroom_button_pos = Vector3(80 * my_storeroom_X / 2 - 346 * 2 + my_storeroom_posX, 80 * 0 - 100 * 2 + my_storeroom_posY - 53, 0)
elseif GetNumSlots == 80 and true then
    my_storeroom_animbank = "ui_chest_5x16"
    my_storeroom_animbuild = "ui_chest_5x16"
    my_storeroom_X = 15
    my_storeroom_Y = 4
    my_storeroom_posX = 91
    my_storeroom_posY = 42
    my_storeroom_button_pos = Vector3(80 * my_storeroom_X / 2 - 346 * 2 + my_storeroom_posX, 80 * 0 - 100 * 2 + my_storeroom_posY - 53, 0)
end
--������
params.mone_terrariumchest = {
    widget = {
        slotpos = {},
        animbank = my_storeroom_animbank,
        animbuild = my_storeroom_animbuild,
        pos = Vector3(360 - (GetNumSlots * 4.5), 150, 0),
        buttoninfo = {
            text = TEXT.TIDY,
            position = my_storeroom_button_pos,
            fn = fn,
            validfn = validfn
        }
    },
    type = "chest",
    itemtestfn = function(container, item, slot)
        if item.prefab == container.prefab or item:HasTag("_container") then
            return false;
        end
        return true;
    end
}
for y = my_storeroom_Y, 0, -1 do
    for x = 0, my_storeroom_X do
        table.insert(params.mone_terrariumchest.widget.slotpos, Vector3(80 * x - 346 * 2 + my_storeroom_posX, 80 * y - 100 * 2 + my_storeroom_posY, 0))
    end
end

-- �޸ģ�
--params.mone_piggyback = deepcopy(params.mone_terrariumchest);
--params.mone_piggyback.widget.type = "mone_piggyback"; --??? ���У�
params.mone_piggyback = {
    widget = {
        slotpos = {},
        animbank = my_storeroom_animbank,
        animbuild = my_storeroom_animbuild,
        pos = GetNumSlots ~= 40 and Vector3(360 - (GetNumSlots * 4.5), 150, 0)
                or Vector3(360 - (40 * 4.5) - 600 + 80, 150 + 200 - 50, 0),
        buttoninfo = {
            text = TEXT.TIDY,
            position = my_storeroom_button_pos,
            fn = fn,
            validfn = validfn
        }
    },
    type = "mone_piggyback",
    itemtestfn = function(container, item, slot)
        if item.prefab == container.prefab or item:HasTag("_container") then
            return false;
        end
        return true;
    end
}
for y = my_storeroom_Y, 0, -1 do
    for x = 0, my_storeroom_X do
        table.insert(params.mone_piggyback.widget.slotpos, Vector3(80 * x - 346 * 2 + my_storeroom_posX, 80 * y - 100 * 2 + my_storeroom_posY, 0))
    end
end


-- �޸ģ�����ѩ������
params.mone_firesuppressor = {
    widget = {
        slotpos = {},
        animbank = "my_chest_ui_5x5",
        animbuild = "my_chest_ui_5x5",
        pos = Vector3(0, 200, 0),
        buttoninfo = {
            text = TEXT.PICK,
            position = Vector3(0, -75 * 3 + 10, 0),
            fn = function(inst, doer)
                if inst.components.container ~= nil then
                    API.AutoSorter.pickObjectOnFloorOnClick(inst);
                elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
                    SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil);
                end
            end,
            validfn = function(inst)
                return true;
            end
        }
    },
    type = "chest",
    itemtestfn = function(inst, item, slot)
        if item:HasTag("_container") then
            return false;
        end
        return true;
    end
}

for y = 2, -2, -1 do
    for x = -2, 2 do
        table.insert(params.mone_firesuppressor.widget.slotpos, Vector3(75 * x, 75 * y, 0))
    end
end

params.mone_chiminea = {
    widget = {
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_chest_3x3",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
        buttoninfo = {
            text = TEXT.DELETE,
            position = Vector3(0, -140, 0),
            fn = function(inst, doer)
                if inst.components.container then
                    if inst.components.container then
                        for _, v in pairs(inst.components.container:RemoveAllItems()) do
                            if v then
                                if v.prefab then
                                    print(v.prefab .. " Remove()")
                                end
                                v:Remove();
                            end
                        end
                        inst.SoundEmitter:PlaySound("dontstarve/common/fireOut")
                    end
                elseif inst.replica.container and not inst.replica.container:IsBusy() then
                    SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
                end
            end,
            validfn = function(inst)
                return inst.replica.container ~= nil and not inst.replica.container:IsEmpty()
            end
        }
    },
    type = "chest",
    itemtestfn = function(container, item, slot)
        return not (item:HasTag("irreplaceable") or item:HasTag("_container") or item:HasTag("bundle") or item:HasTag("nobundling"))
    end
}
for y = 2, 0, -1 do
    for x = 0, 2 do
        table.insert(params.mone_chiminea.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
    end
end

params.mone_wardrobe = {
    widget = {
        slotpos = {},
        animbank = "my_chest_ui_6x6",
        animbuild = "my_chest_ui_6x6",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
        slotbg = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.wardrobe_background and {
            { image = "wardrobe_hat_slot.tex", atlas = "images/uiimages/wardrobe_hat_slot.xml" },
            { image = "wardrobe_chest_slot.tex", atlas = "images/uiimages/wardrobe_chest_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/uiimages/wardrobe_tool_slot.xml" },
            { image = "wardrobe_hat_slot.tex", atlas = "images/uiimages/wardrobe_hat_slot.xml" },
            { image = "wardrobe_chest_slot.tex", atlas = "images/uiimages/wardrobe_chest_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/uiimages/wardrobe_tool_slot.xml" },
            { image = "wardrobe_hat_slot.tex", atlas = "images/uiimages/wardrobe_hat_slot.xml" },
            { image = "wardrobe_chest_slot.tex", atlas = "images/uiimages/wardrobe_chest_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/uiimages/wardrobe_tool_slot.xml" },
            { image = "wardrobe_hat_slot.tex", atlas = "images/uiimages/wardrobe_hat_slot.xml" },
            { image = "wardrobe_chest_slot.tex", atlas = "images/uiimages/wardrobe_chest_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/uiimages/wardrobe_tool_slot.xml" },
            { image = "wardrobe_hat_slot.tex", atlas = "images/uiimages/wardrobe_hat_slot.xml" },
            { image = "wardrobe_chest_slot.tex", atlas = "images/uiimages/wardrobe_chest_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/uiimages/wardrobe_tool_slot.xml" },
            { image = "wardrobe_hat_slot.tex", atlas = "images/uiimages/wardrobe_hat_slot.xml" },
            { image = "wardrobe_chest_slot.tex", atlas = "images/uiimages/wardrobe_chest_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/uiimages/wardrobe_tool_slot.xml" },
            { image = "wardrobe_hat_slot.tex", atlas = "images/uiimages/wardrobe_hat_slot.xml" },
            { image = "wardrobe_chest_slot.tex", atlas = "images/uiimages/wardrobe_chest_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/uiimages/wardrobe_tool_slot.xml" },
            { image = "wardrobe_hat_slot.tex", atlas = "images/uiimages/wardrobe_hat_slot.xml" },
            { image = "wardrobe_chest_slot.tex", atlas = "images/uiimages/wardrobe_chest_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/uiimages/wardrobe_tool_slot.xml" },
            { image = "wardrobe_hat_slot.tex", atlas = "images/uiimages/wardrobe_hat_slot.xml" },
            { image = "wardrobe_chest_slot.tex", atlas = "images/uiimages/wardrobe_chest_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/uiimages/wardrobe_tool_slot.xml" },
            { image = "wardrobe_hat_slot.tex", atlas = "images/uiimages/wardrobe_hat_slot.xml" },
            { image = "wardrobe_chest_slot.tex", atlas = "images/uiimages/wardrobe_chest_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/uiimages/wardrobe_tool_slot.xml" },
            { image = "wardrobe_hat_slot.tex", atlas = "images/uiimages/wardrobe_hat_slot.xml" },
            { image = "wardrobe_chest_slot.tex", atlas = "images/uiimages/wardrobe_chest_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/uiimages/wardrobe_tool_slot.xml" },
            { image = "wardrobe_hat_slot.tex", atlas = "images/uiimages/wardrobe_hat_slot.xml" },
            { image = "wardrobe_chest_slot.tex", atlas = "images/uiimages/wardrobe_chest_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/uiimages/wardrobe_tool_slot.xml" }
        } or {},
        buttoninfo = {
            text = TEXT.TIDY,
            position = Vector3(75 * 0, -75 * 3 - 37.5 + 5, 0),
            fn = fn,
            validfn = validfn;
        }
    },
    type = "chest",
    itemtestfn = function(container, item, slot)
        return item:HasTag("_equippable");
    end
}

for y = 2, -3, -1 do
    for x = -3, 2 do
        table.insert(params.mone_wardrobe.widget.slotpos, Vector3(75 * x + 37.5, 75 * y + 37.5, 0))
    end
end

params.mone_backpack = {
    widget = {
        slotpos = {},
        animbank = "ui_backpack_2x4",
        animbuild = "ui_backpack_2x4",
        pos = Vector3(275 + 100 + 150 + 150 + 5 + 2 - 30 + 35 + 2, -60 - 10 + 3 + 3 - 5 - 2, 0),
        side_align_tip = 160,
        buttoninfo = {
            text = TEXT.TIDY,
            position = Vector3(-125, -270 + 80 + 8 + 3 + 3, 0), -- ȷ���ˣ��ǵ�һ���ޣ�
            fn = function(inst, doer)
                if inst.components.container ~= nil then
                    API.arrangeContainer(inst);
                elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
                    SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
                end
            end,
            validfn = function(inst)
                return inst.replica.container ~= nil and not inst.replica.container:IsEmpty()
            end
        }
    },
    type = "mone_bag",
    itemtestfn = function(container, item, slot)
        if not TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.cane_gointo_mone_backpack then
            if item.prefab == "cane" then
                return false;
            end
        end
        return item:HasTag("_equippable");
    end
}

for y = 0, 3 do
    table.insert(params.mone_backpack.widget.slotpos, Vector3(-162, -75 * y + 114, 0))
    table.insert(params.mone_backpack.widget.slotpos, Vector3(-162 + 75, -75 * y + 114, 0))
end

params.mone_piggybag = {
    widget = {
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_chest_3x3",
        pos = Vector3(625, -360, 0)
    },
    type = "mone_piggybag",
    itemtestfn = function(container, item, slot)
        if item.prefab == "mone_piggybag" then
            return false;
        end
        if item:HasTag("_container") or item:HasTag("mone_piggybag_itemtesttag") then
            return true;
        end
        return false;
    end
}

for y = 2, 0, -1 do
    for x = 0, 2 do
        table.insert(params.mone_piggybag.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
    end
end

--params.mone_wathgrithr_box = {
--    widget = {
--        slotpos = {},
--        animbank = "ui_chester_shadow_3x4",
--        animbuild = "ui_chester_shadow_3x4",
--        pos = Vector3(590 - 150, -50, 0),
--        side_align_tip = 160,
--        buttoninfo = {
--            text = TEXT.TIDY,
--            position = Vector3(0, -180, 0),
--            fn = fn,
--            validfn = validfn;
--        }
--    },
--    type = "mone_wathgrithr_box",
--    itemtestfn = function(container, item, slot)
--        return item:HasTag("battlesong");
--    end
--}
--
--for y = 2.5, -0.5, -1 do
--    for x = 0, 2 do
--        table.insert(params.mone_wathgrithr_box.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
--    end
--end

params.mone_wathgrithr_box = {
    widget = {
        slotpos = {},
        animbank = "ui_backpack_2x4",
        animbuild = "ui_backpack_2x4",
        pos = Vector3(275 + 100 + 150 + 150 + 5 + 2 - 30 - 60 - 40, -60 - 10 + 3 + 3 - 5, 0),
        side_align_tip = 160,
        buttoninfo = {
            text = TEXT.TIDY,
            position = Vector3(-125, -270 + 80 + 8 + 3 + 3, 0), -- ȷ���ˣ��ǵ�һ���ޣ�
            fn = function(inst, doer)
                if inst.components.container ~= nil then
                    API.arrangeContainer(inst);
                elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
                    SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
                end
            end,
            validfn = function(inst)
                return inst.replica.container ~= nil and not inst.replica.container:IsEmpty()
            end
        }
    },
    type = "mone_wathgrithr_box",
    itemtestfn = function(container, item, slot)
        return item:HasTag("battlesong");
    end
}

for y = 0, 3 do
    table.insert(params.mone_wathgrithr_box.widget.slotpos, Vector3(-162, -75 * y + 114, 0))
    table.insert(params.mone_wathgrithr_box.widget.slotpos, Vector3(-162 + 75, -75 * y + 114, 0))
end

--params.mone_wanda_box = deepcopy(params.mone_wathgrithr_box);
params.mone_wanda_box = {
    widget = {
        slotpos = {},
        animbank = "ui_backpack_2x4",
        animbuild = "ui_backpack_2x4",
        pos = Vector3(275 + 100 + 150 + 150 + 5 + 2 - 30 - 60 - 40, -60 - 10 + 3 + 3 - 5 - 3, 0),
        side_align_tip = 160,
        buttoninfo = {
            text = TEXT.TIDY,
            position = Vector3(-125, -270 + 80 + 8 + 3 + 3, 0), -- ȷ���ˣ��ǵ�һ���ޣ�
            fn = function(inst, doer)
                if inst.components.container ~= nil then
                    API.arrangeContainer(inst);
                elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
                    SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
                end
            end,
            validfn = function(inst)
                return inst.replica.container ~= nil and not inst.replica.container:IsEmpty()
            end
        }
    },
    type = "mone_wanda_box",
    itemtestfn = function(container, item, slot)
        return item:HasTag("mone_wanda_box_itemtestfn");
    end
}

for y = 0, 3 do
    table.insert(params.mone_wanda_box.widget.slotpos, Vector3(-162, -75 * y + 114, 0))
    table.insert(params.mone_wanda_box.widget.slotpos, Vector3(-162 + 75, -75 * y + 114, 0))
end

params.mone_seedpouch = {
    widget = {
        slotpos = {},
        --bgatlas = "images/uiimages/krampus_sack_bg.xml",
        --bgimage = "krampus_sack_bg.tex",
        animbank = "mone_seedpouch",
        animbuild = "mone_seedpouch",
        --pos = Vector3(-5 - 40 - 20 - 5, -120, 0),
        pos = Vector3(-5 - 40 - 20 - 5, -120, 0),
    },
    issidewidget = true,
    type = "pack",
    openlimit = 1,
    itemtestfn = function(container, item, slot)
        return item:HasTag("deployedfarmplant"); -- ֻ�ܷ�����
    end
}
for y = 0, 9 do
    table.insert(params.mone_seedpouch.widget.slotpos, Vector3(-37, -y * 67 + 302, 0))
    table.insert(params.mone_seedpouch.widget.slotpos, Vector3(-37 + 75, -y * 67 + 302, 0))
end

params.mone_relic_2 = {
    widget = {
        slotpos = {
            Vector3(0 + 2, 0, 0)
        },
        animbank = "my_ui_cookpot_1x1",
        animbuild = "my_ui_cookpot_1x1",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160
    },
    type = "chest",
    itemtestfn = function(container, item, slot)
        local exclude_prefabs = {

        }
        for _, v in ipairs(exclude_prefabs) do
            if v == item.prefab then
                return false;
            end
        end

        local exclude_tags = {
            "irreplaceable", "_container"
        }
        for _, v in ipairs(exclude_tags) do
            if item:HasTag(v) then
                return false;
            end
        end

        return true;
    end
}


-- ������������֤ MAXITEMSLOTS �㹻�󣬶����벻Ҫ�� inst.replica.container:WidgetSetup(nil, widgetsetup); ��д��������̫�࣡
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end





