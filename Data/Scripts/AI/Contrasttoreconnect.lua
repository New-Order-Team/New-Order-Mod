
require("pgevents")

-- Tell the script pooling system to pre-cache this number of scripts.
ScriptPoolCount = 16

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	
	Category = "Conquer_To_Reconnect"
	TaskForce = {
	-- First Task Force
	{
		"SpaceForce"	
		,"MinimumTotalSize = 5"
		,"Corvette | Frigate | Capital = 100%"
		,"Dreadnought = 0,3"
		,"AntiFighter = 1,10"
		,"AntiCapital = 1,5"
		,"SpaceHero = 0,1"
	},
	{
		"GroundForce"
		,"MinimumTotalSize = 4"
		,"MinimumTotalForce = 1000"
		,"Infantry | Vehicle | HeavyVehicle | Air = 100%"
		,"LandHero = 0,1"
	}
	}
	RequiredCategories = { "Infantry", "Vehicle | HeavyVehicle", "AntiFighter", "Frigate | Capital", "AntiCapital" }		--Must have at least one ground unit, also make sure space force is reasonable

	PerFailureContrastAdjust = 0.5
	
	SpaceSecured = true
	LandSecured = false
	InSpaceConflict = false
	WasConflict = false
	
	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function SpaceForce_Thread()
	DebugMessage("%s -- In SpaceForce_Thread.", tostring(Script))

	-- Since we're using plan failure to adjust contrast, we're 
	-- only concerned with failures in battle. Default the 
	-- plan to successful and then 
	-- only on the event of our task force being killed is the
	-- plan set to a failed state.
	SpaceForce.Set_Plan_Result(true)
		
	SpaceSecured = false

	if SpaceForce.Are_All_Units_On_Free_Store() == true then
		DebugMessage("SpaceForce converged on target (disconnecting node)")
		SynchronizedAssemble(SpaceForce)
		WasConflict = true
	else
		DebugMessage("%s -- Can't freestore allocate all our units, so just allocating build tasks.", tostring(Script))
		BlockOnCommand(SpaceForce.Produce_Force());
		return
	end
	
	
	if EvaluatePerception("Is_Good_Ground_Grab_Target", PlayerObject, Target) == 0 then
		DebugMessage("%s -- No SpaceForce at target and enemies still present in space.  Abandonning plan.", tostring(Script))
		SpaceForce.Set_Plan_Result(false)
		Exit_Plan_With_Possible_Sleep()
	else
		DebugMessage("%s -- No SpaceForce, but Space at target appears clear anyway.", tostring(Script))
		SpaceSecured = true
	end
		
	while not LandSecured do
		Sleep(5)
	end
		
	SpaceForce.Release_Forces(0.5)
	DebugMessage("%s -- SpaceForce Done!  Exiting Script!", tostring(Script))
end

function GroundForce_Thread()
	DebugMessage("%s -- In GroundForce_Thread.", tostring(Script))

	GroundForce.Set_Plan_Result(true)

	if GroundForce.Are_All_Units_On_Free_Store() == true then

		DebugMessage("%s -- GroundForce waiting for the space force to succede.", tostring(Script))
		while not SpaceSecured do
			if WasConflict then
				Exit_Plan_With_Possible_Sleep()
			end
			Sleep(5)
		end
		DebugMessage("%s -- converging ground units on the target.", tostring(Script))
		SynchronizedAssemble(GroundForce)
	else
		DebugMessage("%s -- Can't freestore allocate all our units, so just allocating build tasks.", tostring(Script))
		BlockOnCommand(GroundForce.Produce_Force());
		return
	end
		
	WasConflict = true
	if Invade(GroundForce) == false then
		DebugMessage("%s -- Curses...The invasion failed!  Exiting Script!", tostring(Script))
		Exit_Plan_With_Possible_Sleep()
	end

	DebugMessage("%s -- Political control changed building Ground and Starbase.", tostring(Script))
	LandSecured = true
	GroundForce.Set_Plan_Result(true)
	FundBases(PlayerObject, Target)
	Exit_Plan_With_Possible_Sleep()
end

function Exit_Plan_With_Possible_Sleep()
	difficulty = "Easy"
	if PlayerObject then
        difficulty = PlayerObject.Get_Difficulty()
    end
    sleep_duration = DifficultyBasedMinPause(difficulty)
	
	if SpaceForce then
		SpaceForce.Release_Forces(1.0)
	end
	GroundForce.Release_Forces(1.0)
	if WasConflict then
		Sleep(sleep_duration)
	end
	ScriptExit()
end

function SpaceForce_Production_Failed(tf, failed_object_type)
	DebugMessage("%s -- Abandonning plan owing to production failure.", tostring(Script))
	ScriptExit()
end

function GroundForce_Production_Failed(tf, failed_object_type)
	DebugMessage("%s -- Abandonning plan owing to production failure.", tostring(Script))
	ScriptExit()
end

function GroundForce_Original_Target_Owner_Changed(tf, old_owner, new_owner)	
	--Ignore changes to neutral - it might just be temporary on the way to
	--passing into my control.
	if new_owner ~= PlayerObject and new_owner.Is_Neutral() == false then
		if (not LandSecured) or (PlayerObject.Get_Difficulty() == "Hard") then
			ScriptExit()
		end
	end
end

function SpaceForce_Original_Target_Owner_Changed(tf, old_owner, new_owner)	
	--Ignore changes to neutral - it might just be temporary on the way to
	--passing into my control.
	if new_owner ~= PlayerObject and new_owner.Is_Neutral() == false then
		if (not LandSecured) or (PlayerObject.Get_Difficulty() == "Hard") then
			ScriptExit()
		end
	end
end

function SpaceForce_No_Units_Remaining()
	if not LandSecured then
		DebugMessage("%s -- All units dead or non-buildable.  Abandonning plan.", tostring(Script))
		SpaceForce.Set_Plan_Result(false) 
		--Don't exit since we need to sleep to enforce delays between AI attacks (can't be done inside an event handler)
	end
end

function GroundForce_No_Units_Remaining()
	if not LandSecured then
		DebugMessage("%s -- All units dead or non-buildable.  Abandonning plan.", tostring(Script))
		GroundForce.Set_Plan_Result(false) 
		--Don't exit since we need to sleep to enforce delays between AI attacks (can't be done inside an event handler)
	end
end

