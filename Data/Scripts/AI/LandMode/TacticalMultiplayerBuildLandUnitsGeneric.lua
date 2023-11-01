require("pgevents")


function Definitions()
	
	Category = "Tactical_Multiplayer_Build_Land_Units_Generic"
	IgnoreTarget = true
	TaskForce = {
		{
			"ReserveForce"
			,"RC_Level_Two_Tech_Upgrade | RC_Level_Three_Tech_Upgrade = 0,1"
			,"EC_Level_Two_Tech_Upgrade | EC_Level_Three_Tech_Upgrade = 0,1"
			,"Infantry = 0,5"
			,"Vehicle = 0,5"
			,"Air = 0,2"
			,"LandHero = 0,1"
		}
	}
	RequiredCategories = {"Infantry | Vehicle | Air | LandHero | Upgrade"}
	AllowFreeStoreUnits = false

end

function ReserveForce_Thread()
			
	ReserveForce.Set_Plan_Result(true)
	ReserveForce.Set_As_Goal_System_Removable(false)
	BlockOnCommand(ReserveForce.Produce_Force())

	-- Give some time to accumulate money.
	tech_level = PlayerObject.Get_Tech_Level()
	min_credits = 500
	if tech_level == 1 then
		min_credits = 1000
	elseif tech_level >= 2 then
		min_credits = 2000
	end
	
	max_sleep_seconds = 30
	current_sleep_seconds = 0
	while (PlayerObject.Get_Credits() < min_credits) and (current_sleep_seconds < max_sleep_seconds) do
		current_sleep_seconds = current_sleep_seconds + 1
		Sleep(1)
	end
		
	ScriptExit()
end