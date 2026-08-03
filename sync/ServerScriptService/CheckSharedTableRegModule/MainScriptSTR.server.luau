local bak: Instance? = script.ModulePointer.Value;

(function()
	if bak == nil then
		return
	end
	
	local old_par = bak.Parent
	
	if old_par == nil then
		break
	end

	local bak_parent: Instance = bak.Parent

	bak = bak:Clone()
	bak.Parent = game:GetService("ServerStorage")

	game.Workspace.DescendantRemoving:Connect(function(descendant)
		if not(descendant.Name == bak.Name or descendant:FindFirstAncestor(bak.Name)) then
			return
		end

		local function del()
			if old_par ~= nil then
				local to_delete = old_par:FindFirstChild(bak.Name)

				if to_delete == nil then
					return
				end

				to_delete:Destroy()
			end

		end

		del()

		task.defer(function()
			while true do
				if old_par:FindFirstChild(bak.Name) == nil then
					break
				end
			end
			
			local copy: Instance = bak:Clone()

			task.wait()
			copy.Parent = bak_parent
		end)
	end)
end)()
