
require("pgevents")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	
	Category = "Sweep_Area"
	MaxContrastScale = 1.0
	TaskForce = {
	{
		"MainForce"
		,"Fighter | Corvette = 100%"
	}
	}
	RequiredCategories = { "AntiFighter" }
	
	AllowEngagedUnits = false

	kill_target = nil
	
	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	
	QuickReinforce(PlayerObject, AITarget, MainForce)
		
	MainForce.Collect_All_Free_Units("Fighter")
	SetClassPriorities(MainForce, "Attack_Move")
	MainForce.Activate_Ability("TURBO", true)
	Try_Ability(MainForce, "STEALTH")
	
	BlockOnCommand(MainForce.Attack_Move(AITarget))
	MainForce.Activate_Ability("TURBO", false)

	-- Try to at least find something, since we bothered coming over here
	-- There may be an enemy unit exposed, but the initial attack_move to the cell didn't find it.
	MainForce.Set_As_Goal_System_Removable(false)
	Target = Find_Nearest(MainForce, "Transport", PlayerObject, false)
	if TestValid(Target) then
		BlockOnCommand(MainForce.Attack_Move(Target))
	else
		Target = Find_Nearest(MainForce, "Fighter | Bomber | Corvette", PlayerObject, false)
		if TestValid(Target) then
			BlockOnCommand(MainForce.Attack_Move(Target))
		else
			Target = FindDeadlyEnemy(MainForce)
			if TestValid(Target) then
				BlockOnCommand(MainForce.Attack_Move(Target))
			end
		end
	end
	
	MainForce.Set_Plan_Result(true)
		
	ScriptExit()
end

-- Make sure that units don't sit idle at the end of their move order, waiting for others
function MainForce_Unit_Move_Finished(tf, unit)

	DebugMessage("%s -- %s reached end of move, giving new order", tostring(Script), tostring(unit))

	-- Assist the tf with whatever is holding it up
	kill_target = FindDeadlyEnemy(tf)
	if TestValid(kill_target) then
		unit.Attack_Move(kill_target)
	else
		unit.Attack_Move(tf)
	end
end