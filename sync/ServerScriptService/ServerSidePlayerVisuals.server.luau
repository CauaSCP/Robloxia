local client_call = game.Workspace.ClientModules.VisualsForPlayerModule.CallingClient
local function coreGuiParsed(player: Player)
    client_call:InvokeClient(player)
end

game:GetService("Players").PlayerAdded:Connect(function(player)
    coreGuiParsed(player)

    print(`{player.Name} joined..`)
end)