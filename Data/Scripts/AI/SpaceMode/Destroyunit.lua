require("pgevents")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	
	AllowEngagedUnits = false
	MinContrastScale = 1.1
	MaxContrastScale = 3.0
	Category = "Destroy_Unit"
	TaskForce = {
	{
		"MainForce"
		,"MinimumTotalSize = 2"
		,"Corvette | Frigate | Capital | Dreadnought | SpaceHero = 100%"
	},
	{
		"EscortForce"
		,"Fighter = 0,4"
		,"AntiBomber | Corvette | Frigate = 0,4"
	}
	}
	
	ChangedTarget = false
	AttackingShields = false
	DropCurrentTarget = false

	kill_target = nil

	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function MainForce_Thread()
	DebugMessage("%s -- In MainForce_Thread.", tostring(Script))

	BlockOnCommand(MainForce.Produce_Force())
	
	unit_table = MainForce.Get_Unit_Table()
	for i,unit in pairs(unit_table) do
		if unit.Has_Property("IsCarrier") or unit.Has_Property("IsInterdictor") then
			MainForce.Release_Unit(unit)
		end
	end
	
	QuickReinforce(PlayerObject, AITarget, MainForce, EscortForce)
	
	MainForce.Enable_Attack_Positioning(true)
	DebugMessage("MainForce constructed at stage area!")
	
	SetClassPriorities(MainForce, "Attack_Move")

	DebugMessage("%s -- Attack-moving to %s", tostring(Script), tostring (AITarget))
	BlockOnCommand(MainForce.Attack_Move(AITarget, MainForce.Get_Self_Threat_Max()))

	MainForce.Set_Plan_Result(true)
	
	DebugMessage("%s -- MainForce Done!  Exiting Script!", tostring(Script))
	ScriptExit()
end

-- Make sure that units don't sit idle at the end of their move order, waiting for others
function MainForce_Unit_Move_Finished(tf, unit)

	DebugMessage("%s -- %s reached end of move, giving new order", tostring(Script), tostring(unit))

	-- Assist the tf with whatever is holding it up
	kill_target = FindDeadlyEnemy(tf)
	if TestValid(kill_target) and not ((kill_target.Is_Category("Fighter") or kill_target.Is_Category("Bomber"))) then
		unit.Attack_Move(kill_target)
	else
		unit.Attack_Move(tf)
	end
end

function EscortForce_Thread()
   BlockOnCommand(EscortForce.Produce_Force())
   
   QuickReinforce(PlayerObject, AITarget, EscortForce, MainForce)
   
   EscortForce.Guard_Target(MainForce)
   EscortAlive = true
   while EscortAlive do
      Escort(EscortForce, MainForce)
   end
end
