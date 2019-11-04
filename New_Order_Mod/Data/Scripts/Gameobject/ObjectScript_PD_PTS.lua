require("PGStateMachine")

function Definitions()

	ServiceRate = 1

	Define_State("State_Init", State_Init);
	Define_State("State_AI_Autofire", State_AI_Autofire)
	Define_State("State_Human_No_Autofire", State_Human_No_Autofire)
	Define_State("State_Human_Autofire_12", State_Human_Autofire_12)
	Define_State("State_Human_Autofire_1", State_Human_Autofire_1)
	Define_State("State_Human_Autofire_2", State_Human_Autofire_2)

	ability_name_1 = "LASER_DEFENSE"
	ability_name_2 = "DEFEND"
	
end

function State_Init(message)
	if message == OnEnter then

		-- prevent this from doing anything in galactic mode
		if Get_Game_Mode() ~= "Space" then
			ScriptExit()
		end
		
		if Object.Get_Owner().Is_Human() then
			Set_Next_State("State_Human_No_Autofire")
		else
			Set_Next_State("State_AI_Autofire")
		end
	end
end

function State_AI_Autofire(message)
	if message == OnUpdate then
		if Object.Is_Ability_Ready(ability_name_1) then
			enemy = FindDeadlyEnemy(Object)
			if TestValid(enemy) then
				projectile_types = enemy.Get_All_Projectile_Types()
				for _, projectile in pairs(projectile_types) do
					if projectile.Is_Affected_By_Laser_Defense() then
						Object.Activate_Ability(ability_name, true)
						return
					end
				end
			end
		end
		if (Object.Get_Shield() < 0.1) and (Object.Get_Rate_Of_Damage_Taken() > 0.0) then
			if Object.Is_Ability_Ready(ability_name_2) then
				Object.Activate_Ability(ability_name_2, true)
			end
		end
	end		
end

function State_Human_No_Autofire(message)
	if message == OnUpdate then
		if Object.Is_Ability_Autofire(ability_name_1) and Object.Is_Ability_Autofire(ability_name_2) then
			Set_Next_State("State_Human_Autofire_12")
		else
			if Object.Is_Ability_Autofire(ability_name_1) and not Object.Is_Ability_Autofire(ability_name_2) then
				Set_Next_State("State_Human_Autofire_1")
			end
			if Object.Is_Ability_Autofire(ability_name_2) and not Object.Is_Ability_Autofire(ability_name_1) then
				Set_Next_State("State_Human_Autofire_2")
			end
		end
	end
end

function State_Human_Autofire_12(message)
	if message == OnUpdate then
		if Object.Is_Ability_Autofire(ability_name_1) then
			if Object.Is_Ability_Ready(ability_name_1) then
				enemy = FindDeadlyEnemy(Object)
				if TestValid(enemy) then
					projectile_types = enemy.Get_All_Projectile_Types()
					if projectile_types then
						for _, projectile in pairs(projectile_types) do
							if projectile.Is_Affected_By_Laser_Defense() then
								Object.Activate_Ability(ability_name, true)
								return
							end
						end
					end
				end
			end
		else
			Set_Next_State("State_Human_No_Autofire")
		end
		if Object.Is_Ability_Autofire(ability_name_2) then
			if (Object.Get_Shield() < 0.1) and (Object.Get_Rate_Of_Damage_Taken() > 0.0) then
				if Object.Is_Ability_Ready(ability_name_2) then
					Object.Activate_Ability(ability_name_2, true)
				end
			end
		else
			Set_Next_State("State_Human_No_Autofire")
		end
	end				
end

function State_Human_Autofire_1(message)
	if message == OnUpdate then
		if Object.Is_Ability_Autofire(ability_name_1) then
			if Object.Is_Ability_Ready(ability_name_1) then
				enemy = FindDeadlyEnemy(Object)
				if TestValid(enemy) then
					projectile_types = enemy.Get_All_Projectile_Types()
					if projectile_types then
						for _, projectile in pairs(projectile_types) do
							if projectile.Is_Affected_By_Laser_Defense() then
								Object.Activate_Ability(ability_name, true)
								return
							end
						end
					end
				end
			end
		else
			Set_Next_State("State_Human_No_Autofire")
		end
	end				
end

function State_Human_Autofire_2(message)
	if message == OnUpdate then
		if Object.Is_Ability_Autofire(ability_name_2) then
			if (Object.Get_Shield() < 0.1) and (Object.Get_Rate_Of_Damage_Taken() > 0.0) then
				if Object.Is_Ability_Ready(ability_name_2) then
					Object.Activate_Ability(ability_name_2, true)
				end
			end
		else
			Set_Next_State("State_Human_No_Autofire")
		end
	end				
end