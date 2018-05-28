modifier_heavy_strike_thinker = class({})

function modifier_heavy_strike_thinker:IsHidden()
    return true
end

function modifier_heavy_strike_thinker:OnCreated()
    if IsServer() then
        self.aoe = self:GetAbility():GetSpecialValueFor("aoe")
        self.damage = self:GetAbility():GetSpecialValueFor("damage")
        if self:GetCaster():HasModifier("modifier_surge") then
            self.damage = self.damage * (self:GetCaster():FindAbilityByName("surge"):GetSpecialValueFor("damage_amp") / 100)
            self.particle_name = "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf"
        else
            self.particle_name = "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf"
        end
        self.delay = self:GetAbility():GetSpecialValueFor("delay")
        self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
        self.spell_lifesteal = self:GetAbility():GetSpecialValueFor("spell_lifesteal") / 100

        self:StartIntervalThink(self.delay)

        EmitSoundOnLocationForAllies(self:GetParent():GetOrigin(), "Hero_Invoker.SunStrike.Charge", self:GetCaster())

        local index = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber())
        ParticleManager:SetParticleControl(index, 0, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl(index, 1, Vector(self.aoe, 1, 1))
        ParticleManager:ReleaseParticleIndex(index)
    end
end

function modifier_heavy_strike_thinker:OnIntervalThink()
    if IsServer() then
        local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
        if #enemies > 0 then
            for _, enemy in pairs(enemies) do
                local damage = {
                    victim = enemy,
                    attacker = self:GetCaster(),
                    damage = self.damage,
                    damage_type = DAMAGE_TYPE_PURE,
                    ability = self:GetAbility()
                }
                ApplyDamage(damage)
                enemy:AddNewModifier(enemy, self, "modifier_stunned", { duration = self.stun_duration })
                self:GetCaster():Heal(self.spell_lifesteal * self.damage, self:GetAbility())
                EmitSoundOn("n_creep_ForestTrollHighPriest.Heal", self:GetCaster())
            end
            local index = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
            ParticleManager:SetParticleControl(index, 0, self:GetCaster():GetOrigin())
            ParticleManager:ReleaseParticleIndex(index)
        else
            local props = Entities:FindAllByClassnameWithin("npc_dota_building", self:GetParent():GetOrigin(), self.aoe)
            if #props > 0 then
                local particle_flag = false
                for _, prop in pairs(props) do
                    if (self:GetParent():GetOrigin() - prop:GetOrigin()):Length2D() < self.aoe then
                        local prop_size = prop:GetModelRadius() * prop:GetModelScale()
                        local prop_exponent = math.min(math.floor(prop_size / 50), 4)
                        local health_penalty = math.pow(2, prop_exponent)
                        local damage = {
                            victim = self:GetCaster(),
                            attacker = self:GetCaster(),
                            damage = self.damage * health_penalty,
                            damage_type = DAMAGE_TYPE_PURE,
                            ability = self:GetAbility()
                        }
                        ApplyDamage(damage)
                        particle_flag = true
                    end
                end
                if particle_flag then
                    local index = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames_dust_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
                    ParticleManager:SetParticleControl(index, 0, self:GetCaster():GetOrigin())
                    ParticleManager:ReleaseParticleIndex(index)
                end
            end
        end

        local index = ParticleManager:CreateParticle(self.particle_name, PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(index, 0, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl(index, 1, Vector(self.heavy_strike_aoe, 1, 1))
        ParticleManager:ReleaseParticleIndex(index)
        EmitSoundOnLocationWithCaster(self:GetParent():GetOrigin(), "Hero_Invoker.SunStrike.Ignite", self:GetCaster())
        UTIL_Remove(self:GetParent())
    end
end