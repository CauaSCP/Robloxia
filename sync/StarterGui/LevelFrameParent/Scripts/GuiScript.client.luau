local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Event = ReplicatedStorage.GameFolder.RemoteFolder:WaitForChild("RemoteEvent")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Gui = script.Parent.Parent
local SongFolder = Gui.SongFolder

-- Lista ordenada: cada índice representa um par (Button[i] -> Frame[i])
local Frames = {
	Gui.InventoryFrame,
	Gui.ShopFrame,
	Gui.SendTradesFrame,
}

local Buttons = {
	Gui.Frame.InventoryButton,
	Gui.Frame.ShopButton,
	Gui.Frame.TradeButton,
}

-- Função: Esconde todos os frames
local function HideAllFrames()
	for _, frame in pairs(Frames) do
		if frame.Visible then
			frame.Visible = false
		end
	end
end

-- Função: Mostra um frame
local function ShowFrame(frame)
	frame.Visible = true
end

-- 🔁 Conecta cada botão ao seu respectivo frame
for i, button in ipairs(Buttons) do
	button.MouseButton1Click:Connect(function()
		if Gui.TradeFrame.Visible then return end
		if not Gui:FindFirstChild("CardFrame") then
			local frame = Frames[i]
			if frame then
				if frame.Visible then
					HideAllFrames()
				else
					HideAllFrames()
					ShowFrame(frame)
				end
			end
		end
	end)
end

for i, frame in ipairs(Frames) do
	local closeButton = frame:WaitForChild("CloseButton")
	closeButton.MouseButton1Click:Connect(function()
		if frame.Visible then
			HideAllFrames()
		end
	end)
end

local function formatNumber(n)
	n = math.floor(n)
	local formatted = tostring(n)

	local k = nil

	while true do
		formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", "%1.%2")
		if k == 0 then
			break
		end
	end

	return formatted
end

local function CoinAnm(Value)
	local Text = ReplicatedStorage:WaitForChild("GameFolder").FrameFolder.TextLabel:Clone()
	Text.Text = "$"..formatNumber(Value)
	Text.Parent = Gui

	SongFolder.MoneyCollect:Play()

	local randomX = math.random(0, 1000) / 1000
	Text.Position = UDim2.new(randomX, 0, 1, 0)

	local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local goal = {
		Position = Text.Position - UDim2.new(0, 0, math.random(50, 90) / 100, 0)
	}

	local tween = TweenService:Create(Text, tweenInfo, goal)
	tween:Play()

	tween.Completed:Connect(function()
		Text:Destroy()
	end)
end

Event.OnClientEvent:Connect(function(Msg, Value)
	if Msg == "SellGui" then
		CoinAnm(Value)
	end
end)

task.wait(15)
game:GetService("AvatarEditorService"):PromptSetFavorite(game.PlaceId,Enum.AvatarItemType.Asset,true)