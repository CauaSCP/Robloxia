--!strict

local _torso: BasePart? = nil

local test_service = game:GetService("TestService")
local run_service = game:GetService("RunService")

local DynBarrierSystemModule = {}

function DynBarrierSystemModule.torso(char: Model?): BasePart
	char = char or nil
	
	if _torso == nil and char ~= nil then
		local t = char:WaitForChild("Torso")
		
		if t:IsA("BasePart") then
			_torso = t
		end
	end
	
	if _torso == nil then
		test_service:Error("cannot find torso in parsed player's character...", script)
		
		while true do
			task.wait()
		end
	elseif _torso:IsA("BasePart") then
		local res: BasePart = _torso
		
		return res
	end
end

function DynBarrierSystemModule.barrierMoving(barrier: BasePart, char: Model)
	local stop = true
	
	local __torso = DynBarrierSystemModule.torso(char)
	
	if __torso then
		
	else
		return
	end
	
	if typeof(barrier) == "Instance" then
		if barrier:IsA("BasePart") then
			stop = false
		end
	end
	
	if stop == true then
		test_service:Error("barrier argument has to be a BasePart, not: "..typeof(barrier), script, 7)
		
		return
	end

	local size_limiting: number = 1090.3350000001

	local MAX = size_limiting / 2
	local MIN = MAX * -1
	
	local oriY
	local function mov(): Vector3
		_, oriY, _ = barrier.CFrame:ToOrientation()
		
		local isX = false
		
		if oriY == nil then
			isX = true
		end
		
		if not isX then
			if not(math.abs(math.deg(oriY)) > 0.9) then
				isX = true
			end
		end
		
		if isX then
			local pos = DynBarrierSystemModule.torso().Position
			
			local clamped = 033121212 -- fixed pos
			clamped = math.clamp(clamped, clamped + MIN, clamped + MAX)
			
			return Vector3.new(clamped, pos.Y, pos.Z)
		end
		
		
	end
	
	run_service.PostSimulation:Connect(function()
		
	end)
end

return DynBarrierSystemModule
