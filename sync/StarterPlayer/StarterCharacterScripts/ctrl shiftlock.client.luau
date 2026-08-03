--Stop disliking it put it in starterplayerscripts
local input_service = game:GetService("UserInputService")

local function LocalPlayer(): Player?
	local res = game:GetService("Players")
	
	res = res["LocalPlayer"]
	
	if not res:IsA("Player") then
		error("Local Player is not player")
	end
	
	return res
end

local controller = LocalPlayer().PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("CameraModule"):WaitForChild("MouseLockController")
local key_name: string? = nil

(function(k: string)
	key_name = k

	controller:WaitForChild("BoundKeys").Value = key_name
end)("LeftControl")


----local is_locked: boolean? = nil

--input_service.InputEnded:Connect(function(input: InputObject, gameProcessedEvent: boolean)
--	if gameProcessedEvent or key_name == nil then
--		return
--	end
	

--	if input.KeyCode.Name ~= key_name then
--		return
--	end	

--	--is_locked = nil

--	while true do
--		local locked_value = LocalPlayer().PlayerGui:FindFirstChild("__CameraLockedOnMouse", true)
--		if locked_value ~= nil then if not locked_value:IsA("BoolValue") then locked_value = nil				
--		end end
		
--		if locked_value == nil then
--			error("bool value instance not found!")
--		end
	
--		locked_value.Value = input_service.MouseBehavior == Enum.MouseBehavior.LockCenter or (function(): boolean
--			local head = script.Parent:FindFirstChild("Head")
--			if head == nil then
--				return false
--			end
			
--			if head:IsA("BasePart") then
--				return head.LocalTransparencyModifier == 1
--			end
			
--			return false
--		end)()
		
--		--is_locked = 

--		--if is_locked ~= nil then
--		--	break
--		--end
		

--		wait()
--	end
--end)