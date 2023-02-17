--[[
Copyright (C) 2019 Zarklord

This file is part of Gem Core.

The source code of this program is shared under the RECEX
SHARED SOURCE LICENSE (version 1.0).
The source code is shared for referrence and academic purposes
with the hope that people can read and learn from it. This is not
Free and Open Source software, and code is not redistributable
without permission of the author. Read the RECEX SHARED
SOURCE LICENSE for details 
The source codes does not come with any warranty including
the implied warranty of merchandise. 
You should have received a copy of the RECEX SHARED SOURCE
LICENSE in the form of a LICENSE file in the root of the source
directory. If not, please refer to 
<https://raw.githubusercontent.com/Recex/Licenses/master/SharedSourceLicense/LICENSE.txt>
]]
local env = env
GLOBAL.setfenv(1, GLOBAL) -- chang: Level 1 is the function calling `setfenv`.
-- chang: 设置 GLOBAL 的目的和 GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k); end }) 应该是一样的


local gempackage = {
    loaders = {},
    preload = {}, -- 存储一些自定义的loader？ k-函数名 v-函数内容
    loaded = {}, -- k-函数名 v-执行后的返回值列表
    reload = {}
}

-- 这里的步骤应该就是 Lua 的前置操作，好几张表
table.insert(gempackage.loaders, function(functionname)
    if gempackage.preload[functionname] ~= nil then
        -- 调用过 MakeGemFunction 才有可能进入此判断域
        return gempackage.preload[functionname] -- chang 返回值为函数
    else
        return string.format("\n\tno field gempackage.preload['%s']", functionname)
    end
end)


table.insert(gempackage.loaders, function(functionname)
    local filename = env.MODROOT .. "gemscripts/" .. functionname .. ".lua"
    local result = kleiloadlua(filename) -- chang: kleiloadlua
    if type(result) == "string" then
        error(string.format("error loading gemrun module '%s' from file '%s':\n\t%s", functionname, filename, result))
    elseif type(result) == "function" then
        setfenv(result, _G) -- `env.GLOBAL = _G` + `_G._G = _G` --> _G 其实就是 GLOBAL._G
    elseif result == nil then
        return "\n\tno file '" .. filename .. "'"
    end
    return result
end)

-- Question 这是在干嘛？就是把函数都执行一遍吗。感觉这就是 Lua 的执行步骤吧！
function env.gemrun(functionname, ...) -- functionname应该是module_name 吧？
    if gempackage.loaded[functionname] then
        return unpack(gempackage.loaded[functionname])
    end
    local result, errormessageaccumulator, i = nil, "", 1
    while true do
        local loader = gempackage.loaders[i]
        if not loader then
            error(string.format("gemrun function '%s' not found:%s", functionname, errormessageaccumulator))
        end
        result = loader(functionname)
        if type(result) == "function" then
            break -- chang 找到函数才会返回
        elseif type(result) == "string" then
            errormessageaccumulator = errormessageaccumulator .. result
        end
        i = i + 1
    end
    local modresult = { result(functionname, ...) }
    if not gempackage.reload[functionname] then
        if modresult ~= nil then
            gempackage.loaded[functionname] = modresult
        else
            gempackage.loaded[functionname] = true
        end
    end
    return unpack(modresult)
end

local function MakeGemFunction(functionname, preload, reload)
    gempackage.preload[functionname] = preload
    gempackage.reload[functionname] = reload
    gempackage.loaded[functionname] = nil
end

local function DeleteGemFunction(functionname)
    gempackage.preload[functionname] = function()
    end
    gempackage.reload[functionname] = false
    gempackage.loaded[functionname] = nil
end

DeleteGemFunction("gemrun")
MakeGemFunction("gemfunctionmanager", function(functionname, ...)
    return MakeGemFunction, DeleteGemFunction
end)