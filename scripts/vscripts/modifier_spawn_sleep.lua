modifier_spawn_sleep = class({})


function modifier_spawn_sleep:IsDebuff()
    return true
end

function modifier_spawn_sleep:GetTexture()
    return "spawn_sleep"
end

function modifier_spawn_sleep:OnDestroy()
    if IsServer() then
        PlayerResource:SetCameraTarget(self:GetParent():GetPlayerID(), nil)
    end
end

function modifier_spawn_sleep:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
end

function modifier_spawn_sleep:GetOverrideAnimation()
    return ACT_DOTA_IDLE_SLEEPING
end

function modifier_spawn_sleep:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_BLIND] = true,
        [MODIFIER_STATE_INVULNERABLE] = true
    }
end