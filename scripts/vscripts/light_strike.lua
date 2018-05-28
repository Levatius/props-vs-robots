light_strike = class({})
LinkLuaModifier("modifier_light_strike_thinker", LUA_MODIFIER_MOTION_NONE)

function light_strike:GetAOERadius()
    return self:GetSpecialValueFor("aoe")
end

function light_strike:OnSpellStart()
    self.aoe = self:GetSpecialValueFor("aoe")
    self.delay = self:GetSpecialValueFor("delay")
    self.vision_duration = self:GetSpecialValueFor("vision_duration")

    local duration = self.delay + self.vision_duration
    local target = self:GetCursorPosition()
    self:CreateVisibilityNode(target, self.aoe, duration)

    CreateModifierThinker(self:GetCaster(), self, "modifier_light_strike_thinker", {}, target, self:GetCaster():GetTeamNumber(), false)
end

function light_strike:GetCastRange()
    return self:GetSpecialValueFor("cast_range")
end