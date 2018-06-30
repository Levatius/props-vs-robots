require("config")
require("_timers")
LinkLuaModifier("modifier_active_prop", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_inactive_prop", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_haste", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spawn_pogo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spawn_sleep", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_postgame_sleep", LUA_MODIFIER_MOTION_NONE)

Round = {}
Round.__index = Round

function Round:new()
    local round = {}
    setmetatable(round, Round)

    round.good_spawners = Entities:FindAllByClassname("info_player_start_goodguys")
    round.bad_spawners = Entities:FindAllByClassname("info_player_start_badguys")

    return round
end

function Round:Load()
    self.good_bucket = {}
    self.bad_bucket = {}
    self:SetupMap()
    self:SetupTeams()
end

function Round:Hero()
    for player, _ in pairs(self.players) do
        local hero = player:GetAssignedHero()
        self:SetupRespawn(hero)
        self:SetupHero(hero)
    end
end

function Round:Start()
    CustomGameEventManager:Send_ServerToAllClients("clear_victory", nil)
    CustomGameEventManager:Send_ServerToAllClients("timer_pre", {})
    self:InitStats()
    self:InitialModifiers()
    self.time_remaining = PRE_ROUND_TIME
    self.in_pregame = true
    self.in_postgame = false
end

function Round:PostGame()
    self:HandleAwards()
    self.time_remaining = POST_ROUND_TIME
    self.in_postgame = true
    self:CleanUp()
end

function ShallowCopy(obj)
    local obj_type = type(obj)
    local obj_copy = {}

    if obj_type == 'table' then
        obj_copy = {}
        for k, v in pairs(obj) do
            obj_copy[k] = v
        end
    else
        obj_copy = obj
    end

    return obj_copy
end

