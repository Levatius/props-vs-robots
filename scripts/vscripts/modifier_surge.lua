modifier_surge = class({})


function modifier_surge:GetStatusEffectName()
    return "particles/status_fx/status_effect_overpower.vpcf"
end

function modifier_surge:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true
    }
end

function modifier_surge:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE
    }
    return funcs
end

function modifier_surge:GetModifierMoveSpeedOverride()
    return self:GetAbility():GetSpecialValueFor("move_speed")
end