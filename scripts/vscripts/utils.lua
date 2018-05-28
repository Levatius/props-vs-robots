function BroadcastMessage(msg, duration)
    local centre_msg = {
        message = msg,
        duration = duration
    }
    FireGameEvent("show_center_message", centre_msg)
end

function Shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else
        copy = orig
    end
    return copy
end

function ShuffledList(orig_list, pct_to_keep)
    local list = Shallowcopy(orig_list)
    local result = {}
    local count = math.floor(#list * pct_to_keep)
    for i = 1, count do
        local pick = RandomInt(1, #list)
        result[#result + 1] = list[pick]
        table.remove(list, pick)
    end
    return result
end

function CountdownManager(pregame)
    local t = 0
    if pregame then
        COUNTDOWN_PREGAME = COUNTDOWN_PREGAME - 1
        t = COUNTDOWN_PREGAME
    else
        COUNTDOWN_MAIN = COUNTDOWN_MAIN - 1
        t = COUNTDOWN_MAIN
    end
    local minutes = math.floor(t / 60)
    local seconds = t - (minutes * 60)
    local m10 = math.floor(minutes / 10)
    local m01 = minutes - (m10 * 10)
    local s10 = math.floor(seconds / 10)
    local s01 = seconds - (s10 * 10)
    local broadcast_gametimer =
    {
        timer_minute_10 = m10,
        timer_minute_01 = m01,
        timer_second_10 = s10,
        timer_second_01 = s01,
    }
    CustomGameEventManager:Send_ServerToAllClients("countdown", broadcast_gametimer)
    if t <= 120 and not pregame then
        CustomGameEventManager:Send_ServerToAllClients("time_remaining", broadcast_gametimer)
    end
end

function InitCountdown()
    local num_hiders = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
    local num_seekers = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
    local diff = num_hiders - num_seekers

    --2 in favour of seekers    = 3.0 mins --- 3 against 1
    --1 in favour of seekers    = 3.5 mins --- 3 against 2, 2 against 1
    --balanced                  = 4.0 mins --- 3 against 3, 2 against 2, 1 against 1
    --1 in favour of props      = 4.5 mins --- 3 against 4, 2 against 3, 1 against 2
    --2 in favour of props      = 5.0 mins --- 3 against 5, 2 against 4, 1 against 3
    diff = math.max(math.min(diff, 2), -2)
    COUNTDOWN_MAIN = COUNTDOWN_MAIN + (30 * diff)
    if num_seekers > 0 then
        diff = (0.2 * (3 - num_seekers))
    else
        diff = -PROP_PCT_TO_REMOVE
    end
    PROP_PCT_TO_REMOVE = PROP_PCT_TO_REMOVE + diff
end

function GetMaxKey(t)
    local key = next(t)
    local max = t[key]
    for k, v in pairs(t) do
        if t[k] > max then
            key, max = k, v
        end
    end
    return key
end

function GetMinKey(t)
    local key = next(t)
    local min = t[key]
    for k, v in pairs(t) do
        if t[k] < min then
            key, min = k, v
        end
    end
    return key
end

function GetPlayerNameByTable(t, mode)
    if next(t) ~= nil then
        if mode == "max" then
            return PlayerResource:GetPlayerName(GetMaxKey(t))
        end
        return PlayerResource:GetPlayerName(GetMinKey(t))
    end
    return "N/A"
end