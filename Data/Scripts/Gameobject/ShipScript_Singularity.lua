require("PGStateMachine")

function Definitions()

	ServiceRate = 1

	Define_State("State_Init", State_Init);
	Define_State("State_AI_Autofire", State_AI_Autofire)
	Define_State("State_Human_No_Autofire", State_Human_No_Autofire)
	Define_State("State_Human_Autofire", State_Human_Autofire)

	ability_name = "STEALTH"
	working = false

end

function State_Init( message )
	if message == OnEnter then
		if Get_Game_Mode() ~= "Space" then ScriptExit() end
	end

	if message == OnUpdate then
		if (Object.Is_Ability_Ready(ability_name)) and (working == false) then
			Object.Activate_Ability(ability_name, true)
			working = true	
			Sleep( 5.0 )
		end
		if (working == true) and (Object.Get_Rate_Of_Damage_Taken() > 240.0) then
			Object.Activate_Ability(ability_name, false)
			working = false
			Sleep( 0.6 )
			Object.Activate_Ability(ability_name, true)
			working = true
			Sleep( 5.0 )
		end
	end
end