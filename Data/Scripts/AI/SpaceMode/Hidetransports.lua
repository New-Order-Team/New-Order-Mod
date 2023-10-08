require("pgevents")

function Definitions()

	AllowEngagedUnits = false
	Category = "Hide_Transports"
	IgnoreTarget = true
	TaskForce = 
	{
		{
			"MainForce",
			"Transport = 1,4"
		},
		{
			"EscortForce",
			"Fighter = 0,1"
		}
	}

end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	
	while true do
		AITarget = FindTarget(MainForce, "Space_Area_Is_Hidden", "Tactical_Location", 0.8, 5000.0)
		
		if TestValid(AITarget) then		
			Try_Ability(MainForce, "STEALTH")
			MainForce.Attack_Target(AITarget, 1)
			Sleep(10)
		else
			Sleep(0.1)
		end
	end
	
	ScriptExit()
end 

function EscortForce_Thread()
	BlockOnCommand(EscortForce.Produce_Force())
	
	-- Give an initial order to put the escorts in a state that the Escort function expects
	EscortForce.Guard_Target(MainForce)

	EscortAlive = true
	while EscortAlive do
		Escort(EscortForce, MainForce)
	end
end

function MainForce_No_Units_Remaining()
	DebugMessage("%s -- All units dead or non-buildable.  Abandonning plan.", tostring(Script))
	ScriptExit()
end

function EscortForce_No_Units_Remaining()
	EscortAlive = false
end