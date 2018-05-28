modifier_light_strike_thinker = class({})

function modifier_light_strike_thinker:IsHidden()
    return true
end

function modifier_light_strike_thinker:OnCreated()
    if IsServer() then
        self.aoe = self:GetAbility():GetSpecialValueFor("aoe")
        self.damage = self:GetAbility():GetSpecialValueFor("damage")
        if self:GetCaster():HasModifier("modifier_surge") then
            self.damage = self.damage * (self:GetCaster():FindAbilityByName("surge"):GetSpecialValueFor("damage_amp") / 100)
            self.particle_name = "particles/econ/items/luna/luna_lucent_ti5/luna_lucent_beam_impact_shared_ti_5.vpcf"
        else
            self.particle_name = "particles/units/heroes/hero_luna/luna_lucent_beam_impact_shared.vpcf"
        end
        self.delay = self:GetAbility():GetSpecialValueFor("delay")
        self.spell_lifesteal = self:GetAbility():GetSpecialValueFor("spell_lifesteal") / 100
        self:StartIntervalThink(self.delay)
    end
end

function modifier_light_strike_thinker:OnIntervalThink()
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
                self:GetCaster():Heal(self.spell_lifesteal * self.damage, self:GetAbility())
                local index = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_blood04.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
                ParticleManager:SetParticleControl(index, 0, enemy:GetOrigin())
                ParticleManager:ReleaseParticleIndex(index)
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

        local index = ParticleManager:CreateParticle(self.particle_name, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
        ParticleManager:SetParticleControlEnt(index, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "follow_origin", self:GetCaster():GetOrigin(), true)
        ParticleManager:SetParticleControlEnt(index, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "follow_origin", self:GetParent():GetOrigin(), true)
        ParticleManager:SetParticleControlEnt(index, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "follow_origin", self:GetParent():GetOrigin(), true)
        ParticleManager:SetParticleControlEnt(index, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "follow_origin", self:GetParent():GetOrigin(), true)
        ParticleManager:ReleaseParticleIndex(index)
        EmitSoundOnLocationWithCaster(self:GetParent():GetOrigin(), "Hero_Luna.LucentBeam.Target", self:GetCaster())
        UTIL_Remove(self:GetParent())
    end
end