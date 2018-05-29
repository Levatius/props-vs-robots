transform = class({})
LinkLuaModifier("modifier_transform", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("aura_show_props", LUA_MODIFIER_MOTION_NONE)


function transform:GetIntrinsicModifierName()
    return "aura_show_props"
end

function transform:OnSpellStart()
    if IsServer() then
        local caster = self:GetCaster()
        caster:RemoveGesture(ACT_DOTA_TAUNT)
        ParticleManager:DestroyParticle(caster.transform_particles, false)
        StopSoundOn("Hero_KeeperOfTheLight.Recall.Target", caster)

        local search_radius = self:GetSpecialValueFor("search_radius")
        local nearest_prop = Entities:FindByClassnameNearest("npc_dota_building", self:GetCursorPosition(), search_radius)

        if nearest_prop ~= nil then
            local index = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_aoe.vpcf", PATTACH_WORLDORIGIN, caster)
            ParticleManager:SetParticleControl(index, 0, caster:GetOrigin())
            ParticleManager:SetParticleControl(index, 1, caster:GetOrigin())
            ParticleManager:SetParticleControl(index, 2, Vector(100, 0, 0))
            ParticleManager:ReleaseParticleIndex(index)
            EmitSoundOn("Hero_KeeperOfTheLight.Recall.End", caster)

            caster:AddNewModifier(caster, self, "modifier_transform", nil)
            local prop_form = CreateUnitByName("prop_form", caster:GetAbsOrigin(), true, caster, caster:GetOwner(), caster:GetTeamNumber())
            prop_form:SetControllableByPlayer(caster:GetPlayerID(), true)
            prop_form:SetOwner(caster)
            caster:AddNoDraw()
            caster:RemoveModifierByName("aura_show_props")
            caster:SetOrigin(Vector(0, 0, caster:GetOrigin().z))
            local prop_model = nearest_prop:GetModelName()
            prop_form:SetModel(prop_model)
            prop_form:SetOriginalModel(prop_model)
            local prop_scale = nearest_prop:GetModelScale()
            prop_form:SetModelScale(prop_scale)
            if FORCE_SELECT then
                PlayerResource:SetOverrideSelectionEntity(caster:GetPlayerID(), prop_form)
            end
            local prop_size = nearest_prop:GetModelRadius() * prop_scale
            if prop_size < 50 then
                local index = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/monkey_arcana_cloud_rays.vpcf", PATTACH_ABSORIGIN_FOLLOW, prop_form)
                ParticleManager:SetParticleControl(index, 0, prop_form:GetOrigin())
            end
            local max_health, move_speed = GetStats(prop_size)
            prop_form:SetBaseMaxHealth(max_health)
            prop_form:SetMaxHealth(max_health)
            local new_health = math.ceil(max_health * caster:GetHealthPercent() / 100)
            prop_form:ModifyHealth(new_health, nil, false, 0)
            prop_form:SetBaseMoveSpeed(move_speed)
            local revert_ability = prop_form:FindAbilityByName("revert")
            local cooldown = revert_ability:GetSpecialValueFor("cooldown")
            revert_ability:StartCooldown(cooldown)
            prop_form.hero = caster
        end
    end
end

function transform:GetCastRange()
    return self:GetSpecialValueFor("cast_range")
end

function transform:CastFilterResultLocation(target)
    return self:CastResolveLocation(target, false)
end

function transform:GetCustomCastErrorLocation(target)
    return self:CastResolveLocation(target, true)
end

function transform:CastResolveLocation(target, error)
    if IsServer() then
        local search_radius = self:GetSpecialValueFor("search_radius")
        local nearest_prop = Entities:FindByClassnameNearest("npc_dota_building", target, search_radius)
        if nearest_prop == nil then
            if error then
                return "No prop targeted"
            else
                return UF_FAIL_CUSTOM
            end
        end
        if not error then
            return UF_SUCCESS
        end
    end
end

function transform:OnAbilityPhaseStart()
    if IsServer() then
        local caster = self:GetCaster()
        caster:StartGesture(ACT_DOTA_TAUNT)
        caster.transform_particles = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_recall.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
        ParticleManager:SetParticleControl(caster.transform_particles, 0, caster:GetOrigin())
        EmitSoundOn("Hero_KeeperOfTheLight.Recall.Target", caster)
        return true
    end
end

function transform:OnAbilityPhaseInterrupted()
    if IsServer() then
        local caster = self:GetCaster()
        caster:RemoveGesture(ACT_DOTA_TAUNT)
        ParticleManager:DestroyParticle(caster.transform_particles, false)
        StopSoundOn("Hero_KeeperOfTheLight.Recall.Target", caster)
        EmitSoundOn("Hero_KeeperOfTheLight.Recall.Fail", caster)
    end
end

function GetStats(prop_size)
    local exponent = math.min(math.floor(prop_size / 50), 4)
    local max_health = math.pow(2, exponent)
    local move_speed = 200 + 75 * (4 - exponent)
    return max_health, move_speed
end