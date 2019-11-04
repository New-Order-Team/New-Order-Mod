require("PGStateMachine")
require("PGSpawnUnits")

function Definitions()

	ServiceRate = 1
	
	Define_State( "State_Init",State_Init )
	
	Grant_Screed_Grudge_Flag = 0
	Grant_Tarkin_Grudge_Flag = 0
	Grant_Daala_Grudge_Flag = 0
	Grant_Motti_Grudge_Flag = 0
end

function State_Init(message)
	if message == OnEnter then
		if Get_Game_Mode() ~= "Space" then ScriptExit() end
		Register_Timer(SetPhase2,10)
	end

	if message == OnUpdate then
		spawn_point = Object.Get_Position()
		user_faction = Find_Player("Empire")
		if TestValid(Find_First_Object("Arlionne_SD")) or TestValid(Find_First_Object("Demolisher_SD")) then
			if Grant_Screed_Grudge_Flag == 0 then
				Grant_Screed_Grudge_Object = Create_Generic_Object("Grant_Screed_Grudge", spawn_point, user_faction)
				Grant_Screed_Grudge_Flag = 1
			end
		else
			if Grant_Screed_Grudge_Flag == 1 then
				Grant_Screed_Grudge_Object.Despawn()
				Grant_Screed_Grudge_Flag = 0
			end
		end
		if TestValid(Find_First_Object("Executrix_SD")) then
			if Grant_Tarkin_Grudge_Flag == 0 then
				Grant_Tarkin_Grudge_Object = Create_Generic_Object("Grant_Tarkin_Grudge", spawn_point, user_faction)
				Grant_Tarkin_Grudge_Flag = 1
			end
		else
			if Grant_Tarkin_Grudge_Flag == 1 then
				Grant_Tarkin_Grudge_Object.Despawn()
				Grant_Tarkin_Grudge_Flag = 0
			end
		end
		if TestValid(Find_First_Object("Gorgon_SD")) then
			if Grant_Daala_Grudge_Flag == 0 then
				Grant_Daala_Grudge_Object = Create_Generic_Object("Grant_Daala_Grudge", spawn_point, user_faction)
				Grant_Daala_Grudge_Flag = 1
			end
		else
			if Grant_Daala_Grudge_Flag == 1 then
				Grant_Daala_Grudge_Object.Despawn()
				Grant_Daala_Grudge_Flag = 0
			end
		end
		if TestValid(Find_First_Object("Steel_Talon_SD")) then
			if Grant_Motti_Grudge_Flag == 0 then
				Grant_Motti_Grudge_Object = Create_Generic_Object("Grant_Motti_Grudge", spawn_point, user_faction)
				Grant_Motti_Grudge_Flag = 1
			end
		else
			if Grant_Motti_Grudge_Flag == 1 then
				Grant_Motti_Grudge_Object.Despawn()
				Grant_Motti_Grudge_Flag = 0
			end
		end
	end
	end
end