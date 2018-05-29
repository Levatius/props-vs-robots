require("utils")
LinkLuaModifier("modifier_prop", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_haste", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spawn_sleep", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spawn_pogo", LUA_MODIFIER_MOTION_NONE)


if IsInToolsMode() then
    _G.FORCE_SELECT = false
    _G.COUNTDOWN_PREGAME = 5
else
    _G.FORCE_SELECT = true
    _G.COUNTDOWN_PREGAME = 30
end
_G.COUNTDOWN_MAIN = 60 * 4.0
_G.PROP_PCT_TO_REMOVE = 0.2

if GM == nil then
    _G.GM = class({})
end

function Precache(ctx)
    PrecacheUnitByNameSync("npc_dota_hero_monkey_king", ctx)
    PrecacheUnitByNameSync("npc_dota_hero_rattletrap", ctx)
    PrecacheResource("model", "models/development/invisiblebox.vmdl", ctx)
    PrecacheResource("model", "models/items/wards/the_monkey_sentinel/the_monkey_sentinel.vmdl", ctx)
    PrecacheResource("particle", "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_1.vpcf", ctx)
    PrecacheResource("particle", "particles/econ/courier/courier_greevil_red/courier_greevil_red_ambient_1.vpcf", ctx)
    PrecacheResource("particle", "particles/econ/events/fall_major_2016/force_staff_fm06.vpcf", ctx)
    PrecacheResource("particle", "particles/items3_fx/octarine_core_lifesteal.vpcf", ctx)
    PrecacheResource("particle", "particles/status_fx/status_effect_overpower.vpcf", ctx)
    PrecacheResource("particle", "particles/status_fx/status_effect_sylph_wisp_fear.vpcf", ctx)
    PrecacheResource("particle", "particles/ui/ui_sweeping_ring.vpcf", ctx)
    PrecacheResource("particle", "particles/econ/items/monkey_king/arcana/monkey_arcana_cloud_rays.vpcf", ctx)
    PrecacheResource("particle", "particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7_ring_wave.vpcf", ctx)
    PrecacheResource("particle", "particles/econ/events/ti5/blink_dagger_start_ti5.vpcf", ctx)
    PrecacheResource("particle", "particles/econ/events/ti5/blink_dagger_end_ti5.vpcf", ctx)
    PrecacheResource("particle", "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_debuff.vpcf", ctx)
    PrecacheResource("particle", "particles/econ/items/disruptor/disruptor_resistive_pinfold/disruptor_kf_wall_repel_smoke.vpcf", ctx)
    PrecacheResource("particle", "particles/econ/items/disruptor/disruptor_resistive_pinfold/disruptor_kf_wall_floorground.vpcf", ctx)
    PrecacheResource("particle", "particles/units/heroes/hero_disruptor/disruptor_kf_bindingtop.vpcf", ctx)
    PrecacheResource("particle", "particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start_c.vpcf", ctx)
    PrecacheResource("particle", "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", ctx)
    PrecacheResource("particle", "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf", ctx)
    PrecacheResource("particle", "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", ctx)
    PrecacheResource("particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_aoe.vpcf", ctx)
    PrecacheResource("particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_debuff.vpcf", ctx)
    PrecacheResource("particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_recall.vpcf", ctx)
    PrecacheResource("particle", "particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_blood04.vpcf", ctx)
    PrecacheResource("particle", "particles/units/heroes/hero_luna/luna_lucent_beam_impact_shared.vpcf", ctx)
    PrecacheResource("particle", "particles/econ/items/luna/luna_lucent_ti5/luna_lucent_beam_impact_shared_ti_5.vpcf", ctx)
    PrecacheResource("particle", "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_stack.vpcf", ctx)
    PrecacheResource("particle", "particles/units/heroes/hero_oracle/oracle_purifyingflames_dust_hit.vpcf", ctx)
    PrecacheResource("particle", "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", ctx)
    PrecacheResource("particle", "particles/units/heroes/hero_vengeful/vengeful_magic_missle.vpcf", ctx)
    PrecacheResource("particle", "particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_magic_missle.vpcf", ctx)
    PrecacheResource("particle", "particles/units/heroes/hero_wisp/wisp_overcharge.vpcf", ctx)
    PrecacheResource("soundfile", "soundevents/voscripts/game_sounds_vo_beastmaster.vsndevts", ctx)
    PrecacheResource("soundfile", "soundevents/voscripts/game_sounds_vo_monkey_king.vsndevts", ctx)
    PrecacheResource("soundfile", "soundevents/voscripts/game_sounds_vo_skywrath_mage.vsndevts", ctx)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_clinkz.vsndevts", ctx)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_dark_seer.vsndevts", ctx)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_invoker.vsndevts", ctx)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_keeper_of_the_light.vsndevts", ctx)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_skywrath_mage.vsndevts", ctx)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_spirit_breaker.vsndevts", ctx)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_tinker.vsndevts", ctx)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_luna.vsndevts", ctx)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_vengefulspirit.vsndevts", ctx)
    PrecacheResource("soundfile", "sounds/weapons/creep/neutral/troll_priest_heal.vsnd", ctx)
    PrecacheResource("soundfile", "sounds/weapons/hero/spirit_breaker/greater_bash.vsnd", ctx)
    PrecacheResource("soundfile", "sounds/items/force_staff.vsnd", ctx)
    PrecacheResource("soundfile", "sounds/ui/scan_enemy.vsnd", ctx)
    PrecacheUnitByNameSync("scanner", ctx)
