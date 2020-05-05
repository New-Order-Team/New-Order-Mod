require("PGStateMachine")
require("PGSpawnUnits")

function Definitions()
	ServiceRate = 1
	Define_State( "State_Init",State_Init )
end

function State_Init( message )
    if message == OnEnter then
        if Get_Game_Mode() ~= "Land" then ScriptExit() end
		empire = Find_Player("Empire")
		Create_Generic_Object("CSPL_12_Plank_Gas_Vehicle", Object.Get_Position(), empire)
		ScriptExit()
    end
end