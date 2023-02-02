---
--- @author zsh in 2023/1/30 11:03
---

-- function 虽然有功能的意思，但是第一感觉都是函数。虽然 method 第一感觉也是函数。。。
-- common methods: 常用功能

-------------------------------************* 局部化 ************--------------------------
local _G = GLOBAL
local Point, Vector3, type, tostring, tonumber, GetTime, pairs, ipairs, SpawnPrefab, TheSim, FRAMES, pcall, TheWorld, jsbao, jsjie = Point, Vector3, type, tostring, tonumber, GetTime, pairs, ipairs, SpawnPrefab, TheSim, FRAMES, pcall, TheWorld, json.encode, json.decode
local Point, Vector3, type, tostring, tonumber, GetTime, pairs, ipairs = _G.Point, _G.Vector3, type, _G.tostring, _G.tonumber, _G.GetTime, pairs, ipairs
local SpawnPrefab, TheSim, FRAMES, pcall, jsbao, jsjie, PI = _G.SpawnPrefab, _G.TheSim, _G.FRAMES, _G.pcall, _G.json.encode, _G.json.decode, _G.PI
local table, next, string, TheNet, unpack, distsq, STRINGS, Sleep = _G.table, _G.next, string, _G.TheNet, _G.unpack, _G.distsq, _G.STRINGS, _G.Sleep
-------->>>>>>>>>>>>>>>>>>>>>>>>>>
local isstr = function(vla)
    return type(vla) == "string"
end
local isnum = function(vla)
    return type(vla) == "number"
end
local isnil = function(vla)
    return type(vla) == "nil"
end
local isbool = function(vla)
    return type(vla) == "boolean"
end
local istbl = function(vla)
    return type(vla) == "table"
end
local isfnn = function(vla)
    return type(vla) == "function"
end
local isuser = function(vla)
    return type(vla) == "userdata"
end
-------->>>>>>>>>>>>>>>>>>>>>>>>>>