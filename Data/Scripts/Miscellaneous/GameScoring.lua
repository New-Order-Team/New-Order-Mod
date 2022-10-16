require("pgcommands")

-- Don't pool...
ScriptPoolCount = 0

--
-- Base_Definitions -- sets up the base variable for this script.
--
-- @since 3/15/2005 3:55:03 PM -- BMH
-- 
function Base_Definitions()
    DebugMessage("%s -- In Base_Definitions", tostring(Script))

    Common_Base_Definitions()

    ServiceRate = 10

    frag_index = 1
    death_index = 2
    GameStartTime = 0

    CampaignGame = false

    Reset_Stats()

    if Definitions then
        Definitions()
    end

    Define_Title_Faction_Table()
end

--
-- The player list has been reset underneath us, reset the stats.
--
-- @since 5/5/2005 7:43:17 PM -- BMH
-- 
function Player_List_Reset()
    GameScoringMessage("GameScoring -- PlayerList Reset.")
    Reset_Stats()
end

--
-- main script function.  Does event pumps and servicing.
--
-- @since 3/15/2005 3:55:03 PM -- BMH
-- 
function main()

    DebugMessage("GameScoring -- In main.")

    if GameService then
        while true do
            GameService()
            PumpEvents()
        end
    end

    ScriptExit()
end


--
-- Reset the Tactical mode game stats.
--
-- @since 3/15/2005 3:56:43 PM -- BMH
-- 
function Reset_Tactical_Stats()
    GameScoringMessage("GameScoring -- Resetting tactical stats.")
    collectgarbage()
    -- [frag|death][playerid][object_type][build_count, credits_spent, combat_power]
    TacticalKillStatsTable = {[frag_index] = {}, [death_index] = {}}
    TacticalTeamKillStatsTable = {[frag_index] = {}, [death_index] = {}}

    -- [playerid][planetname][object_type][build_count, credits_spent, combat_power]
    TacticalBuildStatsTable = {}

    -- a dirty hack to reset tactical script registry values
    ResetTacticalRegistry()
end


function GameScoringMessage(...)
    _ScriptMessage(string.format(unpack(arg)))
    _OuputDebug(string.format(unpack(arg)) .. "\n")
end


--
-- Reset all the stats and player lists.
--
-- @since 3/15/2005 3:56:43 PM -- BMH
-- 
function Reset_Stats()
    GameScoringMessage("GameScoring -- Resetting stats.")
    --GalacticKillStatsTable = {[frag_index] = {}, [death_index] = {}}

    Reset_Tactical_Stats()
    GalacticNeutralizedTable = {}

    PlayerTable = {}
    PlayerQuitTable = {}
end


function ResetTacticalRegistry()
    DebugMessage("Resetting Allow_AI_Controlled_Fog_Reveal to 1 (allowed)")
    GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)
end


--
-- Update our GameStats table with build stats
--
-- @param stat_table    stat table to update
-- @param planet        planet where the object was produced
-- @param object_type   the object type that was just produced
-- @since 3/18/2005 3:48:32 PM -- BMH
-- 
function Update_Build_Stats_Table(stat_table, planet, object_type, owner)

end


--
-- Print out the current build statistics for all the players.
--
-- @param stat_table    stats table to display.
-- @since 3/21/2005 10:34:07 AM -- BMH
-- 
function Print_Build_Stats_Table(stat_table)

end


--
-- Print out the current statistics for all the players.
--
-- @param stat_table    stats table to display.
-- @since 3/15/2005 5:55:55 PM -- BMH
-- 
function Print_Stat_Table(stat_table)

end


--
-- Script service function.  Just prints out the current stats.
--
-- @since 3/15/2005 3:56:43 PM -- BMH
-- 
function GameService()
    GameScoringMessage("%s -- Garbage collection result %s", tostring(Script), tostring(gcinfo()))
    collectgarbage()
end

--
-- Updates the table of players for the current game.
--
-- @param player    player object to add to our table of players
-- @since 3/15/2005 3:56:43 PM -- BMH
-- 
function Update_Player_Table(player)

    if player == nil then return end

    ent = PlayerTable[player.Get_ID()]
    if ent == nil then
        PlayerTable[player.Get_ID()] = player
    end
    ent = nil
