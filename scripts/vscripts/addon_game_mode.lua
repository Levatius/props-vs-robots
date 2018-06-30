require("config")
require("round")
require("utils")
LinkLuaModifier("modifier_prop", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_haste", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spawn_sleep", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spawn_pogo", LUA_MODIFIER_MOTION_NONE)


if IsInToolsMode() then
    _G.FORCE_SELECT = false
else
    _G.FORCE_SELECT = true
end
_G.PROP_PCT_TO_REMOVE = 0.2

if GM == nil then
    _G.GM = class({})
end

function Precache(ctx)
    PrecacheUnitByNameSync("npc_dota_hero_wisp", ctx)
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

    self.team_colours = {}
    self.team_colours[DOTA_TEAM_GOODGUYS] = { 250, 175, 0 }
    self.team_colours[DOTA_TEAM_BADGUYS] = { 175, 0, 250 }

    for team = 0, DOTA_TEAM_COUNT - 1 do
        local colour = self.team_colours[team]
        if colour then
            SetTeamCustomHealthbarColor(team, colour[1], colour[2], colour[3])
        end
    end

    GameRules:GetGameModeEntity().GM = self
    local GameMode = GameRules:GetGameModeEntity()

    GameMode:SetCustomGameForceHero("npc_dota_hero_wisp")
    GameMode:SetAnnouncerDisabled(true)
    GameMode:SetBuybackEnabled(false)

    -- Used for minimap build
    --self:RandomiseProps(1)

    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 5)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 3)

    GameRules:SetCustomGameEndDelay(0)
    GameRules:SetCustomVictoryMessageDuration(0)
    GameRules:SetPreGameTime(LOADING_TIME)
    GameRules:SetStrategyTime(0)
    GameRules:SetShowcaseTime(0)
    GameRules:SetPostGameTime(POST_ROUND_TIME)
    GameMode:SetTopBarTeamValuesOverride(true)
    GameMode:SetTopBarTeamValuesVisible(false)
    GameRules:SetHeroRespawnEnabled(false)
    GameRules:SetGoldPerTick(0)
    GameRules:SetGoldTickTime(0)
    GameRules:SetFirstBloodActive(false)
    GameRules:SetStartingGold(0)
    GameRules:SetUseBaseGoldBountyOnHeroes(true)
    GameRules:SetUseCustomHeroXPValues(true)
    GameRules:LockCustomGameSetupTeamAssignment(true)
    GameRules:EnableCustomGameSetupAutoLaunch(true)

    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(GM, 'OnGameRulesStateChange'), self)
    ListenToGameEvent("npc_spawned", Dynamic_Wrap(GM, 'OnNPCSpawned'), self)
    Convars:RegisterCommand("spawn_hider", Dynamic_Wrap(GM, "SpawnHider"), "Spawns a hider", FCVAR_CHEAT)
    Convars:RegisterCommand("spawn_seeker", Dynamic_Wrap(GM, "SpawnSeeker"), "Spawns a seeker", FCVAR_CHEAT)
    Convars:RegisterCommand("start_new_round", Dynamic_Wrap(GM, "StartNewRound"), "Force a new round to start", FCVAR_CHEAT)

    self:BuildingsToCreatures()
    GameMode:SetThink("OnThink", self, 1)

    CustomGameEventManager:RegisterListener("rounds_vote", Dynamic_Wrap(GM, "OnRoundsVote"))
    CustomGameEventManager:Send_ServerToAllClients("get_map_name", { map_name = GetMapName() })
end

