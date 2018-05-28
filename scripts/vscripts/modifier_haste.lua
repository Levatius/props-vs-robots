modifier_haste = class({})


function modifier_haste:GetTexture()
    return "haste"
end

function modifier_haste:GetStatusEffectName()
    return "particles/status_fx/status_effect_overpower.vpcf"
end

function modifier_haste:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE
    }
    return funcs
end

function modifier_haste:GetModifierMoveSpeedOverride()
    return 550
end
