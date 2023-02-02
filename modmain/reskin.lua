---
--- @author zsh in 2023/1/9 18:09
---


local API = require("chang_mone.dsts.API");

local config_data = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA;

API.reskin("backpack", "swap_backpack", {
    "mone_backpack"
});

API.reskin("piggyback", "swap_piggyback", {
    "mone_piggyback"
});

API.reskin("firesuppressor", "firefighter", {
    "mone_firesuppressor"
});

API.reskin("treasurechest", "treasure_chest", {
    "mone_treasurechest"
});
API.reskin("dragonflychest", "dragonfly_chest", {
    "mone_dragonflychest"
});
API.reskin("icebox", "ice_box", {
    "mone_icebox"
});
API.reskin("saltbox", "saltbox", {
    "mone_saltbox"
});
API.reskin("wardrobe", "wardrobe", {
    "mone_wardrobe"
});
API.reskin("moondial", "moondial_build", {
    "mone_moondial"
});

API.reskin("seedpouch", "seedpouch", {
    "mone_seedpouch"
});

--if TUNING.MONE_TUNING.WORKSHOP_2916323210_ON then
--    API.reskin("seedpouch","seedpouch",{
--        "mone_skin_seedpouch"
--    });
--end

-- Â·µÆÌ×Æ¤¸öÄ¢¹½µÆ»ò¾úÉ¡µÆÊÔÊÔ
-- ËãÁË£¬Òª¸Ä build °É£¡
--if config_data.mone_city_lamp_reskin == 1 then
--    API.reskin("mushroom_light", "mushroom_light", {
--        "mone_city_lamp"
--    });
--elseif config_data.mone_city_lamp_reskin == 2 then
--    API.reskin("mushroom_light2", "mushroom_light2", {
--        "mone_city_lamp"
--    });
--end
