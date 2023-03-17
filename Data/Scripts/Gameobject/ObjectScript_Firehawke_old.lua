require("PGStateMachine")

function Definitions()

	ServiceRate = 1
	
	Define_State("State_Init", State_Init)
	Define_State("State_AI_Autofire", State_AI_Autofire)
	Define_State("State_Human_No_Autofire", State_Human_No_Autofire)
	Define_State("State_Human_Autofire", State_Human_Autofire)
	Define_State("State_Repair", State_Repair)

	nearby_unit_count = 0
	safe_range = 900
	ability_name = "STIM_PACK"
	
	recent_enemy_units = {}
end

function State_Init(message)
	if message == OnEnter then

		-- prevent this from doing anything in galactic mode
		if Get_Game_Mode() ~= "Land" then
			ScriptExit()
		end

		nearby_unit_count = 0
		nearby_unit_threat = 0
		recent_enemy_units = {}

		Register_Prox(Object, Unit_Prox, ability_range)
		
		if Object.Get_Owner().Is_Human() then
			Set_Next_State("State_Human_No_Autofire")
		else
			Set_Next_State("State_AI_Autofire")
		end
	end
end

function State_AI_Autofire(message)
	if message == OnUpdate then
		if ((nearby_unit_count < 1) and (Object.Get_Hull < 0.8) and (Object.Is_Ability_Ready(ability_name))) then
			Try_Ability(Object, ability_name)
		end
		if Object.Is_Ability_Active(ability_name) then
			Set_Next_State("State_Repair")
		end
	end		
end

function State_Human_No_Autofire(message)
	if message == OnUpdate then
		if Object.Is_Ability_Autofire(ability_name) then
			Set_Next_State("State_Human_Autofire")
		end
		if Object.Is_Ability_Active(ability_name) then
			Set_Next_State("State_Repair")
		end
	end
end

function State_Human_Autofire(message)
	if message == OnUpdate then
		if Object.Is_Ability_Autofire(ability_name) then
			if ((nearby_unit_count < 1) and (Object.Get_Hull < 0.8) and (Object.Is_Ability_Ready(ability_name))) then
				Try_Ability(Object, ability_name)
			end
		else
			Set_Next_State("State_Human_No_Autofire")
		end
		if Object.Is_Ability_Active(ability_name) then
			Set_Next_State("State_Repair")
		end
	end				
end

function State_Repair(message)
	if message == OnEnter then
	    Game_Message("TEXT_TOOLTIP_ABILITY_TEEZL_ACTIVE")
	end
	if message == OnUpdate then
		if not (Object.Is_Ability_Active(ability_name)) then
			if Object.Get_Owner().Is_Human() then
				Set_Next_State("State_Human_No_Autofire")
			else
				Set_Next_State("State_AI_Autofire")
			end
		end
		else
			Object.Take_Damage(-16)
		end
	end
	if message == OnExit then
	    Game_Message("TEXT_TOOLTIP_ABILITY_TEEZL_ACTIVE")
	end
end

function Unit_Prox(self_obj, trigger_obj)
	if not trigger_obj.Get_Owner().Is_Enemy(Object.Get_Owner()) then
		return
	end

	if trigger_obj.Is_In_Garrison() then
		return
	end

	-- If we haven't seen this unit recently, track him
	if recent_enemy_units[trigger_obj] == nil then
		nearby_unit_count = nearby_unit_count + 1
		recent_enemy_units[trigger_obj] = trigger_obj
	end
end