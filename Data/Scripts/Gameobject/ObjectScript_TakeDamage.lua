require("PGSpawnUnits")
require("PGStateMachine")

function Definitions()
    ServiceRate = 1.0
    Define_State("State_Init", State_Init);
end

function State_Init(message)
    if message == OnEnter then
        if Get_Game_Mode() ~= "Space" then
            ScriptExit()
        end

        name = Object.Get_Type().Get_Name()

    elseif message == OnUpdate then
		Sleep(1)
        Object.Take_Damage(999)
    end
end
