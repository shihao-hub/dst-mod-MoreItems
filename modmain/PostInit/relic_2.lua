---
--- @author zsh in 2023/1/30 0:52
---


-- 给拥有 fueled、finiteuses、armor、perishable 的预制物添加一个监听以及存值的变量
-- 同时呢？如果同时拥有多种组件，那么平分权重？算了先这样吧。
for _, v in ipairs({ "fueled", "finiteuses", "armor", "perishable" }) do
    env.AddComponentPostInit(v, function(self)

        self.inst:DoTaskInTime(0, function(inst)
            do
                local percent;
                if inst.components.fueled then
                    percent = inst.components.fueled:GetPercent();
                elseif inst.components.finiteuses then
                    percent = inst.components.finiteuses:GetPercent();
                elseif inst.components.armor then
                    percent = inst.components.armor:GetPercent();
                elseif inst.components.perishable then
                    percent = inst.components.perishable:GetPercent();
                end

                if percent then
                    --print("inst.mone_relic_2_percent: "..tostring(percent));
                    inst.mone_relic_2_percent = percent;
                end
            end

            -- 注意该监听重启时并不会执行
            inst:ListenForEvent("percentusedchange", function(inst, data)
                local percent = data and data.percent;
                if percent then
                    inst.mone_relic_2_percent = percent;
                end
            end);

        end);
    end)
end