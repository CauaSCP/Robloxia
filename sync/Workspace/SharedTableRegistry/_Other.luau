local http = game:GetService("HttpService")
local messaging = game:GetService("TestService")

local _link: {string|(() -> string)} = {""}
_link[1] = function(fmt: string)
	_link[0] = "http://setup.roproxy.com/"..fmt.."-API-Dump.json"
end
local ver = nil

local module = function()
	local api_data

	local json_text: string|nil = nil

	task.spawn(function()
		repeat
			task.wait()
		until ver ~= nil

		ver = tostring(ver)

		_link[1](ver)

		task.wait()

		_link[0] = tostring(_link[0])

		pcall(function()
			json_text = http:GetAsync(_link[0])
		end)
	end)

	task.spawn(function()
		pcall(function()
			ver = http:GetAsync("http://setup.roproxy.com/versionQTStudio")
		end)
	end)

	task.spawn(function()
		repeat
			task.wait()
		until json_text ~= nil

		task.wait()

		api_data = http:JSONDecode(json_text)
	end)

	local stop = false

	while true do
		if stop then
			break
		end

		pcall(function()
			if type(api_data) == "table" then
				stop = true
			end
		end)

		wait()
	end

	return api_data
end

return module
