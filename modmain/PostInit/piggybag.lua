---
--- @author zsh in 2023/1/16 21:19
---


for _, p in ipairs({
    "lighter", "torch", "minerhat", "molehat",
    "pumpkin_lantern", "lantern", "thurible",
    "nightstick", "wx78module_light","wx78module_nightvision"
}) do
    env.AddPrefabPostInit(p, function(inst)
        inst:AddTag("mone_piggybag_itemtesttag");
    end)
end