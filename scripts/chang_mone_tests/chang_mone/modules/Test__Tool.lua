---
--- @author zsh in 2023/1/8 16:40
---

local __Tool = require("chang_mone.modules.__Tool");
-- nil, boolean, number, string, function, table, thread, userdata

--print(__Tool.printTab({
--    [1] = 2,
--    ["abc"] = 3,
--    a = function()
--    end,
--    [true] = false
--}));
--
--print(__Tool.printSeq({
--    true, 1, "abc", {}, function()
--    end, 2, 3, 4, 5, 6, 7, 8, 9, 10
--}));

print(__Tool.printTab(__Tool.pack(1, 2, 3, nil, 4)));


