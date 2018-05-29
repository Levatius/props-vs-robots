modifier_bounce_stack = class({})


function modifier_bounce_stack:IsDebuff()
    return true
end

function modifier_bounce_stack:OnCreated()
    if IsServer() then
        local parent = self:GetParent()

        self:IncrementStackCount()

        self.index = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, parent)
        ParticleManager:SetParticleControl(self.index, 0, parent:GetOrigin())
        ParticleManager:SetParticleControl(self.index, 1, Vector(0, self:GetStackCount(), 0))
    end
end

function modifier_bounce_stack:OnDestroy()
    if IsServer() then
        ParticleManager:DestroyParticle(self.index, false)
    end
end

function modifier_bounce_stack:OnRefresh()
    if IsServer() then
        local parent = self:GetParent()

        self:IncrementStackCount()

        if self.index ~= nil then
            ParticleManager:SetParticleControl(self.index, 1, Vector(0, self:GetStackCount(), 0))
        else
            self.index = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, parent)
            ParticleManager:SetParticleControl(self.index, 0, parent:GetOrigin())
            ParticleManager:SetParticleControl(self.index, 1, Vector(0, self:GetStackCount(), 0))
        end

        if self:GetStackCount() == self:GetAbility():GetSpecialValueFor("stacks_required") then
            local damage = {
                victim = parent,
                attacker = self:GetCaster(),
                damage = self:GetAbility():GetSpecialValueFor("damage"),
                damage_type = DAMAGE_TYPE_PURE,
                ability = self:GetAbility()
            }
            ApplyDamage(damage)
            local impact_index = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_strike_tip_impact.vpcf", PATTACH_ABSORIGIN, parent)
            ParticleManager:SetParticleControl(impact_index, 0, Vector(0, 0, 0))
            ParticleManager:SetParticleControl(impact_index, 1, parent:GetOrigin())
            ParticleManager:ReleaseParticleIndex(impact_index)
            EmitSoundOn("Hero_MonkeyKing.IronCudgel", parent)
            self:Destroy()
        end
    end
end