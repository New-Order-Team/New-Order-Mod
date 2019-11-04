require("HeroPlanAttach")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	-- only join plans that meet our expense requirements.
	MinPlanAttachCost = 45000
	MaxPlanAttachCost = 0

	-- Commander hit list.
	Attack_Ability_Type_Names = { "Super", "Capital", "Frigate", "Corvette", "Bomber", "Fighter" }
	Attack_Ability_Weights = { 20, 20, 20, 20, 10, 10 }
	Attack_Ability_Types = WeightedTypeList.Create()
	Attack_Ability_Types.Parse(Attack_Ability_Type_Names, Attack_Ability_Weights)

	-- Prefer task forces with these units.
	Escort_Ability_Type_Names = { "Star_Destroyer", "TIE_Defender_Squadron", "Victory_Destroyer", "Carrack_Cruiser", "Victory_2_Destroyer", "Strike_Cruiser", "Missile_Boat_Squadron", "Star_Destroyer_2", "Star_Destroyer_3", "Super", "Capital", "Frigate", "Corvette", "Fleet_Com_Empire_Team" }
	Escort_Ability_Weights = { 200, 200, 200, 200, 200, 200, 200, 200, 200, 100, 100, 150, 100, 1 }
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