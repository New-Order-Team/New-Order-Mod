require("HeroPlanAttach")
require( "PGStateMachine" )

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	 Define_State( "State_Init",State_Init )

	-- only join plans that meet our expense requirements.
	MinPlanAttachCost = 45000
	MaxPlanAttachCost = 0

	-- Commander hit list.
	Attack_Ability_Type_Names = { "Super", "Capital", "Frigate", "Corvette", "Bomber", "Fighter" }
	Attack_Ability_Weights = { 20, 20, 20, 20, 10, 10 }
	Attack_Ability_Types = WeightedTypeList.Create()
	Attack_Ability_Types.Parse(Attack_Ability_Type_Names, Attack_Ability_Weights)

	-- Prefer task forces with these units.
	Escort_Ability_Type_Names = { "Star_Destroyer", "Victory_Destroyer", "Gladiator_Carrier", "Victory_2_Destroyer", "Star_Destroyer_2", "Star_Destroyer_3", "Super", "Capital", "Frigate", "Corvette", "Fleet_Com_Empire_Team" }
	Escort_Ability_Weights = { 200, 200, 200, 200, 200, 200, 100, 100, 150, 100, 10 }
	Escort_Ability_Types = WeightedTypeList.Create()
	Escort_Ability_Types.Parse(Escort_Ability_Type_Names, Escort_Ability_Weights)
end

function Evaluate_Attack_Ability(target, goal)
	return Get_Target_Weight(target, Attack_Ability_Types, Attack_Ability_Weights)
end

function Get_Escort_Ability_Weights(goal)
	return Escort_Ability_Types
end

function HeroService()

end

function State_Init( message )
	if message == OnEnter then
		if Get_Game_Mode() ~= "Space" then ScriptExit() end
	end

	if message == OnUpdate then
		if (Object.Get_Hull() < 0.6) and (not agr_1) then
			spawn_point = Find_First_Object("GA_Grunger")
			user_faction = Find_Player("Empire")
			Create_Generic_Object("GA_Grunger_Agressiveness", spawn_point, user_faction)
			agr_1 = true
		end
		if (Object.Get_Hull() < 0.3) and (agr_1) and (not agr_2) then
			spawn_point = Find_First_Object("GA_Grunger")
			user_faction = Find_Player("Empire")
			previous_bonus = Find_First_Object("GA_Grunger_Agressiveness")
			previous_bonus.Despawn()
			Create_Generic_Object("GA_Grunger_Agressiveness2", spawn_point, user_faction)
			agr_2 = true
		end
		if (Object.Get_Hull() < 0.01) and (agr_1) and (agr_2) then
			previous_bonus2 = Find_First_Object("GA_Grunger_Agressiveness2")
			previous_bonus2.Despawn()
		end

	end
end