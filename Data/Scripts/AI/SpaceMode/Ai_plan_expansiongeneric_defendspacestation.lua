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
	}
	}

end

function MainForce_Thread()

	focus_fire_on_target = Find_Nearest(Target, "Frigate | Capital | Dreadnought", PlayerObject, false)
	
	while TestValid(focus_fire_on_target) do
		-- Cancel all goals
		--Purge_Goals(PlayerObject)
		
		Sleep(1)
		
		-- Use all idle units, mapwide
		MainForce.Collect_All_Free_Units()	
		
		while TestValid(focus_fire_on_target) do
			MainForce.Collect_All_Free_Units()
			BlockOnCommand(MainForce.Attack_Target(focus_fire_on_target), 5)
		end
	
		Sleep(1)
		MainForce.Set_Plan_Result(true)
		
		focus_fire_on_target = Find_Nearest(Target, "Frigate | Capital | Dreadnought", PlayerObject, false)
	
	end
end

function MainForce_Unit_Damaged(tf, unit, attacker, deliberate)
	--Override self preservation behavior, just save the station!
end