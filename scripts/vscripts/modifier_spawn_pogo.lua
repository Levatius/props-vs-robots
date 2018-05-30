modifier_spawn_pogo = class({})
LinkLuaModifier("modifier_pogo", LUA_MODIFIER_MOTION_NONE)


function modifier_spawn_pogo:IsHidden()
    return true
end

function modifier_spawn_pogo:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH
    }
end

function modifier_spawn_pogo:OnDeath(event)
    if IsServer() then
        local unit = event.unit
        if unit:IsRealHero() and unit == self:GetParent() then
            local pogo = CreateUnitByName("pogo", unit:GetOrigin(), true, unit, unit:GetOwner(), unit:GetTeamNumber())
            pogo:AddNewModifier(pogo, self, "modifier_pogo", nil)
            pogo:SetControllableByPlayer(unit:GetPlayerID(), true)
            pogo:SetOwner(unit)
            if FORCE_SELECT then
                PlayerResource:SetOverrideSelectionEntity(unit:GetPlayerID(), pogo)
            end
        end
    end
end
