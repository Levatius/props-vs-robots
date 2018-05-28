heavy_strike = class({})
LinkLuaModifier("modifier_heavy_strike_thinker", LUA_MODIFIER_MOTION_NONE)

function heavy_strike:GetAOERadius()
    return self:GetSpecialValueFor("aoe")
end

function heavy_strike:OnSpellStart()
    self.aoe = self:GetSpecialValueFor("aoe")
    self.delay = self:GetSpecialValueFor("delay")
    self.vision_duration = self:GetSpecialValueFor("vision_duration")

    local duration = self.delay + self.vision_duration
    local target = self:GetCursorPosition()
    self:CreateVisibilityNode(target, self.aoe, duration)

    CreateModifierThinker(self:GetCaster(), self, "modifier_heavy_strike_thinker", {}, target, self:GetCaster():GetTeamNumber(), false)
end