---
--- @author zsh in 2023/1/8 16:52
---


--print("hello");



--local function t1()
--    local function t2()
--        local function t3()
--            error(debug.traceback())
--        end
--        t3();
--    end
--    t2();
--end
--
--t1();


--local t = {};
--print(t[1]);io.flush();
--
--table.insert(t, table.remove({}, 1));
--
--local t2 = {};
--table.insert(t2, nil);

--
--local b = true;
--print(string.format("%s", b == true and "true" or "xxx"));

--local function pr()
--    print("-------");
--    return 1;
--end
--
--local t = {
--    [1] = pr()
--}
--
--print(t[1]);

return {1},{2},{3}