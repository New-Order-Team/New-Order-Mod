require("PGStateMachine")
require("PGSpawnUnits")

function Definitions()
	ServiceRate = 1
	Define_State( "State_Init",State_Init )
end

function State_Init( message )
    if message == OnEnter then
        if Get_Game_Mode() ~= "Land" then ScriptExit() end
		owner = Object.Get_Owner()
		Create_Generic_Object("CSPL_12_Plank_Gas_Infantry", Object.Get_Position(), owner)
		Create_Generic_Object("CSPL_12_Plank_Gas_Vehicle", Object.Get_Position(), owner)
		Create_Generic_Object("CSPL_12_Plank_Gas_Structure", Object.Get_Position(), owner)
		ScriptExit()
    end
end