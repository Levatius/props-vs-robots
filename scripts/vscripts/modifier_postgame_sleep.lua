modifier_postgame_sleep = class({})


function modifier_postgame_sleep:IsHidden()
    return true
end

function modifier_postgame_sleep:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_BLIND] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true
    }
end