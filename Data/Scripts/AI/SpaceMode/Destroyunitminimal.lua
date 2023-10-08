require("pgevents")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	
	AllowEngagedUnits = false
	MinContrastScale = 0.2
	MaxContrastScale = 1.3
	Category = "Destroy_Unit_Minimal"
	TaskForce = {
	{
		"MainForce"						
		,"Corvette | Frigate | Capital | SpaceHero = 1,20"
	}
	}
	
 	ChangedTarget = false
	AttackingShields = false
	DropCurrentTarget = false

	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function MainForce_Thread()
	DebugMessage("%s -- In MainForce_Thread.", tostring(Script))

	BlockOnCommand(MainForce.Produce_Force())
	
	QuickReinforce(PlayerObject, AITarget, MainForce)

	MainForce.Enable_Attack_Positioning(true)
	DebugMessage("MainForce constructed at stage area!")

	DebugMessage("%s -- Attacking %s", tostring(Script), tostring (AITarget))
	SetClassPriorities(MainForce, "Attack_Move")
	
	closest_enemy = Find_Nearest(MainForce, "Corvette | Frigate | Capital | Dreadnought | SpaceHero | Structure", PlayerObject, false)
	
	while TestValid(closest_enemy) do
		if MainForce.Get_Distance(closest_enemy) < MainForce.Get_Distance(AITarget) then
			BlockOnCommand(MainForce.Attack_Target(closest_enemy, MainForce.Get_Self_Threat_Max()))
		else
			break
		end
		Sleep(5)
		closest_enemy = Find_Nearest(MainForce, "Corvette | Frigate | Capital | Dreadnought | SpaceHero | Structure", PlayerObject, false)
	end
	
	BlockOnCommand(MainForce.Attack_Move(AITarget))

	MainForce.Set_Plan_Result(true)
	
	DebugMessage("%s -- MainForce Done!  Exiting Script!", tostring(Script))
	ScriptExit()
end

function MainForce_No_Units_Remaining()
	DebugMessage("%s -- All units dead or non-buildable.  Abandonning plan.", tostring(Script))
	ScriptExit()
end

function MainForce_Target_Destroyed()
	DebugMessage("%s -- Target destroyed!  Exiting Script.", tostring(Script))
	ScriptExit()
end

