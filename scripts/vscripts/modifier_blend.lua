modifier_blend = class({})
LinkLuaModifier("modifier_fow_visible", LUA_MODIFIER_MOTION_NONE)


function modifier_blend:IsHidden()
    return true
end

function modifier_blend:OnCreated()
    if IsServer() then
        local ability = self:GetAbility()
        local caster = ability:GetCaster()
        local pos = caster:GetOrigin()
        local angles = caster:GetAnglesAsVector()
        local grid_snap = 32.0
        local rotation_snap = 45.0
        local new_pos = Vector(math.floor(pos.x / grid_snap + 0.5) * grid_snap, math.floor(pos.y / grid_snap + 0.5) * grid_snap, pos.z)
        local new_angles = Vector(0, math.floor(angles.y / rotation_snap + 0.5) * rotation_snap, 0)
        local vec_angles = Vector(math.cos(math.pi * new_angles.y / 180), math.sin(math.pi * new_angles.y / 180), 0)
        local face_vec = new_pos + vec_angles
        if GridNav:IsTraversable(new_pos) then
            caster:SetOrigin(new_pos)
            caster:FaceTowards(face_vec)
        end
        local fow_visible_delay = ability:GetSpecialValueFor("fow_visible_delay")
        self:StartIntervalThink(fow_visible_delay)
    end
end

function modifier_blend:OnIntervalThink()
    if IsServer() then
        local ability = self:GetAbility()
        local caster = ability:GetCaster()
        caster:AddNewModifier(caster, ability, "modifier_fow_visible", nil)
        self:StartIntervalThink(-1)
    end
end

function modifier_blend:CheckState()
    return {
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_ROOTED] = true
    }
end

function modifier_blend:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_blend:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor("heal_rate")
end

function modifier_blend:OnTakeDamage(event)
    if IsServer() then
        if event.unit == self:GetParent() then
            if self:GetAbility():GetToggleState() then
                self:GetAbility():ToggleAbility()
            end
        end
    end
end
