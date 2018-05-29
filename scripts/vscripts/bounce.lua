bounce = class({})
LinkLuaModifier("modifier_bounce", LUA_MODIFIER_MOTION_NONE)


function bounce:OnSpellStart()
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
        self.z = 0

        caster:AddNewModifier(caster, self, "modifier_bounce", nil)
        EmitSoundOn("Hero_MonkeyKing.Taunt.Pogo", caster)
    end
end

function bounce:GetCastRange()
    return self:GetSpecialValueFor("cast_range")
end

function bounce:GetAOERadius()
    return self:GetSpecialValueFor("impact_radius")
end

function bounce:CastFilterResultLocation(target)
    return self:CastResolveLocation(target, false)
end

function bounce:GetCustomCastErrorLocation(target)
    return self:CastResolveLocation(target, true)
end

function bounce:CastResolveLocation(target, error)
    if IsServer() then
        if not GridNav:IsTraversable(target) then
            if error then
                return "Targeted point not pathable"
            else
                return UF_FAIL_CUSTOM
            end
        elseif (target - self:GetCaster():GetOrigin()):Length2D() < self:GetSpecialValueFor("min_cast_range") then
            if error then
                return "Targeted point too close"
            else
                return UF_FAIL_CUSTOM
            end
        elseif (target - self:GetCaster():GetOrigin()):Length2D() > self:GetSpecialValueFor("cast_range") then
            if error then
                return "Targeted point too far away"
            else
                return UF_FAIL_CUSTOM
            end
        end
        if not error then
            return UF_SUCCESS
        end
    end
end