modifier_bounce = class({})
LinkLuaModifier("modifier_bounce_stack", LUA_MODIFIER_MOTION_NONE)


function modifier_bounce:IsHidden()
    return true
end

function modifier_bounce:IsMotionController()
    return true
end

function modifier_bounce:GetMotionControllerPriority()
    return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH
end

function modifier_bounce:OnCreated()
    self:StartIntervalThink(FrameTime())
end

function modifier_bounce:OnIntervalThink()
    if IsServer() then
        self:VerticalMotion()
        self:HorizontalMotion()
    end
end

function modifier_bounce:HorizontalMotion()
    if IsServer() then
        local ability = self:GetAbility()
        local caster = ability:GetCaster()

        if ability.traveled_distance < ability.distance then
            caster:SetOrigin(caster:GetOrigin() + ability.direction * ability.speed)
            ability.traveled_distance = ability.traveled_distance + ability.speed
        else
            caster:InterruptMotionControllers(true)
            caster:RemoveModifierByName("modifier_bounce")
            FindClearSpaceForUnit(caster, caster:GetOrigin(), true)

            local dust_index = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/taunt_dust_impact.vpcf", PATTACH_ABSORIGIN, caster)
            ParticleManager:SetParticleControl(dust_index, 0, caster:GetOrigin())
            ParticleManager:ReleaseParticleIndex(dust_index)

            local radius = ability:GetSpecialValueFor("impact_radius")
            local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)

            for _, enemy in pairs(enemies) do
                enemy:AddNewModifier(enemy, ability, "modifier_bounce_stack", { duration = ability:GetSpecialValueFor("stack_duration") })
                EmitSoundOn("Hero_MonkeyKing.Spring.Impact", enemy)
            end
        end
    end
end

function modifier_bounce:VerticalMotion()
    if IsServer() then
        local ability = self:GetAbility()
        local caster = ability:GetCaster()

        if ability.traveled_distance < ability.distance / 2 then
            ability.z = ability.z + ability.speed / 2
            caster:SetOrigin(GetGroundPosition(caster:GetOrigin(), caster) + Vector(0, 0, ability.z))
        else
            ability.z = ability.z - ability.speed / 2
            caster:SetOrigin(GetGroundPosition(caster:GetOrigin(), caster) + Vector(0, 0, ability.z))
        end
    end
end

function modifier_bounce:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = true
    }
end