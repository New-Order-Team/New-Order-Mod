--Author MaxiM--
require("PGStateMachine")

function Definitions()
    ServiceRate = 1.0

    Define_State("State_Init", State_Init);
    max_range = 820
    units_near = 0
    stealth_active = true
end

function State_Init(message)
    if message == OnEnter then
        if Get_Game_Mode() ~= "Space" then
            ScriptExit()
        end

        Register_Prox(Object, Unit_Prox, max_range)

    elseif message == OnUpdate then
        DebugMessage("%s -- units_near %s", tostring(Script), tostring(units_near))
        if stealth_active and (units_near > 0) then
            stealth_active = false
            Object.Activate_Ability("STEALTH", false)
            Object.Force_Ability_Recharge("STEALTH", 10000)
        end

        Object.Take_Damage(units_near)
        units_near = 0
    end
end

function Unit_Prox(self_obj, trigger_obj)

    if not trigger_obj.Get_Owner().Is_Enemy(Object.Get_Owner()) then
        return
    end

    if trigger_obj.Is_Category("Transport") then
        DebugMessage("%s -- trigger_obj %s units_near %s", tostring(Script), tostring(trigger_obj), tostring(units_near))
        units_near = units_near + 1
    elseif trigger_obj.Is_Category("Corvette") then
        DebugMessage("%s -- trigger_obj %s units_near %s", tostring(Script), tostring(trigger_obj), tostring(units_near))
        units_near = units_near + 1
    elseif trigger_obj.Is_Category("Frigate") then
        DebugMessage("%s -- trigger_obj %s units_near %s", tostring(Script), tostring(trigger_obj), tostring(units_near))
        units_near = units_near + 4
    elseif trigger_obj.Is_Category("Capital") then
        DebugMessage("%s -- trigger_obj %s units_near %s", tostring(Script), tostring(trigger_obj), tostring(units_near))
        units_near = units_near + 8
    elseif trigger_obj.Is_Category("Dreadnought") then
        DebugMessage("%s -- trigger_obj %s units_near %s", tostring(Script), tostring(trigger_obj), tostring(units_near))
        units_near = units_near + 64
    elseif trigger_obj.Is_Category("SpaceStructure") then
        DebugMessage("%s -- trigger_obj %s units_near %s", tostring(Script), tostring(trigger_obj), tostring(units_near))
        units_near = units_near + 64
    end
end