modifier_active_prop = class({})


function modifier_active_prop:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
    }
end

function modifier_active_prop:GetModifierProvidesFOWVision()
    return 1
end

function modifier_active_prop:CheckState()
    return {
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_BLIND] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true
    }
end