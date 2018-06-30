modifier_fow_visible = class({})


function modifier_fow_visible:OnCreated()
    if IsServer() then
        self:GetParent():SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
        self:StartIntervalThink(1)
    end
end

function modifier_fow_visible:OnDestroy()
    if IsServer() then
        self:GetParent():SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
    end
end

function modifier_fow_visible:OnIntervalThink()
    if IsServer() then
        local player = self:GetParent():GetPlayerOwner()
        player.stats["still"] = player.stats["still"] + 1
    end
end

function modifier_fow_visible:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
    return funcs
end

function modifier_fow_visible:GetModifierProvidesFOWVision()
    return 1
end

function modifier_fow_visible:GetModifierConstantHealthRegen()
    return  self:GetAbility():GetSpecialValueFor("heal_rate")
end

function modifier_fow_visible:OnTakeDamage(event)
    if IsServer() then
        if event.unit == self:GetParent() then
            if self:GetAbility():GetToggleState() then
                self:GetAbility():ToggleAbility()
            end
        end
    end
end
