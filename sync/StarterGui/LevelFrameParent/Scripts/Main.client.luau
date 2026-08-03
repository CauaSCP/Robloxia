local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameFolder = ReplicatedStorage:WaitForChild("GameFolder")
local RemoteFolder = GameFolder:WaitForChild("RemoteFolder")
local InventoryFolder = GameFolder:WaitForChild("InventoryFolder")
local FrameFolder = GameFolder:WaitForChild("FrameFolder")

local Module = require(GameFolder:WaitForChild("ModuleFolder").ModuleScript)

local RemoteEvent = RemoteFolder:WaitForChild("RemoteEvent")
local FrameTemplate = FrameFolder:WaitForChild("ImageButton")

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local character = Player.Character or Player.CharacterAdded:Wait()
local PlayerInventory = Player:WaitForChild("PlayerInventory")
local PlayerEquipped = Player:WaitForChild("Equipped")

local InventoryFrame = script.Parent.Parent:WaitForChild("InventoryFrame")
local ScrollingFrame = InventoryFrame.InventoryFrame

local Class = "Chair"
local CurrentInventoryConnection = {}

local function ClearSelection()
	for _, v in ipairs(ScrollingFrame:GetChildren()) do
		if v:IsA("ImageButton") then
			local stroke = v:FindFirstChild("UIStroke")
			if stroke then
				if stroke.Enabled == true then
					stroke.Enabled = false
				end
			end
		end
	end

	ScrollingFrame.NoneButton.ImageLabel.UIStroke.Enabled = false
end

local function ClearButton()
	for _, v in ipairs(InventoryFrame.ScrollingFrame:GetChildren()) do
		if v:IsA("TextButton") then
			local stroke = v:FindFirstChild("UIStroke")
			if stroke then
				if stroke.Enabled == true then
					stroke.Enabled = false
				end
			end
		end
	end
end

local function ConnectInventoryListeners()
	-- Desconecta conexões antigas (quando trocar de Class)
	for _, conn in ipairs(CurrentInventoryConnection) do
		conn:Disconnect()
	end
	table.clear(CurrentInventoryConnection)

	local Folder = PlayerInventory:WaitForChild(Class)
	local Equip = PlayerEquipped:WaitForChild(Class)
	
	table.insert(CurrentInventoryConnection,
		Folder.ChildAdded:Connect(function()
			UpdateUI()
		end)
	)

	table.insert(CurrentInventoryConnection,
		Folder.ChildRemoved:Connect(function()
			UpdateUI()
		end)
	)
	
	Equip.Changed:Connect(function(newValue)
		ClearSelection()
		if newValue == "" or newValue == nil then
			ScrollingFrame.NoneButton.ImageLabel.UIStroke.Enabled = true
		else
			ScrollingFrame[newValue].UIStroke.Enabled = true
		end
	end)
end

local function EquippedExistsInInventory(className)
	local equipped = PlayerEquipped:WaitForChild(className).Value
	if equipped == "" then
		return true
	end

	for _, item in ipairs(PlayerInventory:WaitForChild(className):GetChildren()) do
		if item.Name == equipped then
			return true
		end
	end

	return false
end


function UpdateUI()
	-- Limpa botões antigos
	for _, v in ipairs(ScrollingFrame:GetChildren()) do
		if v:IsA("ImageButton") and v.Name ~= "NoneButton" then
			v:Destroy()
		end
	end

	local EquippedValue = PlayerEquipped:WaitForChild(Class)

	local ItemsCount = {}

	for _, v in ipairs(PlayerInventory:WaitForChild(Class):GetChildren()) do
		local name = v.Name

		if ItemsCount[name] then
			ItemsCount[name].Amount += 1
		else
			ItemsCount[name] = {
				Item = v,      -- Instance real
				Amount = 1
			}
		end
	end

	for itemName, data in pairs(ItemsCount) do
		local item = data.Item
		local amount = data.Amount
		

		local Frame = FrameTemplate:Clone()

		Module:CloneSistem(character, itemName, Class, Frame) --- Clone aqui

		Frame.Name = itemName
		if data.Amount > 1 then
				Frame.TextName.Text = "(" .. amount .. ") " .. itemName
		else
			Frame.TextName.Text = itemName
		end
		Frame.TextLabel.Text = tostring(data.Item.Value)
		Frame.Parent = ScrollingFrame

		-- Marca equipada
		if itemName == EquippedValue.Value then
			ClearSelection()
			Frame.UIStroke.Enabled = true
		end

		Frame.MouseButton1Click:Connect(function()
			local CardFrame = Module:CardSistem(character, itemName, Class, InventoryFrame)
			CardFrame.Parent = script.Parent.Parent
		end)
	end
	-- 🔎 Verifica se o item equipado ainda existe no inventário
	if not EquippedExistsInInventory(Class) then
		EquippedValue.Value = ""
		RemoteEvent:FireServer("Unequip", nil, Class)
	elseif EquippedValue.Value == "" then
		ScrollingFrame.NoneButton.ImageLabel.UIStroke.Enabled = true
	end
	
	ConnectInventoryListeners()
end

-- BOTÃO NONE
ScrollingFrame.NoneButton.MouseButton1Click:Connect(function()
	ClearSelection()
	ScrollingFrame.NoneButton.ImageLabel.UIStroke.Enabled = true
	RemoteEvent:FireServer("Unequip", nil, Class)
end)

for _, Button in ipairs(InventoryFrame.ScrollingFrame:GetChildren()) do
	if Button:IsA("TextButton") then
		Button.MouseButton1Click:Connect(function()
			Class = Button.Name
			ClearButton()
			Button.UIStroke.Enabled = true
			UpdateUI()
		end)
	end
end

UpdateUI()