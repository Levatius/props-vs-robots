modifier_scan = class({})


function modifier_scan:IsHidden()
    return true
end

function modifier_scan:OnCreated()
    if IsServer() then
        local parent = self:GetParent()
        local radius = self:GetAbility():GetSpecialValueFor("detection_radius")
        local duration = self:GetAbility():GetSpecialValueFor("count_duration")

        self.detected = nil
        self.buff_index = nil

        self.smoke_index = ParticleManager:CreateParticle("particles/econ/items/disruptor/disruptor_resistive_pinfold/disruptor_kf_wall_repel_smoke.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
        ParticleManager:SetParticleControl(self.smoke_index, 0, parent:GetOrigin() + Vector(0, 0, 300))
        ParticleManager:SetParticleControl(self.smoke_index, 1, Vector(radius, 1, 1))
        ParticleManager:SetParticleControl(self.smoke_index, 2, Vector(duration, 0, 0))

        self.ring_index = ParticleManager:CreateParticle("particles/econ/items/disruptor/disruptor_resistive_pinfold/disruptor_kf_wall_floorground.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
        ParticleManager:SetParticleControl(self.ring_index, 0, parent:GetOrigin() + Vector(0, 0, 300))
        ParticleManager:SetParticleControl(self.ring_index, 1, Vector(radius, 1, 1))
        ParticleManager:SetParticleControl(self.ring_index, 2, Vector(duration, 0, 0))

        self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("update_interval"))
    end
end

function modifier_scan:OnIntervalThink()
    if IsServer() then
        local parent = self:GetParent()
        local radius = self:GetAbility():GetSpecialValueFor("detection_radius")
        local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetOrigin(), parent, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
        local changed = (#enemies > 0) ~= self.detected
        self.detected = #enemies > 0

        if changed then
            if self.buff_index ~= nil then
                ParticleManager:DestroyParticle(self.buff_index, false)
            end
            if self.detected then
                self.buff_index = ParticleManager:CreateParticle("particles/econ/courier/courier_greevil_red/courier_greevil_red_ambient_1.vpcf", PATTACH_OVERHEAD_FOLLOW, parent)
            else
                self.buff_index = ParticleManager:CreateParticle("particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_1.vpcf", PATTACH_OVERHEAD_FOLLOW, parent)
            end
            ParticleManager:SetParticleControl(self.buff_index, 0, parent:GetOrigin() + Vector(0, 0, 300))
            ParticleManager:SetParticleControl(self.buff_index, 2, Vector(255, 255, 255))
        end
    end
end

function modifier_scan:OnDestroy()
    if IsServer() then
        ParticleManager:DestroyParticle(self.buff_index, false)
        ParticleManager:DestroyParticle(self.smoke_index, false)
        ParticleManager:DestroyParticle(self.ring_index, false)
        UTIL_Remove(self:GetParent())
    end
end

function modifier_scan:CheckState()
    return {
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true
    }
end