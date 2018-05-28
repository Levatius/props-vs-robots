charge = class({})
LinkLuaModifier("modifier_charge", LUA_MODIFIER_MOTION_NONE)


function charge:OnSpellStart()
    if IsServer() then
        local caster = self:GetCaster()
        local target = self:GetCursorPosition()
        local speed = self:GetSpecialValueFor("speed")

        local vec_distance = target - caster:GetOrigin()
        local distance = vec_distance:Length2D()
        local direction = vec_distance:Normalized()

        self.distance = distance
        self.speed = speed / 30
        self.direction = direction
        self.traveled_distance = 0

        caster:AddNewModifier(caster, self, "modifier_charge", nil)
        EmitSoundOn("DOTA_Item.ForceStaff.Activate", caster)

        local blend_ability = caster:FindAbilityByName("blend")
        if blend_ability:GetToggleState() then
            blend_ability:ToggleAbility()
        end
    end
end

function charge:GetCastRange()
    return self:GetSpecialValueFor("cast_range")
end

function charge:CastFilterResultLocation(target)
    return self:CastResolveLocation(target, false)
end

function charge:GetCustomCastErrorLocation(target)
    return self:CastResolveLocation(target, true)
end

function charge:CastResolveLocation(target, error)
    if IsServer() then
        if not GridNav:IsTraversable(target) then
            if error then
                return "Targeted point not pathable"
            else
                return UF_FAIL_CUSTOM
            end
        end
        if not error then
            return UF_SUCCESS
        end
    end
end