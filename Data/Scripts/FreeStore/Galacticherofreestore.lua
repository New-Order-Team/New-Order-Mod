-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/FreeStore/GalacticHeroFreeStore.lua#2 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/FreeStore/GalacticHeroFreeStore.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 56728 $
--
--          $DateTime: 2006/10/24 14:14:34 $
--
--          $Revision: #2 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgcommands")

function Definitions()
	DebugMessage("%s -- Defining custom freestore movement perceptions", tostring(Script))

	-- Table which maps heroes to perceptions for systems they like to hang out on when not in active use
	-- The boolean is for whether or not the hero prefers to stay in space, if he has a choice
	-- Generally, this is to find the system where their abilities provide the best defensive or infrastructure bonuses
	CustomUnitPlacement = {
		EMPEROR_PALPATINE_TEAM = {"High_Income_Planet", false}
		,DANETTA_PITTA_TEAM = {"High_Income_Planet", true}
		,AVATAR_SD = {"High_Income_Planet", true}
		,IRON_FIST_SD = {"High_Income_Planet", true}
		,IRON_FIST_SSD = {"High_Income_Planet", true}
		
		,RAYMUS_ANTILLES_TEAM = {"High_Income_Planet", true}
		,RAL_RAI_MUVUNC_TEAM = {"High_Income_Planet", false}
		,TYR_TASKEEN_TEAM = {"High_Income_Planet", false}
		,CALRISSIAN_COBRA = {"High_Income_Planet", true}
		,CALRISSIAN_LIBERATOR = {"High_Income_Planet", true}
	}
	
end

function Find_Custom_Target(object)
	object_type = object.Get_Type()
	object_type_name = object_type.Get_Name()

	unit_entry = CustomUnitPlacement[object_type_name]

	if unit_entry then
		perception = unit_entry[1]
		prefers_space = unit_entry[2]
		if perception ~= nil then
			target = FindTarget.Reachable_Target(PlayerObject, perception, "Friendly", "No_Threat", 1.0, object)
			if TestValid(target) then
				DebugMessage("%s -- Safe hero target %s found for %s", tostring(Script), tostring(target), tostring(object))
				return target
			end
		end
		
		if prefers_space then
			return Find_Space_Unit_Target(object)
		else
			return Find_Ground_Unit_Target(object)
		end
	else
		DebugMessage("%s -- Error: Type %s not found in CustomUnitPlacement table.", tostring(Script), object_type_name)
	end
end
	

