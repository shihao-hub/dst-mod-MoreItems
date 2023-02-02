---
--- @author zsh in 2023/1/12 5:21
---

env.AddComponentPostInit("temperature", function(self)
    if not TheWorld.ismastersim then
        return self
    end
    local old_SetTemperature = self.SetTemperature
    function self:SetTemperature(value, ...)

        local function hasTag(self)
            if self.inst and self.inst:HasTag("mone_brainjelly_const_temperature") then
                return true
            end
            return false
        end

        if value < 10 and hasTag(self) then
            value = 10
        end

        if value > (self.overheattemp - 10) and hasTag(self) then
            value = self.overheattemp - 10
        end
        return old_SetTemperature(self, value, ...)
    end
end)