revert = class({})
LinkLuaModifier("modifier_revert", LUA_MODIFIER_MOTION_NONE)


function revert:GetIntrinsicModifierName()
    return "modifier_revert"
end

function revert:OnSpellStart()
    if IsServer() then
        local caster = self:GetCaster()
        ParticleManager:DestroyParticle(caster.revert_particles, false)
        StopSoundOn("Hero_KeeperOfTheLight.Recall.Cast", caster)
        EmitSoundOn("Hero_KeeperOfTheLight.Recall.End", caster)

        local new_health = math.ceil(caster.hero:GetMaxHealth() * caster:GetHealthPercent() / 100)
        caster.hero:ModifyHealth(new_health, nil, false, 0)
        caster:Kill(nil, nil)
    end
end

function revert:OnAbilityPhaseStart()
    if IsServer() then
        local caster = self:GetCaster()
        caster.revert_particles = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
        ParticleManager:SetParticleControl(caster.revert_particles, 0, caster:GetOrigin())
        EmitSoundOn("Hero_KeeperOfTheLight.Recall.Cast", caster)
        return true
    end
end

function revert:OnAbilityPhaseInterrupted()
    if IsServer() then
        local caster = self:GetCaster()
        ParticleManager:DestroyParticle(caster.revert_particles, false)
        StopSoundOn("Hero_KeeperOfTheLight.Recall.Cast", caster)
        EmitSoundOn("Hero_KeeperOfTheLight.Recall.Fail", caster)
    end
end