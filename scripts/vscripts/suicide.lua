suicide = class({})


function suicide:OnSpellStart()
    if IsServer() then
        local damage = {
            victim = self:GetCaster(),
            attacker = self:GetCaster(),
            damage = 32,
            damage_type = DAMAGE_TYPE_PURE,
            ability = self
        }
        ApplyDamage(damage)
    end
end
