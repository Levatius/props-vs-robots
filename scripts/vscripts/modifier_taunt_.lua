modifier_taunt_ = class({})


function modifier_taunt_:IsHidden()
    return true
end

function modifier_taunt_:OnCreated()
    if IsServer() then
        local index = ParticleManager:CreateParticle("particles/econ/events/ti5/blink_dagger_start_ti5.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(index, 0, self:GetParent():GetOrigin())
        ParticleManager:ReleaseParticleIndex(index)
    end
end

function modifier_taunt_:OnDestroy()
    if IsServer() then
        local index = ParticleManager:CreateParticle("particles/econ/events/ti5/blink_dagger_end_ti5.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(index, 0, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl(index, 1, self:GetParent():GetOrigin())
        ParticleManager:ReleaseParticleIndex(index)
    end
end

function modifier_taunt_:CheckState()
    return {
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true
    }
end

function modifier_taunt_:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PRESERVE_PARTICLES_ON_MODEL_CHANGE,
        MODIFIER_PROPERTY_MODEL_CHANGE
    }
end

function modifier_taunt_:MODIFIER_PROPERTY_PRESERVE_PARTICLES_ON_MODEL_CHANGE()
    return true
end

function modifier_taunt_:GetModifierModelChange()
    return "models/development/invisiblebox.vmdl"
end
