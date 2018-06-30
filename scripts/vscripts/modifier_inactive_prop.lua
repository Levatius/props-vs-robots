modifier_inactive_prop = class({})


function modifier_inactive_prop:OnCreated()
    if IsServer() then
        self:GetParent():AddNoDraw()
    end
end

function modifier_inactive_prop:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveNoDraw()
    end
end

function modifier_inactive_prop:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
    }
end

function modifier_inactive_prop:GetModifierProvidesFOWVision()
    return 1
end

function modifier_inactive_prop:CheckState()
    return {
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_BLIND] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true
    }
end