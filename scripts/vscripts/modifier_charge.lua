modifier_charge = class({})


function modifier_charge:IsMotionController()
    return true
end

function modifier_charge:GetMotionControllerPriority()
    return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH
end

function modifier_charge:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_charge:OnCreated()
    if IsServer() then
        self.stunned_enemies = {}
        self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
        local prop_size = self:GetParent():GetModelRadius() * self:GetParent():GetModelScale()
        local prop_exponent = math.min(math.floor(prop_size / 50), 4)
        self.damage_amount = math.pow(2, prop_exponent)
        self:StartIntervalThink(FrameTime())
        self.index = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/force_staff_fm06.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(self.index, 0, self:GetParent():GetOrigin())
    end
end

function modifier_charge:OnDestroy()
    if IsServer() then
        ParticleManager:DestroyParticle(self.index, false)
    end
end

function modifier_charge:OnIntervalThink()
    if IsServer() then
        local ability = self:GetAbility()
        local caster = ability:GetCaster()
        local radius = ability:GetSpecialValueFor("radius")
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)

        for _, enemy in pairs(enemies) do
            if not self.stunned_enemies[enemy] then
                if self.stun_duration > 0 then
                    enemy:AddNewModifier(enemy, self, "modifier_stunned", { duration = self.stun_duration })
                end
                ApplyDamage({
                    victim = enemy,
                    attacker = self:GetParent(),
                    damage = self.damage_amount,
                    damage_type = DAMAGE_TYPE_PURE,
                    ability = self:GetAbility()
                })
                local index = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
                ParticleManager:SetParticleControl(index, 0, enemy:GetOrigin())
                ParticleManager:ReleaseParticleIndex(index)
                local index = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames_dust_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
                ParticleManager:SetParticleControl(index, 0, enemy:GetOrigin())
                ParticleManager:ReleaseParticleIndex(index)
                EmitSoundOn("Hero_Spirit_Breaker.GreaterBash", enemy)
                self.stunned_enemies[enemy] = true
            end
        end

        self:HorizontalMotion()
    end
end

function modifier_charge:HorizontalMotion()
    if IsServer() then
        local ability = self:GetAbility()
        local caster = ability:GetCaster()

        if ability.traveled_distance < ability.distance then
            caster:SetOrigin(caster:GetOrigin() + ability.direction * ability.speed)
            ability.traveled_distance = ability.traveled_distance + ability.speed
        else
            caster:InterruptMotionControllers(true)
            caster:RemoveModifierByName("modifier_charge")
            FindClearSpaceForUnit(caster, caster:GetOrigin(), true)
        end
    end
end

function modifier_charge:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = true
    }
end

