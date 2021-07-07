require("PGStateMachine")

function Definitions()
    Define_State("State_Init", State_Init);
end

function State_Init(message)
    if message == OnEnter then
        if Get_Game_Mode() ~= "Land" then
            ScriptExit()
        end

        player = Find_Attacking_Player()

        if TestValid(player) then
            all_landing_zones = Find_All_Objects_Of_Type("IsRushTarget")
            start_zone = nil
            smallest_distance_to_lz = 20000
            for _,landing_zone in pairs(all_landing_zones) do
                distance_to_lz = landing_zone.Get_Distance(Object)
                DebugMessage("%s -- Distance for LZ %s from Attacker Entry Position %s", tostring(Script), tostring(landing_zone), tostring(distance_to_lz))
                if distance_to_lz < smallest_distance_to_lz then
                    DebugMessage("%s -- Found smaller distance, using LZ %s as start_zone", tostring(Script), tostring(landing_zone))
                    smallest_distance_to_lz = distance_to_lz
                    start_zone = landing_zone
                end
            end

            if start_zone.Get_Owner() == Find_Player("Neutral") then
                start_zone.Change_Owner(player)
            end
        end
    end
end

function Find_Attacking_Player()
    attacker_entry = Find_First_Object("Attacker Entry Position")

    if not TestValid(attacker_entry) then
        return nil
    end

    Sleep(0.5)
	-- Include your custom ground unit categories here
    starting_unit = Find_Nearest(attacker_entry, "Infantry|Vehicle|Air|LandHero")

    if TestValid(starting_unit) and starting_unit.Get_Distance(attacker_entry) < 100 then
        return starting_unit.Get_Owner()
    else
        return nil
    end
end