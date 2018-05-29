light_shot = class({})
LinkLuaModifier("modifier_light_shot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dummy", LUA_MODIFIER_MOTION_NONE)


function light_shot:GetCastRange()
    return self:GetSpecialValueFor("cast_range")
end

function light_shot:GetAOERadius()
    return self:GetSpecialValueFor("aoe")
end

function light_shot:OnAbilityPhaseStart()
    if IsServer() then
        local caster = self:GetCaster()
        caster:StartGestureWithPlaybackRate(ACT_DOTA_RATTLETRAP_HOOKSHOT_START, 2.0)
        return true
    end
end

function light_shot:OnAbilityPhaseInterrupted()
    if IsServer() then
        local caster = self:GetCaster()
        caster:RemoveGesture(ACT_DOTA_RATTLETRAP_HOOKSHOT_START)
    end
end

function light_shot:OnSpellStart()
    if IsServer() then
        local caster = self:GetCaster()
        self.aoe = self:GetSpecialValueFor("aoe")
        self.damage = self:GetSpecialValueFor("damage")
        self.vision_duration = self:GetSpecialValueFor("vision_duration")
        if caster:HasModifier("modifier_surge") then
            self.damage = self.damage * (caster:FindAbilityByName("surge"):GetSpecialValueFor("damage_amp") / 100)
            self.particle_name = "particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_magic_missle.vpcf"
        else
            self.particle_name = "particles/units/heroes/hero_vengeful/vengeful_magic_missle.vpcf"
        end
        self.spell_lifesteal = self:GetSpecialValueFor("spell_lifesteal") / 100
        self.projectile_speed = self:GetSpecialValueFor("projectile_speed")

        self.target = CreateUnitByName("dummy", self:GetCursorPosition(), false, caster, caster:GetOwner(), caster:GetTeamNumber())
        self.target:AddNewModifier(caster, self, "modifier_dummy", nil)

        local info = {
            EffectName = self.particle_name,
            Ability = self,
            iMoveSpeed = self.projectile_speed,
            Source = caster,
            Target = self.target,
            bDodgeable = true,
            bProvidesVision = true,
            iVisionTeamNumber = caster:GetTeamNumber(),
            iVisionRadius = self.aoe
        }
        ProjectileManager:CreateTrackingProjectile(info)
        EmitSoundOn("Hero_VengefulSpirit.MagicMissile", caster)
    end
end

function light_shot:OnProjectileHit()
    if IsServer() then
        local caster = self:GetCaster()

        self:CreateVisibilityNode(self.target:GetOrigin(), self.aoe, self.vision_duration)

        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), self.target:GetOrigin(), self.target, self.aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
        if #enemies > 0 then
            for _, enemy in pairs(enemies) do
                local damage = {
                    victim = enemy,
                    attacker = caster,
                    damage = self.damage,
                    damage_type = DAMAGE_TYPE_PURE,
                    ability = self
                }
                ApplyDamage(damage)
                enemy:AddNewModifier(caster, self, "modifier_light_shot", { duration = self:GetSpecialValueFor("slow_duration") })
                enemy:Interrupt()
                caster:Heal(self.spell_lifesteal * self.damage, self)
                local index = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_blood04.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
                ParticleManager:SetParticleControl(index, 0, enemy:GetOrigin())
                ParticleManager:ReleaseParticleIndex(index)
                EmitSoundOn("n_creep_ForestTrollHighPriest.Heal", caster)
            end
            local index = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
            ParticleManager:SetParticleControl(index, 0, caster:GetOrigin())
            ParticleManager:ReleaseParticleIndex(index)
        else
            local props = Entities:FindAllByClassnameWithin("npc_dota_building", self.target:GetOrigin(), self.aoe)
            if #props > 0 then
                local particle_flag = false
                for _, prop in pairs(props) do
                    if (self.target:GetOrigin() - prop:GetOrigin()):Length2D() < self.aoe then
                        local prop_size = prop:GetModelRadius() * prop:GetModelScale()
                        local prop_exponent = math.min(math.floor(prop_size / 50), 4)
                        local health_penalty = math.pow(2, prop_exponent)
                        local damage = {
                            victim = caster,
                            attacker = caster,
                            damage = self.damage * health_penalty,
                            damage_type = DAMAGE_TYPE_PURE,
                            ability = self
                        }
                        ApplyDamage(damage)
                        particle_flag = true
                    end
                end
                if particle_flag then
                    local index = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames_dust_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
                    ParticleManager:SetParticleControl(index, 0, caster:GetOrigin())
                    ParticleManager:ReleaseParticleIndex(index)
                end
            end
        end
        EmitSoundOn("Hero_VengefulSpirit.MagicMissileImpact", self.target)
        UTIL_Remove(self.target)
    end
end