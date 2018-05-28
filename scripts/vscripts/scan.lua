scan = class({})
LinkLuaModifier("modifier_scan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_startle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fow_visible", LUA_MODIFIER_MOTION_NONE)


function scan:OnSpellStart()
    if IsServer() then
        local caster = self:GetCaster()
        ParticleManager:DestroyParticle(caster.scan_phase, false)

        local index = ParticleManager:CreateParticle("particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7_ring_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
        ParticleManager:SetParticleControl(index, 0, caster:GetOrigin())
        ParticleManager:SetParticleControl(index, 3, caster:GetOrigin())
        ParticleManager:ReleaseParticleIndex(index)

        local index = ParticleManager:CreateParticle("particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start_c.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
        ParticleManager:SetParticleControl(index, 0, caster:GetOrigin())
        ParticleManager:SetParticleControl(index, 1, Vector(1, 0, 0))
        ParticleManager:ReleaseParticleIndex(index)

        StopSoundOn("Hero_Tinker.Rearm", caster)
        EmitSoundOn("minimap_radar.target", caster)

        local count_duration = self:GetSpecialValueFor("count_duration")
        local scanner = CreateUnitByName("scanner", caster:GetOrigin(), false, caster, caster:GetOwner(), caster:GetTeamNumber())
        scanner:SetControllableByPlayer(caster:GetPlayerID(), true)
        scanner:SetOwner(caster)
        scanner:AddNewModifier(caster, self, "modifier_scan", { duration = count_duration })

        local startle_radius = self:GetSpecialValueFor("startle_radius")
        local startle_duration = self:GetSpecialValueFor("startle_duration")
        local detection_radius = self:GetSpecialValueFor("detection_radius")
        AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetOrigin(), detection_radius, count_duration, false)
        AddFOWViewer(DOTA_TEAM_BADGUYS, caster:GetOrigin(), detection_radius, count_duration, false)
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), caster, startle_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
        for _, enemy in pairs(enemies) do
            if not enemy:HasModifier("modifier_fow_visible") then
                enemy:AddNewModifier(caster, self, "modifier_startle", { duration = startle_duration })
            end
        end
    end
end

function scan:GetCastRange()
    return self:GetSpecialValueFor("startle_radius")
end

function scan:OnAbilityPhaseStart()
    if IsServer() then
        local caster = self:GetCaster()
        caster.scan_phase = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_overcharge.vpcf", PATTACH_POINT_FOLLOW, caster)
        ParticleManager:SetParticleControl(caster.scan_phase, 0, caster:GetOrigin())
        EmitSoundOn("Hero_Tinker.Rearm", caster)
        return true
    end
end

function scan:OnAbilityPhaseInterrupted()
    if IsServer() then
        local caster = self:GetCaster()
        ParticleManager:DestroyParticle(caster.scan_phase, false)
        StopSoundOn("Hero_Tinker.Rearm", caster)
    end
end