function ShuffledTableSplit(t, split_pct)
    local t_alpha = {}
    local t_beta = ShallowCopy(t)
    local count = math.floor(#t_beta * split_pct)
    for i = 1, count do
        local pick = RandomInt(1, #t_beta)
        t_alpha[#t_alpha + 1] = t_beta[pick]
        table.remove(t_beta, pick)
    end
    return t_alpha, t_beta
end

function Round:SetupMap()
    local props = Entities:FindAllByName("npc_dota_creature")
    for _, prop in pairs(props) do
        if prop:GetUnitName() ~= "prop" then
            table.remove(prop)
        end
    end
    for _, prop in pairs(props) do
        prop:RemoveModifierByName("modifier_active_prop")
        prop:RemoveModifierByName("modifier_inactive_prop")
    end

    local active_props, inactive_props = ShuffledTableSplit(props, 0.3)
    for _, prop in pairs(active_props) do
        prop:AddNewModifier(prop, nil, "modifier_active_prop", nil)
    end
    for _, prop in pairs(inactive_props) do
        prop:AddNewModifier(prop, nil, "modifier_inactive_prop", nil)
    end
end

function Round:UpdatePlayerColour(pid)
    local tid = PlayerResource:GetTeam(pid)
    local colour = GM.team_colours[tid]
    PlayerResource:SetCustomPlayerColor(pid, colour[1], colour[2], colour[3])
end

function TableCount(t)
    local n = 0
    for _ in pairs(t) do
        n = n + 1
    end
    return n
end

function Round:SetupTeams()
    self.players = {}
    for pid = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
        local player = PlayerResource:GetPlayer(pid)
        if player then
            if not player.robot_games then
                player.robot_games = 0
            end
            self.players[player] = player.robot_games
        end
    end
    table.sort(self.players)

    local robot_count = math.ceil(TableCount(self.players) * 1 / 3)

    local i = 0
    for player, _ in pairs(self.players) do
        if i < robot_count then
            PlayerResource:SetCustomTeamAssignment(player:GetPlayerID(), DOTA_TEAM_BADGUYS)
            player.robot_games = player.robot_games + 1
        else
            PlayerResource:SetCustomTeamAssignment(player:GetPlayerID(), DOTA_TEAM_GOODGUYS)
        end
        self:UpdatePlayerColour(player:GetPlayerID())
        i = i + 1
    end
end

--function Round:SetupTeams()
--    self.players = {}
--    for pid = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
--        local player = PlayerResource:GetPlayer(pid)
--        if player then
--            if not player.robot_games then
--                player.robot_games = 0
--            end
--            self.players[player] = player.robot_games
--        end
--    end
--    table.sort(self.players)
--
--    local robot_count = math.ceil(TableCount(self.players) * 1 / 3)
--
--    local i = 0
--    for player, _ in pairs(self.players) do
--        if player.robot_games % 2 == 0 then
--            PlayerResource:SetCustomTeamAssignment(player:GetPlayerID(), DOTA_TEAM_BADGUYS)
--
--        else
--            PlayerResource:SetCustomTeamAssignment(player:GetPlayerID(), DOTA_TEAM_GOODGUYS)
--        end
--        player.robot_games = player.robot_games + 1
--        self:UpdatePlayerColour(player:GetPlayerID())
--        i = i + 1
--    end
--end

function Round:BroadcastTimer()
    local minutes = math.floor(self.time_remaining / 60)
    local seconds = self.time_remaining - (minutes * 60)
    local m10 = math.floor(minutes / 10)
    local m01 = minutes - (m10 * 10)
    local s10 = math.floor(seconds / 10)
    local s01 = seconds - (s10 * 10)
    local data = {
        timer_minute_10 = m10,
        timer_minute_01 = m01,
        timer_second_10 = s10,
        timer_second_01 = s01
    }
    CustomGameEventManager:Send_ServerToAllClients("countdown", data)
    if self.time_remaining <= 120 and not self.in_pregame and not self.in_postgame then
        CustomGameEventManager:Send_ServerToAllClients("time_remaining", data)
    end
end

function PickRandomShuffle(reference_list, bucket)
    if TableCount(reference_list) == 0 then
        return nil
    end

    if #bucket == 0 then
        local i = 1
        for _, v in pairs(reference_list) do
            bucket[i] = v
            i = i + 1
        end
    end

    local pick = RandomInt(1, #bucket)
    local result = bucket[pick]
    table.remove(bucket, pick)
    return result
end

function Round:RemoveTPScroll(hero)
    for i = 0, 8 do
        local item = hero:GetItemInSlot(i)
        if item ~= nil and item:GetAbilityName() == "item_tpscroll" then
            item:RemoveSelf()
        end
    end
end

function Round:SetupRespawn(hero)
    local player = hero:GetPlayerOwner()
    local spawn_loc
    if player:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
        spawn_loc = PickRandomShuffle(self.good_spawners, self.good_bucket):GetOrigin()
    elseif player:GetTeamNumber() == DOTA_TEAM_BADGUYS then
        spawn_loc = PickRandomShuffle(self.bad_spawners, self.bad_bucket):GetOrigin()
    end
    hero:SetRespawnPosition(spawn_loc)
end

function Round:SetupHero(hero)
    local player = hero:GetPlayerOwner()
    local pid = hero:GetPlayerID()
    if player:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
        print('replacing with prop shifter')
        Timers:CreateTimer(0.5, function()
            PlayerResource:ReplaceHeroWith(pid, "npc_dota_hero_monkey_king", 0, 0)
        end)
    elseif player:GetTeamNumber() == DOTA_TEAM_BADGUYS then
        print('replacing with robot seeker')
        Timers:CreateTimer(0.5, function()
            PlayerResource:ReplaceHeroWith(pid, "npc_dota_hero_rattletrap", 0, 0)
        end)
    end
end



function Round:InitialModifiers()
    for player, _ in pairs(self.players) do
        local pid = player:GetPlayerID()
        print("applying_modifiers to", pid)
        local hero = player:GetAssignedHero()
        hero:RespawnHero(false, false)
        hero:RemoveModifierByName("modifier_postgame_sleep")
        if player:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
            hero:AddNewModifier(hero, nil, "modifier_haste", { duration = PRE_ROUND_TIME })
            hero:AddNewModifier(hero, nil, "modifier_spawn_pogo", nil)
        elseif player:GetTeamNumber() == DOTA_TEAM_BADGUYS then
            hero:AddNewModifier(hero, nil, "modifier_spawn_sleep", { duration = PRE_ROUND_TIME })
            PlayerResource:SetCameraTarget(pid, hero)
        end

        local innate_ability_names = { "transform", "light_shot", "heavy_strike", "surge", "scan" }
        for _, innate_ability_name in ipairs(innate_ability_names) do
            local innate_ability = hero:FindAbilityByName(innate_ability_name)
            if innate_ability then
                innate_ability:SetLevel(1)
            end
        end

        self:RemoveTPScroll(hero)
    end
end

function Round:CleanUp()
    for player, _ in pairs(self.players) do
        player:GetAssignedHero():AddNewModifier(nil, nil, "modifier_postgame_sleep", nil)
    end

    local creatures = Entities:FindAllByClassname("npc_dota_creature")

    for _, creature in pairs(creatures) do
        if creature:GetUnitName() ~= "prop" then
            UTIL_Remove(creature)
        end
    end
end

function Round:InitStats()
    for player, _ in pairs(self.players) do
        player.stats = {
            ["taunt"] = 0,
            ["still"] = 0,
            ["hits_right"] = 0,
            ["hits_wrong"] = 0,
            ["kills"] = PlayerResource:GetKills(player:GetPlayerID()),
            ["cast"] = 0
        }
    end
end

function Round:HandleAwards()
    local stat_taunt = {}
    local stat_still = {}
    local stat_accuracy = {}
    local stat_kills = {}
    local stat_props_hit = {}
    for player, _ in pairs(self.players) do
        local pid = player:GetPlayerID()
        if player:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
            stat_taunt[pid] = player.stats["taunt"]
            stat_still[pid] = player.stats["still"]
        elseif player:GetTeamNumber() == DOTA_TEAM_BADGUYS then
            stat_accuracy[pid] = player.stats["hits_right"] / player.stats["cast"]
            stat_kills[pid] = PlayerResource:GetKills(pid) - player.stats["kills"]
            stat_props_hit[pid] = player.stats["hits_wrong"]
        end
    end

    local taunt_winner
    if next(stat_taunt) ~= nil then
        taunt_winner = PlayerResource:GetSteamID(GetMaxKey(stat_taunt))
    end

    local still_winner
    local move_winner
    if next(stat_still) ~= nil then
        still_winner = PlayerResource:GetSteamID(GetMaxKey(stat_still))
        move_winner = PlayerResource:GetSteamID(GetMinKey(stat_still))
    end

    local accuracy_winner
    if next(stat_accuracy) ~= nil then
        accuracy_winner = PlayerResource:GetSteamID(GetMaxKey(stat_accuracy))
    end

    local kills_winner
    if next(stat_kills) ~= nil then
        kills_winner = PlayerResource:GetSteamID(GetMaxKey(stat_kills))
    end

    local props_hit_winner
    if next(stat_props_hit) ~= nil then
        props_hit_winner = PlayerResource:GetSteamID(GetMaxKey(stat_props_hit))
    end

    local data = {
        taunt = taunt_winner,
        still = still_winner,
        move = move_winner,
        accuracy = accuracy_winner,
        kills = kills_winner,
        props_hit = props_hit_winner
    }
    CustomGameEventManager:Send_ServerToAllClients("give_awards", data)
end

function Round:CheckEndClauses()
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
            CustomGameEventManager:Send_ServerToAllClients("victory", {winning_team=DOTA_TEAM_BADGUYS})
            self:PostGame()
        end
    end
    if #seekers > 0 then
        if seekers_alive == 0 then
            CustomGameEventManager:Send_ServerToAllClients("victory", {winning_team=DOTA_TEAM_GOODGUYS})
            self:PostGame()
        end
    end
end

