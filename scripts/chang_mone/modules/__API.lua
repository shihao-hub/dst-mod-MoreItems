---
--- @author zsh in 2023/1/8 14:26
---

local __Tool = require("chang_mone.modules.__Tool");

local __API = {};

function __API.xpcall(fun, msgh, arg1, ...)
    local oldMsgh = msgh;
    msgh = function(msg)
        print('__API.xpcall --> ERROR!!!', msg);
        if oldMsgh and type(oldMsgh) == "function" then
            oldMsgh(msg);
        end
    end

    local res = __Tool.pack(xpcall(fun, msgh, arg1, ...));

    if (not res[1]) then
        return nil; -- 不同于 xpcall，此处只返回一个 nil，表明存在执行错误
    end

    table.remove(res, 1);
    if res.n then
        res.n = res.n - 1;
    end
    return unpack(res);
end

do
    print(__API.xpcall(function()
        return 1,2,3,nil,4
    end));
end

return __API;