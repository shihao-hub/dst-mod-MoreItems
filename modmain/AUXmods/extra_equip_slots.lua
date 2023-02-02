---
--- @author zsh in 2023/1/21 12:02
---

-- �޸�����ֱ������������Ĳ���������Ʒ��bug

local function getTabLen(t)
    local len = 0
    for _, _ in pairs(t) do
        len = len + 1;
    end
    return len;
end

local slotsnum = getTabLen(GLOBAL.EQUIPSLOTS);
local Inv = require "widgets/inventorybar";

TUNING.MONE_TUNING.EXTRA_EQUIP_SLOTS_ON_TAG = "mone_extra_equip_slot_on_tag";

-- ��ʱ���Ǳ�������д�ģ�������Ϊ����������������˹��ϡ������Ǻ��������һ�𿪵�ʱ��Ĺ��ϣ��� net��classified �й�
if slotsnum > 6 then
    return ;
elseif slotsnum > 4 then
    return ;
else
    GLOBAL.EQUIPSLOTS = {
        HANDS = "hands",
        HEAD = "head",
        BODY = "body",
        BACK = "back",
        NECK = "neck"
    }

    GLOBAL.EQUIPSLOT_IDS = {}

    local num = 0;
    for _, v in pairs(GLOBAL.EQUIPSLOTS) do
        num = num + 1;
        GLOBAL.EQUIPSLOT_IDS[v] = num;
    end
end

--- ?????? ���ȼ���������ѫ�£�Ȼ������ѫ�»ᱨ������������tmd����ֻ�ܵ������Լ������ȼ��ˡ�
print("MORE_ITEMS_ON");

-- ��� ��
env.AddGlobalClassPostConstruct("widgets/inventorybar", "Inv", function()
    local Inv_Refresh_base = Inv.Refresh or function() return "" end
    local Inv_Rebuild_base = Inv.Rebuild or function() return "" end

    function Inv:LoadExtraSlots(self)
        self.bg:SetScale(1.35,1,1.25)
        self.bgcover:SetScale(1.35,1,1.25)

        if self.addextraslots == nil then
            self.addextraslots = 1

            self:AddEquipSlot(GLOBAL.EQUIPSLOTS.BACK, "images/uiimages/back.xml", "back.tex")
            self:AddEquipSlot(GLOBAL.EQUIPSLOTS.NECK, "images/uiimages/neck.xml", "neck.tex")

            if self.inspectcontrol then
                local W = 68
                local SEP = 12
                local INTERSEP = 28
                local inventory = self.owner.replica.inventory
                local num_slots = inventory:GetNumSlots()
                local num_equip = #self.equipslotinfo
                local num_buttons = self.controller_build and 0 or 1
                local num_slotintersep = math.ceil(num_slots / 5)
                local num_equipintersep = num_buttons > 0 and 1 or 0
                local total_w = (num_slots + num_equip + num_buttons) * W + (num_slots + num_equip + num_buttons - num_slotintersep - num_equipintersep - 1) * SEP + (num_slotintersep + num_equipintersep) * INTERSEP
                self.inspectcontrol.icon:SetPosition(-4, 6)
                self.inspectcontrol:SetPosition((total_w - W) * .5 + 3, -6, 0)
            end
        end
    end

    function Inv:Refresh()
        Inv_Refresh_base(self)
        Inv:LoadExtraSlots(self)
    end

    function Inv:Rebuild()
        Inv_Rebuild_base(self)
        Inv:LoadExtraSlots(self)
    end
end)

env.AddComponentPostInit("inventory", function(self)
    local old_Equip = self.Equip
    self.Equip = function(self, item, old_to_active)
        if old_Equip and old_Equip(self, item, old_to_active) then
            if item and item.components and item.components.equippable and item.components.container then
                local eslot = item.components.equippable.equipslot;
                if self.equipslots[eslot] ~= item and item.components.equippable.equipslot == GLOBAL.EQUIPSLOTS.BACK then
                    self.inst:PushEvent("setoverflow", { overflow = item })
                end
                self.heavylifting = item:HasTag("heavy")
            end
            return true
        end
    end

    local old_GetOverflowContainer = self.GetOverflowContainer
    self.GetOverflowContainer = function(self)
        local item = nil
        if GLOBAL.EQUIPSLOTS.BACK then
            item = self:GetEquippedItem(GLOBAL.EQUIPSLOTS.BACK)
        end
        if item and not item:HasTag(TUNING.MONE_TUNING.EXTRA_EQUIP_SLOTS_ON_TAG) then
            if self.ignoreoverflow then
                return
            end
            return (item ~= nil and item.components.container ~= nil and item.components.container.canbeopened) and
                    item.components.container or
                    nil
        else
            if old_GetOverflowContainer then
                old_GetOverflowContainer(self)
            end
        end
    end
end
)