end


--
-- Update our GameStats table with victim, killer info.
--
-- @param stat_table    stat table to update
-- @param object        the object that was destroyed
-- @param killer        the player that killed this object
-- @since 3/15/2005 4:10:19 PM -- BMH
-- 
function Update_Kill_Stats_Table(stat_table, object, killer)

    if TestValid(object) == false or TestValid(killer) == false then
        return
    end

    Update_Player_Table(killer)
    Update_Player_Table(object.Get_Owner())

    object_type = object.Get_Game_Scoring_Type()
    score_value = object.Get_Game_Scoring_Type().Get_Score_Cost_Credits()
    killer_id = killer.Get_ID()
    owner_id = object.Get_Owner().Get_ID()

    GameScoringMessage("GameScoring -- Object: %s, was killed by %s.", object_type.Get_Name(), killer.Get_Name())

    -- Update frags
    frag_entry = stat_table[frag_index]
    if frag_entry == nil then frag_entry = {} end

    entry = frag_entry[killer_id]
    if entry == nil then entry = {} end

    pe = entry[object_type]
    if pe == nil then
        pe = {kills = 1, score_value = score_value}
    else
        pe.kills = pe.kills + 1
        pe.score_value = pe.score_value + score_value
    end

    entry[object_type] = pe
    frag_entry[killer_id] = entry
    stat_table[frag_index] = frag_entry

    -- Update deaths
    death_entry = stat_table[death_index]
    if death_entry == nil then death_entry = {} end

    entry = death_entry[owner_id]
    if entry == nil then entry = {} end

    pe = entry[object_type]
    if pe == nil then
        pe = {kills = 1, score_value = score_value}
    else
        pe.kills = pe.kills + 1
        pe.score_value = pe.score_value + score_value
    end

    entry[object_type] = pe
    death_entry[owner_id] = entry
    stat_table[death_index] = death_entry

end


----------------------------------------
--
--      E V E N T   H A N D L E R S
--
----------------------------------------


--
-- This event is triggered on a game mode start.
--
-- @param mode_name    name of the new mode (ie: Galactic, Land, Space)
-- @since 3/15/2005 3:58:59 PM -- BMH
-- 
function Game_Mode_Starting_Event(mode_name, map_name)
    GameScoringMessage("GameScoring -- Mode %s (%s) now starting.", mode_name, map_name)
    LastModeName = mode_name
    LastMapName = map_name

    if StringCompare(mode_name, "Galactic") then
        -- Galactic Campaign
        CampaignGame = true
        Reset_Stats()
        GameStartTime = GetCurrentTime.Frame()
    elseif CampaignGame == false then
        -- Skirmish tactical
        Reset_Stats()
        GameStartTime = GetCurrentTime.Frame()
    elseif CampaignGame == true then
        -- Galactic transition to Tactical.
        -- cleaning out full galactic tables for performance reasons
        Reset_Stats()
    end
    LastWasCampaignGame = CampaignGame
end


--
-- This event is triggered on a game mode end.
--
-- @param mode_name    name of the old mode (ie: Galactic, Land, Space)
-- @since 3/15/2005 3:58:59 PM -- BMH
-- 
function Game_Mode_Ending_Event(mode_name)
    GameScoringMessage("GameScoring -- Mode %s now ending.", mode_name)

    LastWasCampaignGame = CampaignGame
    if StringCompare(mode_name, "Galactic") then
        CampaignGame = false
    end
end


--
-- This event is triggered when a player quits the game.
--
-- @param player		the player that just quit
-- @since 8/25/2005 10:00:54 AM -- BMH
-- 
function Player_Quit_Event(player)

    Update_Player_Table(player)

    if player == nil then return end

    PlayerQuitTable[player.Get_ID()] = true
end


--
-- This event is triggered when a unit is destroyed in a tactical game mode.
--
-- @param object        the object that was destroyed
-- @param killer        the player that killed this object
-- @since 3/15/2005 4:10:19 PM -- BMH
-- 
function Tactical_Unit_Destroyed_Event(object, killer)
    Update_Kill_Stats_Table(TacticalKillStatsTable, object, killer)
