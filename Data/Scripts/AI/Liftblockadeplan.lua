
require("pgevents")

function Definitions()
	
	Category = "Lift_Blockade"

	TaskForce = {
	{
		"MainForce"
		,"MinimumTotalSize = 4"
		,"MinimumTotalForce = 2500"					
		,"Fighter | Corvette | Frigate | Cruiser | Capital | Dreadnought = 100%"
	}
	}
	RequiredCategories = { "AntiFighter", "Cruiser | Capital | Dreadnought" }
	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function MainForce_Thread()
	
	-- Converge all task force units upon the target simultaneously
	SynchronizedAssemble(MainForce)
	if MainForce.Get_Force_Count() > 0 then
		MainForce.Set_Plan_Result(true)
		MainForce.Release_Forces(1.0)
	end
	
	ScriptExit()
end

function MainForce_Production_Failed(tf, failed_object_type)
	ScriptExit()
end

function MainForce_No_Units_Remaining()
	MainForce.Set_Plan_Result(false)
end
