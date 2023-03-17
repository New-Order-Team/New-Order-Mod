require("pgevents")

function Definitions()
	
	Category = "Land_Units"
	TaskForce = {
	{
		"MainForce"
		,"DenyHeroAttach"	
		,"Infantry = 0,5"
		,"Vehicle = 0,5"
		,"Air = 0,2"
	}
	}
	
	IgnoreTarget = true
	AllowEngagedUnits = false
end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	
	--Immediately release anybody that was already landed
	MainForce.Release_Forces(1.0)

	-- find something to reinforce near
	friendly_loc = FindTarget(MainForce, "Current_Friendly_Location", "Tactical_Location", 1.0)
	if not TestValid(friendly_loc) then
		friendly_loc = FindTarget(MainForce, "Is_Friendly_Start", "Tactical_Location", 1.0)
	end
	if not TestValid(friendly_loc) then
		ScriptExit()
	end
	
	WaitForAllReinforcements(MainForce, friendly_loc)
	
	MainForce.Release_Forces(1)
    MainForce.Set_Plan_Result(true)
	Sleep(15)
end