end


--
-- This event is triggered when a unit is destroyed in the galactic game mode.
--
-- @param object        the object that was destroyed
-- @param killer        the player that killed this object
-- @since 3/15/2005 4:10:19 PM -- BMH
-- 
function Galactic_Unit_Destroyed_Event(object, killer)
    --Update_Kill_Stats_Table(GalacticKillStatsTable, object, killer)
    Update_Kill_Stats_Table(TacticalTeamKillStatsTable, object, killer)
end


--
-- This event is triggered when production has begun on an item at a given planet
--
-- @param planet        the planet that will produce this object
-- @param object_type   the object type scheduled for production
-- @since 3/15/2005 4:10:19 PM -- BMH
-- 
function Galactic_Production_Begin_Event(planet, object_type)
    --Track credits spent
end


--
-- This event is triggered when production has been prematurely canceled
-- on an item at a given planet
--
-- @param planet        the planet that was producing this object
-- @param object_type   the object type that got canceled
-- @since 3/15/2005 4:10:19 PM -- BMH
-- 
function Galactic_Production_Canceled_Event(planet, object_type)

    --Track credits spent
end


--
-- This event is triggered when production has finished in a tactical mode
--
-- @param object_type   the object type that was just built
-- @param player			the player that built the object.
-- @param location		the location that built the object(could be nil)
-- @since 8/22/2005 6:11:07 PM -- BMH
-- 
function Tactical_Production_End_Event(object_type, player, location)
end


--
-- This event is triggered when production has finished on an item at a given planet
--
-- @param planet        the planet that produced this object
-- @param object        the object that was just created
-- @since 3/15/2005 4:10:19 PM -- BMH
-- 
function Galactic_Production_End_Event(planet, object)

end


function fake_get_owner()
    return fake_object_player
end

function fake_get_type()
    return fake_object_type
end

function fake_is_valid()
    return true
end

--
-- This event is triggered when the level of a starbase changes
--
-- @param planet        the planet where the starbase is located
-- @param old_type      the old starbase type
-- @param new_type      the new starbase type
-- @since 3/15/2005 4:10:19 PM -- BMH
-- 
function Galactic_Starbase_Level_Change(planet, old_type, new_type)
    if old_type == nil then return end
    if new_type ~= nil then return end

    fake_object_type = old_type
    fake_object_player = planet.Get_Owner()
    fake_object = {}
    fake_object.Get_Owner = fake_get_owner
    fake_object.Get_Type = fake_get_type
    fake_object.Get_Game_Scoring_Type = fake_get_type
    fake_object.Is_Valid = fake_is_valid
    Galactic_Unit_Destroyed_Event(fake_object, planet.Get_Final_Blow_Player())
end


--
-- This event is called when a planet changes faction in galactic mode
--
-- @param planet	      The planet object
-- @param newplayer		The new owner player of this planet.
-- @param oldplayer		The old owner player of this planet.
-- @since 6/20/2005 8:37:53 PM -- BMH
-- 
function Galactic_Planet_Faction_Change(planet, newplayer, oldplayer)


end


--
-- This event is called when a hero is neutralized by another hero in galactic mode
--
-- @param hero_type	The hero that was just neutralized
-- @param killer		The hero that just neutralized the above hero.
-- @since 3/21/2005 1:43:44 PM -- BMH
-- 
function Galactic_Neutralized_Event(hero_type, killer)

    Update_Player_Table(killer.Get_Owner())

    killer_id = killer.Get_Owner().Get_ID()

    entry = GalacticNeutralizedTable[killer_id]
    if entry == nil then entry = {} end

    pe = entry[hero_type]
    if pe == nil then
        pe = {neutralized = 1}
    else
        pe.neutralized = pe.neutralized + 1
    end

    entry[hero_type] = pe
    GalacticNeutralizedTable[killer_id] = entry
end


