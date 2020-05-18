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
		,"Y-Wing_Squadron | Y-Wing_Squadron2 | Z95_Headhunter_Squadron | Z95_Headhunter2_Squadron | R41_Squadron | Rebel_X-Wing_Squadron | X-Wing_Squadron2 | X-Wing_Squadron3 | X-Wing_Squadron4 | X-Wing_Squadron5 | A_Wing_Squadron | A_Wing_Squadron2 | A_Wing_Squadron3 | B-Wing_Squadron | B-Wing_Squadron2 | K_Wing_Squadron | E_Wing_Squadron | E_Wing_Squadron2 | Consular_Cruiser | Republic_Assault_Cruiser | Corellian_Corvette | Corellian_Gunboat | Marauder_Corvette | Sacheen | Warrior_Gunship | Ranger_Gunship | Defender_Carrier | Nebulon_B_Frigate | CC-7700_Frigate | CC-7700E_Frigate | MC_40a | Liberator_Carrier | Majestic_Heavy_Cruiser | MC30_Frigate | Bothan_Assault_Cruiser | Munificent_Frigate_Rebel | Dreadnought | Alliance_Assault_Frigate | Alliance_Assault_Frigate2 | Recusant_Frigate | Calamari_Cruiser | Calamari_Cruiser_HO_Type | MC_80b | Dauntless_Cruiser | Mc90 | EnduranceSD | NebulaSD | Galactic_Battle_Carrier | MC_Heavy_Carrier | Strident_Star_Defender = 0,3"
		,"Y-Wing_Longprobe_Squadron = 0,1"
		,"V-Wing_Nimbus_Squadron | Arc_170_Squadron | TIE_Fighter_Squadron | TIE_Bomber_Squadron | TIE_Interceptor_Squadron | TIE_Avenger_Squadron | TIE_Starhunter_Squadron | TIE_Scimitar_Squadron | Assault_Gunboat_Squadron | Assassin_Corvette | Empire_Corellian_Gunboat | Lancer_Frigate | Tartan_Patrol_Cruiser | Heavy_Carrack | Dreadnought_Imp | Acclamator_Assault_Ship | Interdictor_Cruiser | Nebulon_B_Frigate_Empire | Nebulon_B2_Frigate_Imp | Strike_Cruiser | Eidolon | Vindicator_Cruiser | Gladiator_Carrier | Escort_Carrier | Victory_Destroyer | Victory_2_Destroyer | Venator | Star_Destroyer | Star_Destroyer_2 | Star_Destroyer_3 | Dominator | Tector | Turbulent_Destroyer = 0,3"
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