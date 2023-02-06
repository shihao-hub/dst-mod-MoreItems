---
--- @author zsh in 2023/1/8 14:43
---


local Tool = {};

function Tool.printSeq(seq)
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

        -- �� 8 ����
        do
            cnt = cnt + 1;
            if cnt % 8 == 0 then
                cnt = 0;
                table.insert(msg, table.concat(tmp, ", ", 1, #tmp));
                tmp = {};
            end
        end
    end
    -- �� 8 ����
    table.insert(msg, table.concat(tmp, ", ", 1, #tmp));

    return "Tool.printSeq:\n" .. table.concat(msg, ",\n", 1, #msg);
end

---@return string
function Tool.printTab(tab)
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

    return "Tool.printTab:\n" .. table.concat(msg, ",\n", 1, #msg);
end

---Role:�� { ... }
---Note:���봫������
function Tool.pack(...)
    local args = { ... };

    -- ����� args["n"] = �б���
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


return Tool;