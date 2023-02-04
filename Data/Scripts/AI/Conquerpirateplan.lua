
require("pgevents")

-- Tell the script pooling system to pre-cache this number of scripts.
ScriptPoolCount = 16

function Definitions()	
	MinContrastScale = 1.0
	MaxContrastScale = 1.15
		
	Category = "Conquer_Pirate"
	TaskForce = {
	{
		"MainForce"
		,"DenyHeroAttach"
		,"MinimumTotalSize = 5"
		,"Infantry | Vehicle | Air | Fighter | Corvette | Frigate | Cruiser | Capital = 100%"
	}
	}
	RequiredCategories = { "Corvette | Frigate | Cruiser", "Infantry | Vehicle | Air" }	
	
	PerFailureContrastAdjust = 0.05
	
	LandSecured = false
	
	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function MainForce_Thread()
	
	-- Since we're using plan failure to adjust contrast, we're 
	-- only concerned with failures in battle. Default the 
	-- plan to successful and then 
	-- only on the event of our task force being killed is the
	-- plan set to a failed state.
	MainForce.Set_Plan_Result(true)	
	
	if MainForce.Are_All_Units_On_Free_Store() == true then
		AssembleForce(MainForce)
	else
		BlockOnCommand(MainForce.Produce_Force());
		return
	end
	
	BlockOnCommand(MainForce.Move_To(Target))
	if MainForce.Get_Force_Count() == 0 then
		MainForce.Set_Plan_Result(false)	
		ScriptExit()
	end
	if Invade(MainForce) == false then
		MainForce.Set_Plan_Result(false)			
		ScriptExit()
	end
	
	LandSecured = true
	FundBases(PlayerObject, Target)
		
	ScriptExit()
end

function MainForce_Production_Failed(failed_object_type)
	ScriptExit()
end

function MainForce_Original_Target_Owner_Changed(tf, old_owner, new_owner)	
	--Ignore changes to neutral - it might just be temporary on the way to
	--passing into my control.
	if new_owner ~= PlayerObject and new_owner.Is_Neutral() == false then
		ScriptExit()
	end
end

function MainForce_No_Units_Remaining()
	if not LandSecured then
		MainForce.Set_Plan_Result(false)			
		ScriptExit()
	end
end