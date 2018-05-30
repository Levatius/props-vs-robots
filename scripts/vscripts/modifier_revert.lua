modifier_revert = class({})
LinkLuaModifier("modifier_transform", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("aura_show_props", LUA_MODIFIER_MOTION_NONE)


function modifier_revert:IsHidden()
    return true
end

function modifier_revert:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH
    }
    return funcs
end

function modifier_revert:OnDeath(event)
    if IsServer() then
        local attacker = event.attacker
        local unit = event.unit
        if not unit:IsRealHero() then
            unit:AddNoDraw()
            unit.hero:RemoveModifierByName("modifier_transform")
            unit.hero:SetOrigin(unit:GetOrigin())
            unit.hero:RemoveNoDraw()
            unit.hero:AddNewModifier(unit.hero, unit.hero:FindAbilityByName("transform"), "aura_show_props", nil)

            if attacker ~= nil then
                unit.hero:Kill(nil, attacker)
            end

            if unit.hero:IsAlive() then
                if FORCE_SELECT then
                    PlayerResource:SetOverrideSelectionEntity(unit.hero:GetPlayerID(), unit.hero)
                end
                for i = 0, 3 do
                    unit.hero:GetAbilityByIndex(i):MarkAbilityButtonDirty()
                end
            end
        end
    end
end