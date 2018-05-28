modifier_startle = class({})


function modifier_startle:IsDebuff()
    return true
end

function modifier_startle:GetTexture()
    return "startle"
end

function modifier_startle:GetStatusEffectName()
    return "particles/status_fx/status_effect_sylph_wisp_fear.vpcf"
end

function modifier_startle:OnCreated()
    self.startle_slow = self:GetAbility():GetSpecialValueFor("startle_slow")
    if IsServer() then
        local index = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_debuff.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(index, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true)
        self:AddParticle(index, false, false, -1, false, true)
    end
end

function modifier_startle:CheckState()
    return {
        [MODIFIER_STATE_SILENCED] = true
    }
end

function modifier_startle:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_startle:GetModifierMoveSpeedBonus_Percentage()
    return self.startle_slow
end