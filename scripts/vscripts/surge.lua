surge = class({})
LinkLuaModifier("modifier_surge", LUA_MODIFIER_MOTION_NONE)


function surge:OnSpellStart()
    local duration = self:GetSpecialValueFor("duration")
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_surge", { duration = duration })
    EmitSoundOn("Hero_Dark_Seer.Surge", self:GetCaster())
end