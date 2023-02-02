---
--- @author zsh in 2023/1/8 14:43
---


local __Tool = {};

function __Tool.printSeq(seq)
    local msg = {};
    local tmp = {};
    local cnt = 0;
    for _, v in ipairs(seq) do
        if type(v) == "boolean" then
            table.insert(tmp, string.format("%s", v and "true" or "false"));
        elseif type(v) == "number" then
            table.insert(tmp, string.format("%s", v));
        elseif type(v) == "string" then
            table.insert(tmp, string.format("%q", v));
        else
            table.insert(tmp, string.format("%s", type(v)));
        end

        -- 逢 8 换行
        do
            cnt = cnt + 1;
            if cnt % 8 == 0 then
                cnt = 0;
                table.insert(msg, table.concat(tmp, ", ", 1, #tmp));
                tmp = {};
            end
        end
    end
    -- 逢 8 换行
    table.insert(msg, table.concat(tmp, ", ", 1, #tmp));

    return "__Tool.printSeq:\n" .. table.concat(msg, ",\n", 1, #msg);
end

---@return string
function __Tool.printTab(tab)
    local msg = {};
    for k, v in pairs(tab) do
        local str = "";

        local function printBoolean(val)
            local bool_num_str = type(val) == "boolean" and (val and "true" or "false") or val;
            return bool_num_str;
        end

        local function isBoolNumStr(val)
            return type(val) == "boolean" or type(val) == "number" or type(val) == "string";
        end

        if type(k) == "boolean" or type(k) == "number" then
            if isBoolNumStr(v) then
                str = string.format("[%s] = %s", printBoolean(k), printBoolean(v));
            else
                str = string.format("%s = %s", k, type(v));
            end
        elseif type(k) == "string" then
            if isBoolNumStr(v) then
                str = string.format("[%q] = %s", printBoolean(k), printBoolean(v));
            else
                str = string.format("[%q] = %s", k, type(v));
            end
        else
            if isBoolNumStr(v) then
                str = string.format("[%s] = %s", printBoolean(k), printBoolean(v));
            else
                str = string.format("[%s] = %s", type(k), type(v));
            end
        end

        table.insert(msg, str);
    end

    return "__Tool.printTab:\n" .. table.concat(msg, ",\n", 1, #msg);
end

---Role:即 { ... }
---Note:必须传入序列
function __Tool.pack(...)
    local args = { ... };

    -- 添加项 args["n"] = 列表长度
    do
        local keys = {};
        for k, _ in pairs(args) do
            table.insert(keys, k);
        end
        table.sort(keys);
        args.n = keys[#keys];
    end

    return args;
end


return __Tool;