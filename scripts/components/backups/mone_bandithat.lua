---
--- @author zsh in 2023/1/17 21:41
---


local Bandit = Class(function(self, inst)
    self.inst = inst;
    self.items = {};
    self.equip_status = false;
end);

function Bandit:SetEquipStatus(status)
    self.equip_status = status;
    if status then
        self.inst:StartUpdatingComponent(self);
    else
        self.inst:StopUpdatingComponent(self);
    end
end

function Bandit:GetEquipStatus()
    return self.equip_status;
end

--[[ ���ͻ�ͨ�� �������ǳ���Ҫ��д�����������ˢ�£�2023-01-17-22:26 ��Ҫ�ҵ�Դ����ú��Ķ��� ]]
function Bandit:OnUpdate(dt)
    -- dt ������kleiĬ�ϵ�ʱ������
    -- TEMP ??? Ϊʲôû����Ч�� 202301172256 ��˵�ɣ����� debug
    if self:GetEquipStatus() then
        local x, y, z = self.inst.Transform:GetWorldPosition();
        local DIST = 32;
        local MUST_TAGS = { "_combat", "_health" };
        local CANT_TAGS = { "INLIMBO", "player"--[[, "epic"]]};
        local ents = TheSim:FindEntities(x, y, z, DIST, MUST_TAGS, CANT_TAGS);
        local current_items = {}; -- ��ǰ��ѯ������������������Ԥ�����б���ʱ����/���棩������ǰ��Ч��Ԥ�����б�
        local items = self.items; -- ������Ч��Ԥ�����б�
        for _, p in ipairs(ents) do
            if p and current_items[p] == nil then
                p.mone_bandit_near = true; -- ��ӱ�ǩ��ȷ����������������Ա�
                current_items[p] = true;
                self.items[p] = true;
            end
        end
        -- ����������Ч��Ԥ�����б�
        for p, _ in pairs(self.items) do
            -- p.components.combat:DropTarget() ���ڶ�ʧ���
            if p and current_items[p] == nil then
                self.items[p] = nil;
                p.mone_bandit_near = nil;
            end
        end
        -- ����˵�����ǱȽ���һ�κ͵�ǰ��Σ��õ�����������˵������ʧЧ��d
    end
end

return Bandit;