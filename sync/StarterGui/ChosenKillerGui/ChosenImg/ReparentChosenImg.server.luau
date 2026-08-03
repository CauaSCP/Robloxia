local players = game:GetService("Players")


if #(players:GetPlayers()) > 1 then
	for _, player in ipairs(players:GetPlayers()) do
		player:Kick("img error")
	end
end

script.Parent.Parent = script.ParentVal.Value

if script.Parent.Parent ~= nil and script.Parent.Parent == script.ParentVal.Value then
	script:Destroy()
end