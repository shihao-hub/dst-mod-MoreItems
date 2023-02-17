---
--- @author zsh in 2023/1/16 21:19
---


for _, p in ipairs({
    "lighter", "torch", "minerhat", "molehat",
    "pumpkin_lantern", "lantern", "thurible",
    "nightstick", "wx78module_light","wx78module_nightvision",
    "yellowamulet",
    --"mie_bundle_state1","mie_bundle_state2",
    "giftwrap", "bundlewrap",
}) do
    env.AddPrefabPostInit(p, function(inst)
        inst:AddTag("mone_piggybag_itemtesttag");
    end)
end