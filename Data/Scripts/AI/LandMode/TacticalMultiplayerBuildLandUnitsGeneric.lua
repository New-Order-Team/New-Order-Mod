-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/TacticalMultiplayerBuildLandUnitsGeneric.lua#7 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/TacticalMultiplayerBuildLandUnitsGeneric.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 56734 $
--
--          $DateTime: 2006/10/24 14:15:48 $
--
--          $Revision: #7 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")


function Definitions()
	
	Category = "Tactical_Multiplayer_Build_Land_Units_Generic"
	IgnoreTarget = true
	TaskForce = {
	{
		"ReserveForce"
		,"Infantry | Vehicle | Air | LandHero | Upgrade = 0,3"
		}
	}
	RequiredCategories = {"Infantry | Vehicle | Air | LandHero | Upgrade"}
	AllowFreeStoreUnits = false

end

function ReserveForce_Thread()
			
	ReserveForce.Set_Plan_Result(true)
	ReserveForce.Set_As_Goal_System_Removable(false)
	BlockOnCommand(ReserveForce.Produce_Force())

	-- Give some time to accumulate money.
	tech_level = PlayerObject.Get_Tech_Level()
	min_credits = 3000
	-- if tech_level == 2 then
		-- min_credits = 3000
	-- elseif tech_level >= 3 then
		-- min_credits = 4000
	-- end
	
	max_sleep_seconds = 60
	current_sleep_seconds = 0
	while (PlayerObject.Get_Credits() < min_credits) and (current_sleep_seconds < max_sleep_seconds) do
		current_sleep_seconds = current_sleep_seconds + 1
		Sleep(1)
	end
		
	ScriptExit()
end