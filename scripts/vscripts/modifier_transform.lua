modifier_transform = class({})


function modifier_transform:IsHidden()
    return true
end

function modifier_transform:CheckState()
    local state = {}
    state[MODIFIER_STATE_STUNNED] = true
    state[MODIFIER_STATE_NOT_ON_MINIMAP] = true
    state[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true
    state[MODIFIER_STATE_NO_HEALTH_BAR] = true
    state[MODIFIER_STATE_UNSELECTABLE] = true
    state[MODIFIER_STATE_OUT_OF_GAME] = true
    state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
    state[MODIFIER_STATE_NO_TEAM_SELECT] = true
    state[MODIFIER_STATE_BLIND] = true
    return state
end