env.AddPrefabPostInit("inventory_classified", function(inst)
    if not TheWorld.ismastersim then
        local old_GetOverflowContainer = inst.GetOverflowContainer
        inst.GetOverflowContainer = function(inst)
            local item = nil
            if GLOBAL.EQUIPSLOTS.BACK then
                item = inst.GetEquippedItem(inst, GLOBAL.EQUIPSLOTS.BACK)
            end
            if item and not item:HasTag(TUNING.MONE_TUNING.EXTRA_EQUIP_SLOTS_ON_TAG) then
                if inst.ignoreoverflow then
                    return
                end
                return item ~= nil and item.replica.container or nil
            else
                if old_GetOverflowContainer then
                    old_GetOverflowContainer(inst)
                end
            end
        end
        return inst
    end
end)

local backpacks = {}
local amulets = {
    -- ԭ�滤��
    "amulet", "blueamulet", "purpleamulet", "orangeamulet", "greenamulet", "yellowamulet",
    -- ��������ģ�飨�ò����� 4/5/6��װ����������mod�棩ģ������ģ���ţ�2798599672��
    "brooch1", --������
    "brooch2",
    "brooch3",
    "brooch4",
    "brooch5",
    "brooch6",
    "brooch7",
    "brooch8",
    "brooch9",
    "moon_brooch",
    "star_brooch",
    "sora2amulet", --С�
    "sorabowknot",
    "luckamulet", --����ѧ
    "wharang_amulet", --ǧ���
    "ndnr_opalpreciousamulet", --����������
    "terraprisma", -- ���⽣
    "aria_seaamulet", -- �����
    "kemomimi_new_xianglian", -- С����
    "kemomimi_bell",
    "kemomimi_utr_xl",
    "philosopherstone", -- ������
    "ov_amulet1", -- ��ƽ��
    "ov_amulet2",
    "ov_bag2",
    "klaus_amulet", -- ������Э
    "ancient_amulet_red_demoneye",
    "oculet",
    "ancient_amulet_red",
    "jinshudaikou", -- ̩����Ʒ
    "zaishengshouhuan",
    "ruchongweijin"
}
local armors = {
    "armor_bramble", -- Bramble Husk
    "armordragonfly", -- Scalemail
    "armorgrass", -- Grass Suit
    "armormarble", -- Marble Suit
    "armorruins", -- Thulecite Suit
    "armor_sanity", -- Night Armour
    "armorskeleton", -- Bone Armor
    "armorwood", -- Log Suit
    "armor_medal_obsidian", -- ����ѫ��
    "armor_blue_crystal", -- ����ѫ��
    "golden_armor_mk", -- ����˵
    "yangjian_armor", -- ����˵
    "nz_damask", -- ����˵
    "armorsiving", -- ����˵
    "myth_iron_battlegear", -- ����˵
    "xe_bag", -- 诶�
    "icearmor", -- ����yuki
    "yuanzi_armor_lv1", -- ��ľ�@��
    "yuanzi_armor_lv2", -- ��ľ�@��
    "monvfu", -- ������
    "red_fairyskirt", -- ������
    "bule_fairyskirt", -- ������
    "sora2armor", -- С�
    "soraclothes", -- С�
    "purgatory_armor", -- ��¶ɯ
    "wharang_amulet_sack", -- ǧ���
    "ndnr_armorobsidian", -- ����
    "changchunjz", -- ս����Ů-�����Ľ�װ
    "veneto_jz", -- ս����Ů-ά���еĽ�װ
    "veneto_jzyf", -- ս����Ů-������ʽ��װ
    "fubuki_jz", -- ս����Ů-��ѩ�Ľ�װ
    "uniform_firemoths", -- ϣ��-���֮���Ʒ�
    "lijie_jz", --ս����Ů������-�������Ľ�װ
    "jianzhuang", --ս����Ů������-ŷ���Ľ�װ
    "fbk_jz", --ս����Ů������-��ѩ�Ľ�װ
    "lex_jz", --ս����Ů������-�п��ǶصĽ�װ
    "yukikaze_jz", --ս����Ů������-�������ײ�����װ
    "kahiro_dress", --kahiroѧԺ��
    "bf_nightmarearmor", --��ħ������
    "bf_rosearmor", --õ�廤��
    "aria_armor_red", --����櫡�����˿��¶��RE��
    "aria_armor_blue", --����櫡�����˿��¶��RE��
    "aria_armor_green", --����櫡�����˿��¶��RE��
    "aria_armor_purple", --����櫡�����˿��¶��RE��
    "armorlimestone", --����ʯ������װ
    "armorcactus", --���������ƻ���
    "armorobsidian", --���Ѻ���ʯ����
    "armorseashell", --���Ѻ��ױ���
    "suozi", --��������
    "bingxin", --��������
    "zhenfen", --��������
    "huomu", --��������
    "landun", --��������
    "riyan", --��������
    "kj", --��������
    "banjia", --��������
    "kemomiminewyifu", --С����
    "featheredtunic", --��¯
    "forge_woodarmor", --��¯
    "jaggedarmor", --��¯
    "silkenarmor", --��¯
    "splintmail", --��¯
    "steadfastarmor", --��¯
    "armor_hpextraheavy", --��¯
    "armor_hpdamager", --��¯
    "armor_hprecharger", --��¯
    "armor_hppetmastery", --��¯
    "reedtunic", --��¯
    "ov_armor", --��ƽ��
    "armor_glassmail", --����Э
    "feather_frock_fancy", --����Э
    "feather_frock", --����Э
    "xianrenzhangjia", --̩����Ʒ
    "nanguahujia", --̩����Ʒ
    "jinjia", --̩����Ʒ
    "seele_twinsdress", --ϣ��


    -- Armors: from the mod "More Armor" (<https://steamcommunity.com/sharedfiles/filedetails/?id=1153998909>)
    "armor_bone", -- Bone Suit
    "armor_stone", -- Stone Suit
}

-- Ӧ�ÿ��Լ�������ģ��
local function isBackpack(inst)
    if inst:HasTag("backpack") and inst:HasTag("_equippable") and inst:HasTag("_container")
            and not (inst.components.weapon)
    --and not (inst.components.fueled)
    --and not (inst.components.finiteuses)
    --and not (inst.components.perishable)
    then
        --print("---1");
        if inst.components.armor and not inst:HasTag("hide_percentage") then
            return false;
        end
        --print("---2");
        return true;
    end
    for _, v in ipairs(backpacks) do
        if inst.prefab == v then
            return true;
        end
    end
end

-- ֻ�ܾ�ȷ����һ��
local function isAmulet(inst)
    for _, v in ipairs(amulets) do
        if inst.prefab == v then
            return true;
        end
    end
end

local function isArmor(inst)
    for _, v in ipairs(armors) do
        if inst.prefab == v then
            return true;
        end
    end
end

env.AddPrefabPostInitAny(function(inst)
    inst:AddTag(TUNING.MONE_TUNING.EXTRA_EQUIP_SLOTS_ON_TAG);
    if not TheWorld.ismastersim then
        return inst;
    end
    if isArmor(inst) then
        inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.BODY;
        inst:RemoveTag(TUNING.MONE_TUNING.EXTRA_EQUIP_SLOTS_ON_TAG)
    end
    if isBackpack(inst) then
        inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.BACK or GLOBAL.EQUIPSLOTS.BODY;
        inst:RemoveTag(TUNING.MONE_TUNING.EXTRA_EQUIP_SLOTS_ON_TAG)
    end
    if isAmulet(inst) then
        inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.NECK or GLOBAL.EQUIPSLOTS.BODY;
        inst:RemoveTag(TUNING.MONE_TUNING.EXTRA_EQUIP_SLOTS_ON_TAG)
    end
end)

--������������
AddStategraphPostInit("wilson", function(self)
    for k, v in pairs(self.states) do
        if v and v.name == "amulet_rebirth" then
            local old_onexit = self.states[k].onexit

            self.states[k].onexit = function(inst)
                local item;
                if GLOBAL.EQUIPSLOTS.NECK then
                    item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.NECK)
                end
                if item and item.prefab and item.prefab == "amulet" then
                    item = inst.components.inventory:RemoveItem(item)
                    if item then
                        item:Remove()
                        item.persists = false
                    end
                end
                if old_onexit then
                    old_onexit(inst)
                end
            end
        end
    end
end)