--
-- This function returns the number of frags a given player has for a given object type.
--
-- @param object_type        the object type we want to know about.
-- @param player             the player who's frag count we want to query.
-- @since 3/21/2005 1:23:21 PM -- BMH
-- 
function Get_Frag_Count_For_Type(object_type, player)
    owner_id = player.Get_ID()

    frag_entry = GalacticKillStatsTable[frag_index]
    if frag_entry == nil then return 0 end

    entry = frag_entry[owner_id]
    if entry == nil then return 0 end

    pe = entry[object_type]
    if pe == nil then return 0 end

    return pe.kills
end


--
-- This function returns the number of neutralizes a given player has for a given object type.
--
-- @param object_type        the object type we want to know about.
-- @param player             the player who's neutralize count we want to query.
-- @since 3/21/2005 1:23:21 PM -- BMH
-- 
function Get_Neutralized_Count_For_Type(object_type, player)
    owner_id = player.Get_ID()

    entry = GalacticNeutralizedTable[owner_id]
    if entry == nil then return 0 end

    pe = entry[object_type]
    if pe == nil then return 0 end

    return pe.neutralized
end


function Get_Military_Efficiency(player, kill_stats, build_stats)

    return GameRandom.Get_Float(), GameRandom.Get_Float()
end

function Get_Conquest_Efficiency(player)

    return GameRandom.Get_Float()
end

function Calc_Score_For_Efficiency(eff_val)
    return GameRandom.Get_Float()
end

function Define_Title_Faction_Table()

    -- rebel at 2, empire at 3
    Title_Faction_Table = {
        { 0, "TEXT_REBEL_TITLE0", "TEXT_EMPIRE_TITLE0" },

    }
end

function Debug_Print_Score_Vals()

end

--
-- This function returns the a game stat for the given control id.
--
-- @param control_id         the control id
-- @return the game stat
-- @since 6/18/2005 4:13:13 PM -- BMH
-- 
function Get_Game_Stat_For_Control_ID(player, control_id, for_tactical)

    if for_tactical then
        mill_eff, kill_eff = Get_Military_Efficiency(player, nil, nil)
    else
        mill_eff, kill_eff = Get_Military_Efficiency(player, nil, nil)
    end

    if control_id == "IDC_MILITARY_EFFICIENCY_STATIC" then
        return mill_eff
    elseif control_id == "IDC_CONQUEST_EFFICIENCY_STATIC" then
        return Get_Conquest_Efficiency(player)
    elseif control_id == "IDC_KILL_EFFICIENCY_STATIC" then
        return kill_eff
    elseif control_id == "IDC_YOUR_LOSS_VAL_STATIC" or control_id == "IDC_ENEMY_LOSS_VAL_STATIC" then
        return Calc_Score_For_Efficiency(mill_eff) + Calc_Score_For_Efficiency(kill_eff)
    elseif control_id == "IDC_TITLE_STATIC" then
        score = Calc_Score_For_Efficiency(mill_eff)
        score = score + Calc_Score_For_Efficiency(kill_eff)
        score = score + Calc_Score_For_Efficiency(Get_Conquest_Efficiency(player))
        tid = 3
        if player.Get_Faction_Name() == "REBEL" then
            tid = 2
        end

        if PlayerQuitTable[player.Get_ID()] == true then
            score = 0
        end

        for ival,pe in ipairs(Title_Faction_Table) do
            last = pe[tid]
            if score > pe[1] then
                break
            end
        end
        return last
    else
        MessageBox("Unknown control id %s:%s for Get_Game_Stat_For_Control_ID", type(control_id), tostring(control_id));
    end

end

--
-- This function updates the table of GameSpy game stats.
--
-- @since 3/29/2005 5:14:42 PM -- BMH
-- 
function Update_GameSpy_Game_Stats()

end

--
-- This function updates the table of GameSpy player kill stats.
--
-- @param stat_table		the stat table we should pull stats from
-- @param player			the player who's stats we need to update.
-- @since 3/29/2005 5:14:42 PM -- BMH
-- 
function Update_GameSpy_Kill_Stats(stat_table, build_stats, player)

end

--
-- This function updates the table of GameSpy player stats.
--
-- @param player		the player who's stats we need to update.
-- @since 3/29/2005 5:14:42 PM -- BMH
-- 
function Update_GameSpy_Player_Stats(player)

end

function Get_Current_Winner_By_Score()
    return WinnerID
end
