--!strict

local bak: Folder = script.FolderPointer.Value

local _old_par = bak.Parent

bak = bak:Clone()
bak.Parent = game:GetService("ServerStorage")

game.Workspace.DescendantRemoving:Connect(function(descendant)
	local old_par: Instance
	
	if _old_par ~= nil then
		old_par = _old_par
	else
		return
	end
	
	if not(descendant.Name == bak.Name or descendant:FindFirstAncestor(bak.Name)) then
		return
	end

	local function del()
		local to_delete = old_par:FindFirstChild(bak.Name)

		if to_delete == nil then
			return
		end

		to_delete:Destroy()
	end
	
	del()

	task.defer(function()
		while true do
			if old_par:FindFirstChild(bak.Name) == nil then
				break
			end
			
			del()

			task.wait()
		end
		
		local copy: Instance = bak:Clone()

		task.wait()
		copy.Parent = old_par
	end)
end)