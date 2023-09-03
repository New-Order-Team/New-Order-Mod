
require("pgevents")

function Definitions()
	
	AllowEngagedUnits = true
	IgnoreTarget = true
	Category = "Defend_Space_Station"
	TaskForce = {
	{
		"MainForce"
		, "TaskForceRequired"
		, "DenySpecialWeaponAttach"
		,"AntiFighter = 0,8"
		,"Frigate = 0,4"
		,"Capital = 0,2"
	}
	}
	
	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function MainForce_Thread()

	focus_fire_on_target = Find_Nearest(Target, "Frigate | Capital | Dreadnought", PlayerObject, false)
	
	BlockOnCommand(MainForce.Produce_Force())
	QuickReinforce(PlayerObject, AITarget, MainForce)
	MainForce.Set_As_Goal_System_Removable(false)
	MainForce.Set_Plan_Result(true)
	
	repeat
		MainForce.Collect_All_Free_Units()
		BlockOnCommand(MainForce.Attack_Target(focus_fire_on_target), 15)
	
		Sleep(5)
		
		focus_fire_on_target = Find_Nearest(Target, "Frigate | Capital | Dreadnought", PlayerObject, false)
	until (not TestValid(focus_fire_on_target) or MainForce.Get_Distance(focus_fire_on_target) > 4000)
	
	DebugMessage("%s -- station threats destroyed, exiting", tostring(Script))
	MainForce.Set_As_Goal_System_Removable(true)
	MainForce.Set_Plan_Result(true)
	MainForce.Release_Forces(1.0)
	ScriptExit()	
end

function MainForce_Unit_Damaged(tf, unit, attacker, deliberate)
	--Override self preservation behavior, just save the station!
end