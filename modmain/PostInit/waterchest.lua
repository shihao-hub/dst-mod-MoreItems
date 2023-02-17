---
--- @author zsh in 2023/2/16 16:21
---

env.AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
        return inst;
    end

    -- 只检索口袋里！
    inst:ListenForEvent("onpickupitem", function(inst, data)
        local item = data and data.item;
        --print("item: " .. tostring(item));
        if item == nil then
            return ;
        end
        local water_chest_pocket;
        for _, v in pairs(inst.components.inventory.itemslots) do
            --print("", "", tostring(v.prefab));
            if v and v.prefab == "mone_waterchest_inv" then
                water_chest_pocket = v;
                break;
            end
        end
        --print("water_chest_pocket: " .. tostring(water_chest_pocket));
        if water_chest_pocket == nil then
            return ;
        end
        local container = water_chest_pocket.components.container;
        --print("container: " .. tostring(container));

        -- 不可堆叠的物品在容器未打开的状态下，塞不进去。这可能是联机版的特有情况。哎，绝了。
        if container and container:Has(item.prefab, 1) then
            --print("item: " .. tostring(item));
            --print("enter!");
            -- 有 Has 在不用加延迟了，但是没 Has 需要加个延迟！！！不然不行！！！
            -- 但是说实话，加了延迟会有点难受的！有Has在不用加延迟刚刚好！Nice
            --water_chest_pocket:DoTaskInTime(FRAMES, function(water_chest_pocket, container)
            --    container:GiveItem(item);
            --end, container)
            container:GiveItem(item);
        end
    end);
end)
