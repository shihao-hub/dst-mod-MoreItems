---
--- @author zsh in 2023/1/26 19:43
---


-- TODO: ����ģ���ڲ�������Lua 5.1 ��̫�����ô�õġ�Lua 5.3 ���� _ENV

function c_GetPrefabNumber(prefabname)
    prefabname = tostring(prefabname);
    local num = 0;
    for guid, p in pairs(Ents) do
        if p.prefab == prefabname then
            num = num + 1;
        end
    end
    print(string.format("%s%s%d", prefabname, " 's number is: ", num));
    return num;
end








-----------------------------------------------------------------------------------------------------
--[[ ����¼��δ��ɰ汾 ]]
-----------------------------------------------------------------------------------------------------
--c_taskadd
function ta(content)
    if type(content) ~= "string" then
        return
    end
    -- local player = ConsoleCommandPlayer() or ThePlayer
    if TheNet:GetServerIsClientHosted() then
        if TheWorld.net.components.pytask then
            TheWorld.net.components.pytask:Add(content)
            return ;
        end
    end
    SendModRPCToServer(GetModRPC("py_task", "add"), content)
end

--c_taskdel
function td(index)
    if type(index) ~= "number" then
        if type(index) ~= "string" then
            return
        end
        index = tonumber(index)
        if index == nil then
            return ;
        end
    end
    -- local player = ConsoleCommandPlayer() or ThePlayer
    if TheNet:GetServerIsClientHosted() then
        if TheWorld.net.components.pytask then
            TheWorld.net.components.pytask:Del(index)
            return ;
        end
    end
    SendModRPCToServer(GetModRPC("py_task", "del"), index)
end

--c_taskclear
function tc()
    if TheNet:GetServerIsClientHosted() then
        if TheWorld.net.components.pytask then
            TheWorld.net.components.pytask:DelAll()
            return ;
        end
    end
    SendModRPCToServer(GetModRPC("py_task", "delall"))
end

function ts()
    SendModRPCToServer(GetModRPC("py_task", "show"));
end

function th()
    SendModRPCToServer(GetModRPC("py_task", "hide"));
end


-------------------------------------------------------------------------------------------------

function c_taskadd(content)
    ta(content);
end

function c_taskdel(index)
    td(index);
end

function c_taskclear()
    tc();
end

function c_taskshow()
    ts();
end

function c_taskhide()
    c_th();
end
