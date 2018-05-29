modifier_light_shot = class({})


function modifier_light_shot:IsDebuff()
    return true
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
    self:IncrementStackCount()
end