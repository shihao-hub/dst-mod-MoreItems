---
--- @author zsh in 2023/1/8 16:44
---


local __API = require("chang_mone.modules.__API");

local f, msg = loadfile("chang_mone/tests/1.lua");
print(f, msg);
print(__API.xpcall((loadfile("chang_mone/tests/1.lua"))));