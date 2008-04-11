local Buttons = Chatterbox:NewModule("Buttons")
local fmt = _G.string.format
local function hide(self)
	self:Hide()
end

function Buttons:OnEnable()
	ChatFrameMenuButton:Hide()
	local upButton, downButton, bottomButton
	for i = 1, NUM_CHAT_WINDOWS do
		upButton = _G[fmt("%s%d%s", "ChatFrame", i, "UpButton")]
		upButton:SetScript("OnShow", hide)
		upButton:Hide()
		downButton = _G[fmt("%s%d%s", "ChatFrame", i, "DownButton")]
		downButton:SetScript("OnShow", hide)
		downButton:Hide()
		bottomButton = _G[fmt("%s%d%s", "ChatFrame", i, "BottomButton")]
		bottomButton:SetScript("OnShow", hide)
		bottomButton:Hide()
	end
end

function Buttons:OnDisable()
	ChatFrameMenuButton:Show()
	local upButton, downButton, bottomButton
	for i = 1, NUM_CHAT_WINDOWS do
		upButton = _G[fmt("%s%d%s", "ChatFrame", i, "UpButton")]
		upButton:SetScript("OnShow", nil)
		upButton:Show()
		downButton = _G[fmt("%s%d%s", "ChatFrame", i, "DownButton")]
		downButton:SetScript("OnShow", nil)
		downButton:Show()
		bottomButton = _G[fmt("%s%d%s", "ChatFrame", i, "BottomButton")]
		bottomButton:SetScript("OnShow", nil)
		bottomButton:Show()
	end
end
