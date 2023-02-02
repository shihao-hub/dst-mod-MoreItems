---
--- @author zsh in 2023/1/23 4:36
---


local prefabs = {
    "pocketwatch_revive", -- �ڶ��λ����
    "pocketwatch_heal", --���ϱ�
    "pocketwatch_weapon", --����� ����
    --"pocketwatch_warp", --���߱���ȷʵ��Ӧ������ţ�
    "pocketwatch_dismantler", --�ӱ�����
    "pocketwatch_revive", --�ڶ��λ����

    -- �Ҿ��ò�Ӧ�ÿ��ԷŲ��ϣ���Ӧ�ô���һ�㣡
    --"nightmarefuel", -- ج��ȼ��
    --"pocketwatch_parts", --ʱ����Ƭ
    --"marble", -- ����ʯ

    --"rope", -- ����
}
if TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.mone_wanda_box_itemtestfn_extra1 then
    table.insert(prefabs, "pocketwatch_warp"); -- ���߱�
end
if TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.mone_wanda_box_itemtestfn_extra2 then
    table.insert(prefabs, "pocketwatch_portal"); -- �ѷ��
    table.insert(prefabs, "pocketwatch_recall"); -- ��Դ��
end
for _, p in ipairs(prefabs) do
    env.AddPrefabPostInit(p, function(inst)
        inst:AddTag("mone_wanda_box_itemtestfn");
        if p == "pocketwatch_revive" then
            inst:AddTag("mone_wanda_box_pocketwatch_revive");
        end
    end)
end

env.AddPrefabPostInit("wanda", function(inst)
    if not TheWorld.ismastersim then
        return inst;
    end
    inst:ListenForEvent("death", function(inst)
        -- �˴���ִ�л��ǵ���������Ʒ��ִ�У�
        -- ����������inventory����Ĺ��캯���С����Դ˴�Ϊ�󷢣����˴�ȷʵִ���˵ġ�������ȷ��������
        local inventory = inst.components.inventory;
        if inventory then
            local boxs = inventory:FindItems(function(item)
                return item and item.prefab == "mone_wanda_box";
            end) or {};
            local pocketwatch_revive;
            for _, con in ipairs(boxs) do
                local container = con.components.container;
                if container then
                    pocketwatch_revive = container:FindItem(function(item)
                        return item and item.prefab == "pocketwatch_revive";
                    end);
                    if pocketwatch_revive then
                        container:DropEverythingWithTag("mone_wanda_box_pocketwatch_revive");
                        break ; -- ֻ�ҵ���һ��������ѭ��
                    end
                end
            end
        end

        -- ������ΧĿ��
        --local x, y, z = inst.Transform:GetWorldPosition();
        --local boxs = TheSim:FindEntities(x, y, z, 8, { "mone_wanda_box" }, nil) or {};
        --local pocketwatch_revive;
        --for _, con in ipairs(boxs) do
        --    local container = con.components.container;
        --    if container then
        --        pocketwatch_revive = container:FindItem(function(item)
        --            return item and item.prefab == "pocketwatch_revive";
        --        end);
        --        if pocketwatch_revive then
        --            container:DropEverythingWithTag("mone_wanda_box_pocketwatch_revive");
        --            break ;
        --        end
        --    end
        --end
    end);
end)

env.AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
        return inst;
    end
    -- ����װ��������û���������������ˣ�̫�鷳��
    --inst:ListenForEvent("death", function(inst)
    --    -- �˴���ִ�л��ǵ���������Ʒ��ִ�У�
    --    -- ����������inventory����Ĺ��캯���С����Դ˴�Ϊ�󷢣����˴�ȷʵִ���˵ġ�������ȷ��������
    --    local inventory = inst.components.inventory;
    --    if inventory then
    --        local boxs = inventory:FindItems(function(item)
    --            return item and item.prefab == "mone_wanda_box";
    --        end) or {};
    --        local pocketwatch_revive;
    --        for _, con in ipairs(boxs) do
    --            local container = con.components.container;
    --            if container then
    --                pocketwatch_revive = container:FindItem(function(item)
    --                    return item and item.prefab == "pocketwatch_revive";
    --                end);
    --                if pocketwatch_revive then
    --                    container:DropEverythingWithTag("mone_wanda_box_pocketwatch_revive");
    --                    break ; -- ֻ�ҵ���һ��������ѭ��
    --                end
    --            end
    --        end
    --    end
    --end);
end)