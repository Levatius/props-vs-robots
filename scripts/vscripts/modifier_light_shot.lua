modifier_light_shot = class({})


function modifier_light_shot:IsDebuff()
    return true
end

function modifier_light_shot:OnCreated()
    if IsServer() then
        self:SetStackCount(1)
    end
end

function modifier_light_shot:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_light_shot:GetModifierMoveSpeedBonus_Percentage()
    return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("slow_amount")
end

function modifier_light_shot:OnRefresh()
    if IsServer() then
        self:IncrementStackCount()
    end
end