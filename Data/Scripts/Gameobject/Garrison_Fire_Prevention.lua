require("PGStateMachine")

function Definitions()
    Define_State("State_Init", State_Init);
end

function State_Init(message)
    if message == OnEnter then
        if Get_Game_Mode() ~= "Land" then
            ScriptExit()
        end

        old_garrisoned_units = {}

    elseif message == OnUpdate then
        transport_units = Find_All_Objects_Of_Type("CanContainGarrison")
        garrisoned_units = {}

        for _,transport in pairs(transport_units) do
            if not transport.Has_Property("GarrisonCanFire") then
                garrison_table = transport.Get_Garrisoned_Units()
                if table.getn(garrison_table) > 0 then
                    for _,unit in pairs(garrison_table) do
                        table.insert(garrisoned_units, unit)
                    end
                end
            end
        end

        for _,garrisoned_unit in pairs(garrisoned_units) do
            if not Is_In_Table(garrisoned_unit, old_garrisoned_units) then
                if garrisoned_unit.Prevent_All_Fire ~= nil then
                    DebugMessage("%s -- Deactivating fire on garrisoned unit %s successful", tostring(Script), tostring(garrisoned_unit))
                    garrisoned_unit.Prevent_All_Fire(true)

                    if Contained_Object_Count(garrisoned_unit) > 0 then
                        local child_objects = Get_Child_Objects(garrisoned_unit, garrisoned_unit.Get_Owner(), "Infantry")
                        for _,child_object in pairs(child_objects) do
                            DebugMessage("%s -- Deactivating fire on contained unit %s", tostring(Script), tostring(child_object))
                            if child_object.Prevent_All_Fire ~= nil then
                                child_object.Prevent_All_Fire(true)
                            end
                        end
                    end
                end
            end
        end

        for _,old_garrisoned_unit in pairs(old_garrisoned_units) do
            DebugMessage("%s -- Checking, if %s is still garrisoned", tostring(Script), tostring(old_garrisoned_unit))
            if not Is_In_Table(old_garrisoned_unit, garrisoned_units) then
                if old_garrisoned_unit.Prevent_All_Fire ~= nil then
                    DebugMessage("%s -- Enabling fire on garrisoned unit %s successful", tostring(Script), tostring(old_garrisoned_unit))
                    old_garrisoned_unit.Prevent_All_Fire(false)

                    if old_garrisoned_unit.Get_Contained_Object_Count ~= nil and old_garrisoned_unit.Get_Contained_Object_Count() > 0 then
                        local child_objects = Get_Child_Objects(old_garrisoned_unit, old_garrisoned_unit.Get_Owner(), "Infantry")
                        for _,child_object in pairs(child_objects) do
                            DebugMessage("%s -- Enabling fire on contained unit %s", tostring(Script), tostring(child_object))
                            if child_object.Prevent_All_Fire ~= nil then
                                child_object.Prevent_All_Fire(false)
                            end
                        end
                    end
                end
            end
        end

        old_garrisoned_units = garrisoned_units
    end
end

function Is_In_Table(object, table)
    for _, table_object in pairs(table) do
        if table_object == object then
            return true
        end
    end
    return false
end

function Get_Child_Objects(parent, player, categories)
    local possible_units
    local child_objects = {}
    if categories ~= nil then
        possible_units = Find_All_Objects_Of_Type(player, categories)
    else
        possible_units = Find_All_Objects_Of_Type(player)
    end

    for _,possible_unit in pairs(possible_units) do
        if TestValid(possible_unit) and possible_unit.Get_Parent_Object ~= nil then
            if possible_unit.Get_Parent_Object() == parent then
                table.insert(child_objects, possible_unit)
            end
        end
    end

    return child_objects
end

function Contained_Object_Count(thing)
    count = 0
    if thing ~= nil and thing.Get_Contained_Object_Count ~= nil then
        count = thing.Get_Contained_Object_Count()
    end
    return count
end
