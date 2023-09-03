
require("pgevents")

-- Tell the script pooling system to pre-cache this number of scripts.
ScriptPoolCount = 16

function Definitions()
	Category = "Build_Space_Forces"
	IgnoreTarget = true
	
	--Fighters are omitted deliberately.  Since they're cheap, build fast and are quickly killed it's typically better
	--to build them as we need them to attack.  For defensive purposes we'll rely on space station garrisons for our fighter
	--needs
	TaskForce = {
	{
		"ReserveForce"  -- ReserveForce: Deals with planet garrisons.
		,"DenyHeroAttach"
		,"Corvette = 0,16"
		,"Frigate = 0,8"
		,"Capital = 0,4"
		,"Dreadnought = 0,1"
	}
	}
	RequiredCategories = { "Corvette | Frigate | Capital" }
	AllowFreeStoreUnits = false
	
	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function ReserveForce_Thread()	
	ReserveForce.Set_As_Goal_System_Removable(false)
	BlockOnCommand(ReserveForce.Produce_Force())
	ReserveForce.Set_Plan_Result(true)
end
