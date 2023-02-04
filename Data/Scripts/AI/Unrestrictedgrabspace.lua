
require("pgtaskforce")

-- Tell the script pooling system to pre-cache this number of scripts.
ScriptPoolCount = 4

function Definitions()	
	MinContrastScale = 1.1
	MaxContrastScale = 1.3
		
	Category = "Unrestricted_Grab_Space"
	TaskForce = {
	{
		"MainForce"
		,"DenyHeroAttach"
		,"Corvette | Frigate | Cruiser | Capital = 100%"
	}
	}
	RequiredCategories = {"AntiFighter", "Cruiser | Capital"}
	
	LandSecured = false
	end_blockade = 0
	
	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function MainForce_Thread()
	
	-- Since we're using plan failure to adjust contrast, we're 
	-- only concerned with failures in battle. Default the 
	-- plan to successful and then 
	-- only on the event of our task force being killed is the
	-- plan set to a failed state.
	MainForce.Set_Plan_Result(true)	
	
	--For fast execution, build and attack in one plan rather than having the first few iterations
	--feed the freestore
	AssembleForce(MainForce)
	
	if EvaluatePerception("Space_Force_Limit_For_Unrestricted_Grab", PlayerObject, Target) <= EvaluatePerception("Space_Contrast", PlayerObject, Target) then
		DebugMessage("%s -- planet too well defended now, exiting", tostring(Script))
		MainForce.Set_Plan_Result(false)	
		ScriptExit()
	end

	BlockOnCommand(MainForce.Move_To(Target))
	
	if MainForce.Get_Force_Count() == 0 then
		DebugMessage("%s -- taskforce destroyed, exiting", tostring(Script))
		MainForce.Set_Plan_Result(false)	
		ScriptExit()
	end
	
	--Sit and blockade the planet
	blockade_time = GameRandom.Free_Random(15, 120)
	DebugMessage("%s -- blockading, rolled %s", tostring(Script), tostring(blockade_time))
	while blockade_time > 0 do
		Sleep(1)
		blockade_time = blockade_time - 1
	end
	DebugMessage("%s -- blockade ended", tostring(Script))
		
	ScriptExit()
end

function MainForce_Production_Failed(failed_object_type)
	ScriptExit()
end

function MainForce_Original_Target_Owner_Changed(tf, old_owner, new_owner)	
	--If we take control of this planet than we'll release our blockading units
	if new_owner == PlayerObject then
		ScriptExit()
	end
end