aura_show_props = class({})
LinkLuaModifier("modifier_show_props", LUA_MODIFIER_MOTION_NONE)


function aura_show_props:IsHidden()
    return true
end
--
--function aura_show_props:IsAura()
--    return true
--end
--
--function aura_show_props:GetModifierAura()
--    return "modifier_show_props"
--end
--
--function aura_show_props:GetAuraSearchFlags()
--    return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
--end
--
--function aura_show_props:GetAuraSearchTeam()
--    return DOTA_UNIT_TARGET_TEAM_BOTH
--end
--
--function aura_show_props:GetAuraSearchType()
--    return DOTA_UNIT_TARGET_ALL
--end
--
--function aura_show_props:GetAuraRadius()
--    return self.aura_radius
--end
--
--function aura_show_props:OnCreated()
--    if IsServer() then
--        self.aura_radius = self:GetAbility():GetCastRange(self:GetCaster():GetOrigin(), self:GetCaster())
--    end
--end

function aura_show_props:OnCreated()
    if IsServer() then
        self:StartIntervalThink(0.1)
    end
end

function aura_show_props:OnIntervalThink()
    if IsServer() then
        local props = Entities:FindAllByNameWithin("npc_dota_creature", self:GetParent():GetOrigin(), self:GetAbility():GetCastRange(self:GetCaster():GetOrigin(), self:GetCaster()))
        for _, prop in pairs(props) do
            if prop:HasModifier("modifier_active_prop") then
                prop:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_show_props", { duration = 0.2 })
            end
        end
    end
end
