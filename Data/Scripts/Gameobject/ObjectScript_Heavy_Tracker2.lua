
require("PGStateMachine")
require("PGDebug")

function Definitions()
-- Object script stuff
	user_faction = Find_Player("Rebel")
	
	rebel_commander = Find_Object_Type("SQUAD_GENERIC_FIELD_COMMANDER_REBEL")
	rebel_commander2 = Find_Object_Type("FIELD_COM_REBEL_TEAM")
	rebel_commander3 = Find_Object_Type("REBEL_FIELD_COMMANDER_TEAM")
	Define_State("State_Init", State_Init)
	Define_State("State_Has_Commander", State_Has_Commander)
end

function State_Init(message)
			Game_Message("TEXT_TOOLTIP_ABILITY_BATTLE_MEDITATION_NAME")
	if message == OnEnter then
		if Get_Game_Mode() ~= "Land" then
			ScriptExit()
		end
	end
		
	if message == OnUpdate then
		if Object.Has_Garrison() then
			lib_garrison_table = Object.Get_Garrisoned_Units()
			if table.getn(lib_garrison_table) > 0 then
				for i,garrison in pairs(lib_garrison_table) do
					if garrison.Get_Type() == rebel_commander or garrison.Get_Type() == rebel_commander2 or garrison.Get_Type() == rebel_commander3 then
						Set_Next_State("State_Has_Commander")
					end
				end
			end
		end
	end
end

function State_Has_Commander(message)
	if message == OnUpdate then
		bonus_object = Find_First_Object("Heavy_Tracker_Command_Bonus")
		if not bonus_object then
			spawn_point = Find_First_Object("Heavy_Tracker")
			Create_Generic_Object("Heavy_Tracker_Command_Bonus", spawn_point, user_faction)
		end
		if not Object.Has_Garrison() then
			commander_garrisoned = false
		end
		else
			commander_garrisoned = false
			lib_garrison_table = Object.Get_Garrisoned_Units()
			if table.getn(lib_garrison_table) > 0 then
				for i,garrison in pairs(lib_garrison_table) do
					if garrison.Get_Type() == rebel_commander or garrison.Get_Type() == rebel_commander2 or garrison.Get_Type() == rebel_commander3 then
						commander_garrisoned = true
					end
				end
			end
		end
		if commander_garrisoned == false then 
			bonus_object = Find_First_Object("Heavy_Tracker_Command_Bonus")
			bonus_object.Despawn()
			Set_Next_State("State_Init")
		end
	end
end