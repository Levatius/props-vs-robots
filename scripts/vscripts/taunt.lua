taunt = class({})
LinkLuaModifier("modifier_taunt_", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blend", LUA_MODIFIER_MOTION_NONE)


function taunt:OnSpellStart()
    local caster = self:GetCaster()
    if not caster:HasModifier("modifier_blend") then
        local dodge_interval = self:GetSpecialValueFor("dodge_interval")
        caster:AddNewModifier(caster, self, "modifier_taunt_", { duration = dodge_interval })
    end

    local roll = RandomInt(1, 20)
    if roll <= 5 then -- 1,2,3,4,5 = 25%
        caster:EmitSound("Hero_SkywrathMage.ChickenTaunt")
    elseif roll <= 9 then -- 6,7,8,9 = 20%
        caster:EmitSound("beastmaster_beas_ability_animalsound_01")
    elseif roll <= 13 then -- 10,11,12,13 = 20%
        caster:EmitSound("beastmaster_beas_ability_animalsound_05")
    elseif roll <= 17 then -- 14,15,16,17 = 20%
        caster:EmitSound("Hero_Clinkz.Taunt")
    elseif roll <= 19 then -- 18,19 = 10%
        caster:EmitSound("monkey_king_monkey_spawn_13")
    elseif roll <= 20 then -- 20 = 5%
        caster:EmitSound("skywrath_mage_drag_inthebag_01")
    end

    -- Awards:
    --local player = caster:GetPlayerOwner()
    --player.award_metrics['taunt'] = player.award_metrics['taunt'] + 1
end