end

function Activate()
    GM:InitGameMode()
end

function GM:InitGameMode()
    print("Prop Hunt initialising...")

    self.pregame = true

    self.team_colours = {}
    self.team_colours[DOTA_TEAM_GOODGUYS] = { 250, 175, 0 }
    self.team_colours[DOTA_TEAM_BADGUYS] = { 175, 0, 250 }

    for team = 0, (DOTA_TEAM_COUNT - 1) do
        local colour = self.team_colours[team]
        if colour then
            SetTeamCustomHealthbarColor(team, colour[1], colour[2], colour[3])
        end
    end

    GameRules:GetGameModeEntity().GM = self
    local GameMode = GameRules:GetGameModeEntity()

    GameMode:SetCustomGameForceHero("npc_dota_hero_monkey_king")
    GameMode:SetAnnouncerDisabled(true)
    GameMode:SetBuybackEnabled(false)

    -- Used for minimap build
    --self:RandomiseProps(1)

    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 5)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 3)

    GameRules:SetCustomGameEndDelay(0)
    GameRules:SetCustomVictoryMessageDuration(10)
    GameRules:SetPreGameTime(COUNTDOWN_PREGAME)
    GameRules:SetStrategyTime(0)
    GameRules:SetShowcaseTime(0)
    GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride(true)
    GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible(false)
    GameRules:SetHeroRespawnEnabled(false)
    GameRules:SetGoldPerTick(0)
    GameRules:SetGoldTickTime(0)
    GameRules:SetFirstBloodActive(false)
    GameRules:SetStartingGold(0)
    GameRules:SetUseBaseGoldBountyOnHeroes(true)
    GameRules:SetUseCustomHeroXPValues(true)
    GameRules:SetCustomGameSetupAutoLaunchDelay(10)

    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(GM, 'OnGameRulesStateChange'), self)
    ListenToGameEvent("npc_spawned", Dynamic_Wrap(GM, "OnNPCSpawned"), self)
    Convars:RegisterCommand("spawn_hider", Dynamic_Wrap(GM, "SpawnHider"), "Spawns a hider", FCVAR_CHEAT)
    Convars:RegisterCommand("spawn_seeker", Dynamic_Wrap(GM, "SpawnSeeker"), "Spawns a seeker", FCVAR_CHEAT)

    GameRules:GetGameModeEntity():SetThink("OnThink", self, 1)

    CustomGameEventManager:Send_ServerToAllClients("get_map_name", { map_name = GetMapName() })
end

function GM:OnThink()
    for player_id = 0, (DOTA_MAX_TEAM_PLAYERS - 1) do
        self:UpdatePlayerColor(player_id)
    end

    if GameRules:IsGamePaused() == true then
        return 1
    end

    if self.countdown_enabled == true then
        if COUNTDOWN_PREGAME <= 0 and self.pregame then
        end

        if COUNTDOWN_MAIN == 30 then
            CustomGameEventManager:Send_ServerToAllClients("timer_alert", {})
        elseif COUNTDOWN_MAIN <= 0 then
            GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
            self.countdown_enabled = false
        else
            GM:CheckAlive()
        end

        CountdownManager(self.pregame)
    end

    return 1
end

function GM:CheckAlive()
    local hiders = Entities:FindAllByClassname("npc_dota_hero_monkey_king")
    local seekers = Entities:FindAllByClassname("npc_dota_hero_rattletrap")
    local hiders_alive = 0
    local seekers_alive = 0
    for _, hero in pairs(hiders) do
        if hero:IsAlive() then
            hiders_alive = hiders_alive + 1
        end
    end
    for _, hero in pairs(seekers) do
        if hero:IsAlive() then
            seekers_alive = seekers_alive + 1
        end
    end
    if #hiders > 0 then
        if hiders_alive == 0 then
            GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
            self.countdown_enabled = false
        end
    end
    if #seekers > 0 then
        if seekers_alive == 0 then
            GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
            self.countdown_enabled = false
        end
    end
end

