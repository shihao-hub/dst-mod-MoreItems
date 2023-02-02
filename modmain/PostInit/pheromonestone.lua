---
--- @author zsh in 2023/1/12 18:42
---

--[[ 20230122 �������ƣ�һЩ��Ʒ���������;ã�����д�� actions.lua  ]]

-- װ������
env.AddPrefabPostInit("mone_pheromonestone", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    if inst.components.mone_pheromonestone == nil then
        inst:AddComponent("mone_pheromonestone"); -- ����ֻ�����ڶ�����ӵ����
    end
end)

for _, com in ipairs({ "fueled", "finiteuses", "armor" }) do
    env.AddComponentPostInit(com, function(self)
        self.inst:AddComponent("mone_pheromonestone_infinite"); -- ����ʹװ�����;õ����
    end)
end

-- ���Ѿ�������ΪʲôҪ����д�ˡ�����ΪʲôҪ�ֿ������������ˣ�equippable���������perishable֮����ӣ���
env.AddComponentPostInit("perishable", function(self)
    self.inst:DoTaskInTime(0, function()
        if self.inst and self.inst.components.equippable then
            self.inst:AddComponent("mone_pheromonestone_infinite"); -- ����ʹװ�����;õ����
        end
    end)
end)

-- 202301181035 ������һ����� mone_pheromonestone_infinite ����Ķ��� equippable �ģ��Ȳ����ˡ