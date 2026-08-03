local players = game:GetService("Players")

local Call = function()
	assert(players.LocalPlayer ~= nil, "calling from a non localscript!")
	return script.Parent:Invoke()
end

return Call