function GM:UpdatePlayerColor(player_id)
    if not PlayerResource:HasSelectedHero(player_id) then
        return
    end

    local hero = PlayerResource:GetSelectedHeroEntity(player_id)
    if hero == nil then
        return
    end

    local team_id = PlayerResource:GetTeam(player_id)
    local colour = self.team_colours[team_id]
    PlayerResource:SetCustomPlayerColor(player_id, colour[1], colour[2], colour[3])
end

function GM:RandomiseProps(pct_to_remove)
    local props = Entities:FindAllByClassname("npc_dota_building")
    local shuffled_props = ShuffledList(props, pct_to_remove)
    for _, prop in pairs(shuffled_props) do
        prop:RemoveSelf()
    end
end

function GM:HidePropsFromMinimap()
    local props = Entities:FindAllByClassname("npc_dota_building")
    for _, prop in pairs(props) do
        if not prop:HasModifier("modifier_prop") then
            prop:AddNewModifier(prop, nil, "modifier_prop", {})
        end
    end
end

function GM:OnNPCSpawned(keys)
    local npc = EntIndexToHScript(keys.entindex)
    if npc:IsRealHero() then
        if npc:GetPlayerOwner().first_spawned == nil then
            npc:GetPlayerOwner().first_spawned = true
            GM:OnHeroInGame(npc)
        end

        local innate_ability_names = { "transform", "light_shot", "heavy_strike", "surge", "scan" }
        for _, innate_ability_name in ipairs(innate_ability_names) do
            local innate_ability = npc:FindAbilityByName(innate_ability_name)
            if innate_ability then
                innate_ability:SetLevel(1)
            end
        end
    end
end

function GM:InitialModifiers(hero)
    local team = hero:GetTeam()
    if team == DOTA_TEAM_GOODGUYS then
        hero:AddNewModifier(hero, nil, "modifier_haste", { duration = COUNTDOWN_PREGAME })
        hero:AddNewModifier(hero, nil, "modifier_spawn_pogo", nil)
    elseif team == DOTA_TEAM_BADGUYS then
        hero:AddNewModifier(hero, nil, "modifier_spawn_sleep", { duration = COUNTDOWN_PREGAME })
        PlayerResource:SetCameraTarget(hero:GetPlayerID(), hero)
    end
end

function GM:SetupAwardMetrics(hero)
    local player = hero:GetPlayerOwner()

    player.award_metrics = {
        ['taunts_cast'] = 0,
        ['units_moved'] = 0,
        ['spells_hit']  = 0,
        ['spells_cast'] = 0,
        ['first_blood'] = 0,
        ['props_hit']   = 0
    }
end

function GM:OnHeroInGame(hero)
    local team = hero:GetTeam()
    local player_id = hero:GetPlayerOwnerID()
    local player = hero:GetPlayerOwner()
    local hero_name = hero:GetName()

    GM:InitialModifiers(hero)

    if team == DOTA_TEAM_BADGUYS then
        PrecacheUnitByNameAsync(hero_name, function()
            local new_hero = PlayerResource:ReplaceHeroWith(player_id, "npc_dota_hero_rattletrap", 0, 0)
            UTIL_Remove(hero)
            GM:InitialModifiers(new_hero)
        end, player_id)
    end
end

function GM:OnGameRulesStateChange()
    local new_state = GameRules:State_Get()

    if new_state == DOTA_GAMERULES_STATE_HERO_SELECTION then
        InitCountdown()
        self:RandomiseProps(PROP_PCT_TO_REMOVE)
        self:HidePropsFromMinimap()
    end

    if new_state == DOTA_GAMERULES_STATE_PRE_GAME then
        self.pregame = true
        self.countdown_enabled = true
    end

    if new_state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        self.pregame = false
        CustomGameEventManager:Send_ServerToAllClients("release_seekers", {})
        CustomGameEventManager:Send_ServerToAllClients("timer_main", {})
    end
end

function GM:SpawnHider()
    local cmd_player = Convars:GetCommandClient()
    if cmd_player then
        local hero = cmd_player:GetAssignedHero()
        local pos = hero:GetAbsOrigin()
        pos.z = 0
        local player_id = cmd_player:GetPlayerID()
        if player_id ~= nil and player_id ~= -1 then
            local unit = CreateUnitByName("npc_dota_hero_monkey_king", pos, true, hero, hero, DOTA_TEAM_GOODGUYS)
            unit:SetControllableByPlayer(player_id, false)
        end
    end
end

function GM:SpawnSeeker()
    local cmd_player = Convars:GetCommandClient()
    if cmd_player then
        local hero = cmd_player:GetAssignedHero()
        local pos = hero:GetAbsOrigin()
        pos.z = 0
        local player_id = cmd_player:GetPlayerID()
        if player_id ~= nil and player_id ~= -1 then
            local unit = CreateUnitByName("npc_dota_hero_rattletrap", pos, true, hero, hero, DOTA_TEAM_BADGUYS)
            unit:SetControllableByPlayer(player_id, false)
        end
    end
end