snap = class({})
LinkLuaModifier("modifier_snap", LUA_MODIFIER_MOTION_NONE)


function snap:GetIntrinsicModifierName()
    return "modifier_snap"
end