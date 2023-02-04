
require("pgevents")

-- Tell the script pooling system to pre-cache this number of scripts.
ScriptPoolCount = 0

function Definitions()
	
	Category = "AlwaysOff"
	TaskForce = {
	{
		"DeathStarForce"
		,"TaskForceRequired"
		-- ,"Frigate | Capital | Corvette | Bomber | Fighter | Super = 100%"
	}
	}

end

function DeathStarForce_Thread()
	ScriptExit()
end
