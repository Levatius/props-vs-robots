modifier_pogo = class({})


function modifier_pogo:IsHidden()
    return true
end

function modifier_pogo:OnCreated()
    self.max_range_index = nil
    self:StartIntervalThink(0.1)
end

function modifier_pogo:OnIntervalThink()
    if IsServer() then
        local parent = self:GetParent()
        if parent:HasModifier("modifier_bounce") then
            if self.max_range_index ~= nil then
                ParticleManager:DestroyParticle(self.max_range_index, false)
                self.max_range_index = nil
            end
        else
            local ability = parent:FindAbilityByName("bounce")
            if self.max_range_index == nil then
                self.max_range_index = ParticleManager:CreateParticleForPlayer("particles/units/heroes/hero_monkey_king/monkey_king_furarmy_ring_bright.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent, parent:GetPlayerOwner())
                ParticleManager:SetParticleControl(self.max_range_index, 0, parent:GetOrigin())
                ParticleManager:SetParticleControl(self.max_range_index, 1, Vector(ability:GetSpecialValueFor("cast_range"), 1, 1))
            end
        end
    end
end

function modifier_pogo:CheckState()
    return {
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true
    }
end