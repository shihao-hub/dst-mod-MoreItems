---
--- @author zsh in 2023/1/24 21:10
---

-- TEST ��չ�������˹���һ�����������ǵ��ϵ�����ô���أ�
--[[ ������������һ����������ݼ����ɴ� ]]
local CONTAINER; -- �����Ҫ�ø������ָ���ı���Ԥ����ĺ������У�
env.AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
        return inst;
    end

end)

-- Question: ���д�ͻ��˵Ļ����ҿ϶���������֪����ݼ����ʹ�á��������Ҫȥ�˽��˽⡣
TheInput:AddKeyHandler(function(key, down)
    if down then
        if key == 278 then
            local inst = CONTAINER;
            if inst and inst.components.container then

            end
        end
    end
end)