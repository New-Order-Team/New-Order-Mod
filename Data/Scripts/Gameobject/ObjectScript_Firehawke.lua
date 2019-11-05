require("PGStateMachine")

function Definitions()
	ServiceRate = 1
	Define_State("State_Init", State_Init);
	Define_State("State_Normal", State_Normal)
end

function State_Init(message)
	if message == OnEnter then
		-- prevent this from doing anything in galactic mode
		if Get_Game_Mode() ~= "Land" then ScriptExit() end
		Set_Next_State("State_Normal")
	end
end

function State_Normal(message)
	if message == OnUpdate then
		Game_Message("TEXT_TOOLTIP_ABILITY_TEEZL_ACTIVE")
		
		if Object.Is_Ability_Active("STIM_PACK") then
			Object.Take_Damage(16)
		end
	end		
end