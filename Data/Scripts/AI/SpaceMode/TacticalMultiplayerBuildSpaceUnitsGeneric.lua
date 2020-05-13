-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/TacticalMultiplayerBuildSpaceUnitsGeneric.lua#5 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/TacticalMultiplayerBuildSpaceUnitsGeneric.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 54441 $
--
--          $DateTime: 2006/09/13 15:08:39 $
--
--          $Revision: #5 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")


function Definitions()
	
	Category = "Tactical_Multiplayer_Build_Space_Units_Generic"
	IgnoreTarget = true
	TaskForce = {
		{
		"ReserveForce"
		,"RS_Level_Two_Starbase_Upgrade | RS_Level_Three_Starbase_Upgrade | RS_Level_Four_Starbase_Upgrade | RS_Level_Five_Starbase_Upgrade | RS_Level_Six_Starbase_Upgrade = 0,1"
		,"ES_Level_Two_Starbase_Upgrade | ES_Level_Three_Starbase_Upgrade | ES_Level_Four_Starbase_Upgrade | ES_Level_Five_Starbase_Upgrade | ES_Level_Six_Starbase_Upgrade = 0,1"
		,"X_Wing_New_Squadron | A_Wing_New_Squadron | Y_Wing_New_Squadron | CR90_New | DP20_New | Nebulon_B_Frigate_New | Neutron_Star_New | Assault_Frigate_New | MC80_New = 0,3"
		,"Y-Wing_Longprobe_Squadron = 0,1"
		,"TIE_ln_New_Squadron | TIE_in_New_Squadron | TIE_sa_New_Squadron | Nebulon_B_Frigate_New | Carrack_Cruiser_New | Strike_Cruiser_New | Dreadnought_New | Imperial_Star_Destroyer_I_New = 0,3"
		,"TIE_Scout_Squadron | TIE_Phantom_Squadron | TIE_Hunter_Squadron | TIE_Defender_Squadron | Missile_Boat_Squadron = 0,1"
		,"Rogue_Squadron_Space | Sundered_Heart | Han_Solo_Team_Space_MP | Home_One = 0,1"
		,"Accuser_Star_Destroyer | Admonitor_Star_Destroyer | Singularity = 0,1"
		}
	}
	RequiredCategories = {"Fighter | Bomber | Corvette | Frigate | Capital | SpaceHero"}
	AllowFreeStoreUnits = false

end

function ReserveForce_Thread()
			
	BlockOnCommand(ReserveForce.Produce_Force())
	ReserveForce.Set_Plan_Result(true)
	ReserveForce.Set_As_Goal_System_Removable(false)
		
	-- Give some time to accumulate money.
	tech_level = PlayerObject.Get_Tech_Level()
	min_credits = 15000
	max_sleep_seconds = 15
	if tech_level == 2 then
		min_credits = 20000
		max_sleep_seconds = 20
	elseif tech_level == 3 then
		min_credits = 25000
		max_sleep_seconds = 15
	elseif tech_level == 4 then
		min_credits = 35000
		max_sleep_seconds = 15
	elseif tech_level == 5 then
		min_credits = 40000
		max_sleep_seconds = 15
	end
	
	current_sleep_seconds = 0
	while (PlayerObject.Get_Credits() < min_credits) and (current_sleep_seconds < max_sleep_seconds) do
		current_sleep_seconds = current_sleep_seconds + 1
		Sleep(1)
	end

	ScriptExit()
end