---
--- @author zsh in 2023/1/12 1:09
---


local f,msg = loadfile("chang_mone/tests/1.lua");
if not f then
    print(msg);
else
    for _, v in ipairs({f()}) do
        print(tostring(v[1]));
    end
end