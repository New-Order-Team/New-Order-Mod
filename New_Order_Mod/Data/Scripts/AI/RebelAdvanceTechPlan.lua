-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/RebelAdvanceTechPlan.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/RebelAdvanceTechPlan.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Andre_Arsenault $
--
--            $Change: 37816 $
--
--          $DateTime: 2006/02/15 15:33:33 $
--
--          $Revision: #1 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")


function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	
	Category = "Advance_Tech_Rebel"
	IgnoreTarget = true
	TaskForce = {
	{
		"TechForce",
		"Rebel_Tech_0_1 | Rebel_Tech_1_2 | Rebel_Tech_2_3 | Rebel_Tech_3_4 | Rebel_Tech_4_5 = 1"
	}
	}

	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function TechForce_Thread()
	DebugMessage("%s -- In TechForce_Thread.", tostring(Script))
	
	-- Ensure that all goal feasability will be reevaluated based on the new production budgetting conditions
	-- (production underway that is already paid for and remains affordable under new budgets should continue)
	Purge_Goals(PlayerObject)

	TechForce.Set_As_Goal_System_Removable(false)
	
	Sleep(1)
	
	BlockOnCommand(TechForce.Produce_Force())
	TechForce.Set_Plan_Result(true)
	
	DebugMessage("%s -- TechForce done!", tostring(Script));
	ScriptExit()
end

function TechForce_Production_Failed(tf, failed_object_type)
	DebugMessage("%s -- Abandonning plan owing to production failure.", tostring(Script))
	ScriptExit()
end