modifier_transform = class({})

function modifier_transform:OnCreated()
    self.ability = self:GetAbility()
    self.caster = self.ability:GetCaster()
    self.max_health = self.ability:GetSpecialValueFor("max_health")
    self.move_speed = self.ability:GetSpecialValueFor("move_speed")
    self.prop = self.ability.nearest_prop
end

function modifier_transform:CheckState()
    local state = {}
    if IsServer() then
        state[MODIFIER_STATE_NOT_ON_MINIMAP] = true
        state[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true
        state[MODIFIER_STATE_NO_HEALTH_BAR] = true
        state[MODIFIER_STATE_UNSELECTABLE] = true
    end
    return state
end

function modifier_transform:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_EVENT_ON_MODEL_CHANGED
    }
    return funcs
end

function modifier_transform:GetModifierHealthBonus()
    local base_max_health = self.caster:GetMaxHealth()
    return self.max_health - base_max_health
end

function modifier_transform:GetModifierMoveSpeedOverride()
    return self.move_speed
end

function modifier_transform:GetModifierModelChange()
    return self.prop:GetModelName()
end

function modifier_transform:GetModifierModelScale()
    return 23
end

function modifier_transform:OnModelChanged()
    local prop_size = self.caster:GetModelRadius()
    if prop_size <= 50 then
        self.max_health = 1
        self.move_speed = 500
    elseif prop_size <= 100 then
        self.max_health = 2
        self.move_speed = 400
    elseif prop_size <= 150 then
        self.max_health = 4
        self.move_speed = 300
    elseif prop_size <= 200 then
        self.max_health = 8
        self.move_speed = 200
    else
        self.max_health = 16
        self.move_speed = 100
    end
end