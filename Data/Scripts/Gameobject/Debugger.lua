-- Test script
-- Writes reports about units' health

require("PGStateMachine")

function Definitions()
	target = Find_First_Object("ISD_Test")
end

function tone()
	Game_Message("%s - %s - %s - %s", target.Get_Hull(), target.Get_Health(), target.Get_Shield(), target.Get_Energy())
	Sleep(5)
end