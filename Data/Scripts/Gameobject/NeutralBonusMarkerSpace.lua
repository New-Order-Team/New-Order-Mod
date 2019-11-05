require("PGStateMachine")
require("PGSpawnUnits")

function Definitions()

	ServiceRate = 1
   
	Define_State("State_Init", State_Init);
end


function State_Init(message)
		if message == OnEnter then
			if Get_Game_Mode() ~= "Space" then ScriptExit() end
		end
		if message == OnUpdate then
			spawn_point = Object.Get_Position()
			user_faction = Find_Player("Empire")
			SBE_Object = Create_Generic_Object("Empire_Bonus_Marker_Space", spawn_point, user_faction)
			ScriptExit()
		end
end