function GM:OnThink()
    if GameRules:IsGamePaused() then
        return 1
    end

    if self.countdown_enabled then

        if self.current_round.in_pregame then
            if self.current_round.time_remaining <= 0 then
                print('Pre Over')
                self.current_round.time_remaining = ROUND_TIME
                self.current_round.in_pregame = false
                CustomGameEventManager:Send_ServerToAllClients("release_seekers", {})
                CustomGameEventManager:Send_ServerToAllClients("timer_main", {})
            end
        elseif not self.current_round.in_postgame then
            if self.current_round.time_remaining == 30 then
                CustomGameEventManager:Send_ServerToAllClients("timer_alert", nil)
            elseif self.current_round.time_remaining <= 0 then
                print('Round Over')
                CustomGameEventManager:Send_ServerToAllClients("victory", { winning_team = DOTA_TEAM_GOODGUYS })
                self.current_round:PostGame()
            else
                self.current_round:CheckEndClauses()
            end
        elseif self.current_round.in_postgame then
            if self.current_round.time_remaining <= 0 then
                self.round_id = self.round_id + 1
                if self.round_id > self.round_total then
                    self.countdown_enabled = false
                else
                    CustomGameEventManager:Send_ServerToAllClients("update_rounds", { round_id = self.round_id, round_total = self.round_total })

                    self.current_round:Start()
                end
            elseif self.current_round.time_remaining == LOADING_TIME and not self.game_over_flag then
                self.current_round:Load()
                self.current_round:Hero()
            else
                if self.round_id == self.round_total and not self.game_over_flag then
                    GameRules:SetGameWinner(0)
                    CustomGameEventManager:Send_ServerToAllClients("timer_end", {})
                    self.game_over_flag = true
                elseif not self.game_over_flag then
                    CustomGameEventManager:Send_ServerToAllClients("timer_post", {})
                end
            end
        end

        self.current_round:BroadcastTimer()
        self.current_round.time_remaining = self.current_round.time_remaining - 1
    end

    return 1
end

function GM:OnNPCSpawned(keys)
    local npc = EntIndexToHScript(keys.entindex)
    if npc:IsRealHero() then
        if not npc:GetPlayerOwner().first_spawned then
            npc:GetPlayerOwner().first_spawned = true
            GM:OnHeroInGame(npc)
        end
    end
end



function GM:OnHeroInGame(hero)
    print('on_hero_in_game')
    self.current_round:SetupRespawn(hero)
    self.current_round:SetupHero(hero)
end

function GM:BuildingsToCreatures()
    if IsServer() then
        local props = Entities:FindAllByClassname("npc_dota_building")
        for _, prop in pairs(props) do
            local new_prop = CreateUnitByName("prop", prop:GetOrigin(), true, nil, nil, 0)
            local prop_angles = prop:GetAnglesAsVector()
            new_prop:SetAngles(prop_angles.x, prop_angles.y, prop_angles.z)
            local prop_model = prop:GetModelName()
            new_prop:SetModel(prop_model)
            new_prop:SetOriginalModel(prop_model)
            local prop_scale = prop:GetModelScale()
            new_prop:SetModelScale(prop_scale)
            UTIL_Remove(prop)
        end
    end
end

function GM:OnGameRulesStateChange()
    local new_state = GameRules:State_Get()

    if new_state == DOTA_GAMERULES_STATE_HERO_SELECTION then
        print('hero_select')
        self.countdown_enabled = false
        self.current_round = Round:new()
        self.current_round:Load()
        self.round_total = self:ResolveNumberOfRounds()
        print("Rounds voted for:", self.round_total)
        self.round_id = 1
    end

    if new_state == DOTA_GAMERULES_STATE_PRE_GAME then
        print('pre_game')
    end

    if new_state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        print('in_progress')
        CustomGameEventManager:Send_ServerToAllClients("update_rounds", { round_id = self.round_id, round_total = self.round_total })
        self.countdown_enabled = true
        self.current_round:Start()
    end
end

function GM:OnRoundsVote(args)
    local player = PlayerResource:GetPlayer(args["player_id"])
    player.rounds_vote = args["rounds_vote"]
end

function GM:ResolveNumberOfRounds()
    local votes_table = { ["1"] = 0, ["2"] = 0, ["4"] = 0 }
    for pid = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
        local player = PlayerResource:GetPlayer(pid)
        if player then
            if player.rounds_vote then
                votes_table[player.rounds_vote] = votes_table[player.rounds_vote] + 1
            else
                votes_table["2"] = votes_table["2"] + 1
            end
        end
    end
    return tonumber(GetMaxKey(votes_table))
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

function GM:StartNewRound()
    GameRules:ResetToHeroSelection()
    --    for player, _ in pairs(self.current_round.players) do
    --        player.first_spawned = false
    --    end
end