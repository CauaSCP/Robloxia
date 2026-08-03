local input_service = game:GetService("UserInputService")
local storage = game:GetService("ReplicatedStorage")

local messaging = game:GetService("TestService")

local function inp(input: InputObject, processed: boolean, key_is_down: boolean)
	if processed then
		return
	end
	
	storage.RunButtonPressed:FireServer(input.KeyCode, key_is_down)
end

while true do
	local conn = nil
	conn = input_service.InputEnded:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		inp(input, gameProcessedEvent, false)
	end)
	
	if conn ~= nil then
		input_service.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
			inp(input, gameProcessedEvent, true)
		end)
		
		break
	end
	
	wait()
end