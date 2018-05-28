modifier_snap = class({})
LinkLuaModifier("modifier_snap_linger", LUA_MODIFIER_MOTION_NONE)


function modifier_snap:IsHidden()
    return true
end

function modifier_snap:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.snap_delay = self.ability:GetSpecialValueFor("snap_delay")
    self.move_started = false
end

function modifier_snap:CheckState()
    if IsServer() then
        if not self.parent:IsNull() then
            if self.parent:IsIdle() and self.move_started then
                self.ability:StartCooldown(self.snap_delay)
                self.ability:SetActivated(true)
                self.move_started = false
            end

            if self.ability:IsCooldownReady() and not self.move_started then
                if not self.parent:HasModifier("modifier_snap_linger") then
                    self.parent:AddNewModifier(self.parent, self.ability, "modifier_snap_linger", {})
                end
            elseif self.parent:HasModifier("modifier_snap_linger") then
                self.parent:RemoveModifierByName("modifier_snap_linger")
            end
        end
    end
end

function modifier_snap:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_UNIT_MOVED
    }
    return funcs
end

function modifier_snap:OnUnitMoved()
    if IsServer() and not self.move_started then
        self.ability:EndCooldown()
        self.ability:SetActivated(false)
        self.move_started = true
    end
end