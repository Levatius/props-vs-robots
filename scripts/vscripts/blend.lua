blend = class({})
LinkLuaModifier("modifier_blend", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fow_visible", LUA_MODIFIER_MOTION_NONE)


function blend:OnToggle()
    if self:GetToggleState() then
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_blend", nil)
        self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_IDLE, 0)
    else
        if self:GetCaster():HasModifier("modifier_blend") then
            self:GetCaster():RemoveModifierByName("modifier_blend")
        end
        if self:GetCaster():HasModifier("modifier_fow_visible") then
            self:GetCaster():RemoveModifierByName("modifier_fow_visible")
        end
        self:GetCaster():RemoveGesture(ACT_DOTA_IDLE)
    end
end