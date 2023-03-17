require("PGStateMachine")
require("PGSpawnUnits")

function Definitions()

	ServiceRate = 1
	
	Define_State( "State_Init",State_Init )
end

function State_Init( message )
    if message == OnEnter then
        if Get_Game_Mode() ~= "Space" then ScriptExit() end
    end

    if message == OnUpdate then
        if Object.Is_Ability_Active( "STIM_PACK" ) then
			user_faction = Find_Player("Empire")
			enemy_faction = Find_Player("Rebel")
			spawn_point = Find_First_Object("Recondite_SD")
			Create_Generic_Object("Declann_Meditation", spawn_point, enemy_faction)
			Create_Generic_Object("Declann_Meditation_Friendly", spawn_point, user_faction)
			Sleep( 5.0 )
			Game_Message("TEXT_TOOLTIP_ABILITY_BATTLE_MEDITATION_NAME")
			Sleep( 15.0 )
			teezl_object = Find_First_Object("Declann_Meditation")
			teezl_object.Despawn()
			teezl_friendly_object = Find_First_Object("Declann_Meditation_Friendly")
			teezl_friendly_object.Despawn()
			Game_Message("TEXT_TOOLTIP_ABILITY_BATTLE_MEDITATION_NAME")
        end
    end
end