-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/FreeStore/BusyTacticalFreeStore.lua#12 $
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
-- (C) Petroglyph Games, Inc.
--
--
--  *****           **                          *                   *
--  *   **          *                           *                   *
--  *    *          *                           *                   *
--  *    *          *     *                 *   *          *        *
--  *   *     *** ******  * **  ****      ***   * *      * *****    * ***
--  *  **    *  *   *     **   *   **   **  *   *  *    * **   **   **   *
--  ***     *****   *     *   *     *  *    *   *  *   **  *    *   *    *
--  *       *       *     *   *     *  *    *   *   *  *   *    *   *    *
--  *       *       *     *   *     *  *    *   *   * **   *   *    *    *
--  *       **       *    *   **   *   **   *   *    **    *  *     *   *
-- **        ****     **  *    ****     *****   *    **    ***      *   *
--                                          *        *     *
--                                          *        *     *
--                                          *       *      *
--                                      *  *        *      *
--                                      ****       *       *
--
--/////////////////////////////////////////////////////////////////////////////////////////////////
-- C O N F I D E N T I A L   S O U R C E   C O D E -- D O   N O T   D I S T R I B U T E
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/FreeStore/BusyTacticalFreeStore.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 55010 $
--
--          $DateTime: 2006/09/19 19:14:06 $
--
--          $Revision: #12 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgcommands")

function Base_Definitions()

	Common_Base_Definitions()
	
	ServiceRate = 20
	UnitServiceRate = 2

	if Definitions then
		Definitions()
	end
	
	FREE_STORE_ATTACK_RANGE = 8000.0
end

function main()
	
	if FreeStoreService then
		while 1 do
			FreeStoreService()
			PumpEvents()
		end
	end
	
	ScriptExit()
end

function On_Unit_Added(object)
end


function FreeStoreService()
	enemy_location = FindTarget.Reachable_Target(PlayerObject, "Current_Enemy_Location", "Tactical_Location", "Any_Threat", 0.8)
	friendly_location = FindTarget.Reachable_Target(PlayerObject, "Current_Friendly_Location", "Tactical_Location", "Any_Threat", 0.8)
	if (EvaluatePerception("Allowed_As_Defender_Space_Untargeted", PlayerObject) > 0.0) then
		DebugMessage("%s -- Aggressive mode activated", tostring(Script))
		aggressive_mode = true
	end
	
	--Manage the space station in space mode
	if TestValid(space_station) then
		station_threat = FindDeadlyEnemy(space_station)
		if station_threat then
			space_station.Attack_Target(station_threat)
		end
	else
		space_station = PlayerObject.Get_Space_Station()
	end
end

function On_Unit_Service(object)
	
	if not TestValid(object) then
		return
	end
	
	if object.Is_Category("Structure") or object.Is_Category("Transport") then
		return
	end
	
	current_target = object.Get_Attack_Target()
	if TestValid(current_target) then

		if Service_Heal(object, 0.6) then
			return
		end
		
		if object.Is_Category("Fighter") or object.Is_Category("Bomber") or object.Is_Category("Transport") or object.Is_Category("Corvette") or object.Is_Category("Frigate") or object.Is_Category("Cruiser") then			
			if Service_Kite(object) then
				return
			end
		end

		object.Activate_Ability("SPOILER_LOCK", false)

		Try_Weapon_Switch(object, current_target)
	end
	
	if not object.Has_Active_Orders() then
		
		--Keep bored objects mobile
		--object.Activate_Ability("SPOILER_LOCK", true)		

		if object.Is_Category("Fighter") or object.Is_Category("Bomber") or object.Is_Category("Transport") or object.Is_Category("Corvette") then
			
			if Service_Kite(object) then
				return
			end

			Service_Guard(object)
				
		end
		
		if Service_Heal(object, 0.75) then
			return
		end
		
		if Service_Attack(object) then
			return
		end
		
		Service_Guard(object)
		
	end
end

function Service_Heal(object, health_threshold)

	--Add difficulty factor here

	if object.Get_Hull() < health_threshold then
	
		-- Try to find the nearest healing structure appropriate for this unit
		lib_fs_healer_property_flag = Get_Special_Healer_Property_Flag(object)
		-- if not lib_fs_healer_property_flag then
			-- if object.Is_Category("Infantry") then
				-- lib_fs_healer_property_flag = "HealsInfantry"
			-- elseif object.Is_Category("Vehicle") then
				-- lib_fs_healer_property_flag = "HealsVehicles"
			-- end 
		-- end
		
		if lib_fs_healer_property_flag then
			healer = Find_Nearest(object, lib_fs_healer_property_flag, PlayerObject, true)
		end
	
		if TestValid(healer) then
			if object.Get_Distance(healer) > 1000.0 then
				Try_Ability(object,"TURBO")
				Try_Ability(object, "SPOILER_LOCK")
				Try_Ability(object, "STEALTH")
				
				object.Move_To(healer, 10)
				return true
			end
		end
	end

	return false
	
end

function Service_Attack(object)

	--Move to the enemy position rather than the enemy itself in order to leave us free
	--to run autonomous targeting.  While this doesn't provide chase behavior we're probably
	--repeating this enough that we don't care
	closest_enemy = Find_Nearest(object, object.Get_Owner(), false)

	if TestValid(closest_enemy) then
		if object.Get_Distance(closest_enemy) < FREE_STORE_ATTACK_RANGE and not closest_enemy.Is_Good_Against(object) then
			if object.Get_Distance(closest_enemy) > object.Get_Type().Get_Max_Range() then
				object.Attack_Target(closest_enemy)
			else
				object.Attack_Move(Project_By_Unit_Range(object, closest_enemy.Get_Position()))
			end
			return true		
		elseif aggressive_mode then
			object.Attack_Move(closest_enemy.Get_Position())
			return true
		end
	elseif TestValid(enemy_location) then
		if aggressive_mode then
			object.Attack_Move(enemy_location)
			return true
		end
	end

	damaged_enemy = FindTarget.Reachable_Target(PlayerObject, "Enemy_Unit", "Any_Threat", 0.9)

	if TestValid(damaged_enemy) then
		object.Attack_Target(damaged_enemy)
		return true
	end	
		
	return false
end

function Service_Guard(object)

	closest_friendly_structure = Find_Nearest(object, "Structure", object.Get_Owner(), true)
	
	if TestValid(friendly_location) then
		object.Attack_Move(friendly_location)
		return true
	elseif aggressive_mode and TestValid(enemy_location) then
		object.Attack_Move(enemy_location)
		return true
	elseif TestValid(closest_friendly_structure) then
		object.Guard_Target(closest_friendly_structure)
		return true
	elseif TestValid(enemy_location) then
		object.Attack_Move(enemy_location)
		return true
	end

	return false
end

function Service_Kite(object)
	
	lib_fs_deadly_enemy = FindDeadlyEnemy(object)
	
	if TestValid(lib_fs_deadly_enemy) then
		if Try_Ability(object, "BUZZ_DROIDS", object) then
			return true
		end		
	
		Try_Ability(object, "TURBO")
		Try_Ability(object, "SPOILER_LOCK")
		Try_Ability(object, "STEALTH")
	
		lib_fs_kite_pos = Project_By_Unit_Range(lib_fs_deadly_enemy, object)

		object.Move_To(lib_fs_kite_pos)
		
		return true
	end

	return false
end