require("pgevents")


function Definitions()
	
	Category = "Tactical_Multiplayer_Build_Space_Units_Generic"
	IgnoreTarget = true
	TaskForce = {
		{
			"ReserveForce"
			,"RS_Level_Two_Starbase_Upgrade | RS_Level_Three_Starbase_Upgrade | RS_Level_Four_Starbase_Upgrade | RS_Level_Five_Starbase_Upgrade = 0,1"
			,"ES_Level_Two_Starbase_Upgrade | ES_Level_Three_Starbase_Upgrade | ES_Level_Four_Starbase_Upgrade | ES_Level_Five_Starbase_Upgrade = 0,1"
			,"Fighter | Bomber = 0,5"
			,"Corvette = 0,3"
			,"Frigate = 0,3"
			,"Capital = 0,3"
			,"Dreadnought = 0,1"
			,"SpaceHero = 0,1"
			,"AntiFighter = 0,1"
		}
	}
	RequiredCategories = {"Corvette | Frigate | Capital | SpaceHero | Upgrade"}
	AllowFreeStoreUnits = false

end

function ReserveForce_Thread()
			
	BlockOnCommand(ReserveForce.Produce_Force())
	ReserveForce.Set_Plan_Result(true)
	ReserveForce.Set_As_Goal_System_Removable(false)
		
	-- Give some time to accumulate money.
	tech_level = PlayerObject.Get_Tech_Level()
	min_credits = 5000
	max_sleep_seconds = 15
	if tech_level == 2 then
		min_credits = 7500
	elseif tech_level == 3 then
		min_credits = 10000
	elseif tech_level == 4 then
		min_credits = 15000
	elseif tech_level == 5 then
		min_credits = 20000
	end
	
	current_sleep_seconds = 0
	while (PlayerObject.Get_Credits() < min_credits) and (current_sleep_seconds < max_sleep_seconds) do
		current_sleep_seconds = current_sleep_seconds + 1
		Sleep(1)
	end

	ScriptExit()
end