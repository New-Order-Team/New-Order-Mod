
require("pgevents")


function Definitions()	
	Category = "AlwaysOff"
	IgnoreTarget = true
	
	TaskForce = {
	{
		"ReserveForce"
		,"DenyHeroAttach"
		,"TaskForceRequired"
	}
	}
end

function ReserveForce_Thread()
	ScriptExit()
end