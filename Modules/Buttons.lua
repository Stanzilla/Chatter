local mod = Chatter:NewModule("Disable Buttons", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Chatter")

mod.modName = L["Disable Buttons"]

local fmt = _G.string.format
local function hide(self)
	if not self.override then
		self:Hide()
	end
	self.override = nil
end

local options = {
	bottomButton = {
		type = "toggle",
		name = L["Show bottom when scrolled"],
		desc = L["Show bottom button when scrolled up"],
		width = "double",
		get = function()
			return mod.db.profile.scrollReminder
		end,
		set = function(info, v)
			mod.db.profile.scrollReminder = v
			if v then
				mod:EnableBottomButton()
			else
				mod:DisableBottomButton()
			end
		end
	}
}

local bottomButtons = {}

local defaults = { profile = {} }
local clickFunc = function(self) self:GetParent():ScrollToBottom() end
function mod:OnInitialize()
	self.db = Chatter.db:RegisterNamespace("Buttons", defaults)
	for i = 1, NUM_CHAT_WINDOWS do
		local f = _G["ChatFrame" .. i]
		local button = CreateFrame("Button", nil, f)
		button:SetNormalTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollEnd-Up]])
		button:SetPushedTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollEnd-Down]])
		button:SetDisabledTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollEnd-Disabled]])
		button:SetHighlightTexture([[Interface\Buttons\UI-Common-MouseHilight]])
		button:SetWidth(20)
		button:SetHeight(20)
		button:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0)
		button:SetScript("OnClick", clickFunc)
		button:Hide()
		f.downButton = button
	end
	self:SecureHook("FCF_RestorePositionAndDimensions")
end

function mod:FCF_RestorePositionAndDimensions(chatFrame)
	if Chatter.db.profile.modules[mod:GetName()] then
		chatFrame:SetClampRectInsets(0, 0, 0, 0)
	end
end

function mod:OnEnable()
	ChatFrameMenuButton:Hide()
	ChatFrameMenuButton:SetScript("OnShow", hide)
	FriendsMicroButton:Hide()
	FriendsMicroButton:SetScript("OnShow", hide)
	for i = 1, NUM_CHAT_WINDOWS do
		local f = _G["ChatFrame" .. i]
		f:SetClampRectInsets(0, 0, 0, 0)
		local ff = _G["ChatFrame" .. i .. "ButtonFrame"]
		ff:Hide()
		ff:SetScript("OnShow", hide)
	end
	if(self.db.profile.scrollReminder) then self:EnableBottomButton() end
end

function mod:OnDisable()
	ChatFrameMenuButton:Show()
	ChatFrameMenuButton:SetScript("OnShow", nil)
	FriendsMicroButton:Show()
	FriendsMicroButton:SetScript("OnShow", nil)
	self:DisableBottomButton()
	for i = 1, NUM_CHAT_WINDOWS do
		local f = _G["ChatFrame" .. i]
		f:SetClampRectInsets(-35, 35, 26, -50)
		-- Reset the postion so if the buttons were offscreen frame goes to where it should be
		if f:IsMovable() then
			FCF_RestorePositionAndDimensions(f)
		end
		local ff = _G["ChatFrame" .. i .. "ButtonFrame"]
		ff:Show()
		ff:SetScript("OnShow", nil)
	end
end

function mod:Info()
	return L["Hides the buttons attached to the chat frame"]
end

function mod:EnableBottomButton()
	if self.buttonsEnabled then return end
	self.buttonsEnabled = true
	for i = 1, NUM_CHAT_WINDOWS do
		local f = _G["ChatFrame" .. i]
		if f then
			self:Hook(f, "ScrollUp", true)
			self:Hook(f, "ScrollToTop", "ScrollUp", true)
			self:Hook(f, "PageUp", "ScrollUp", true)
						
			self:Hook(f, "ScrollDown", true)
			self:Hook(f, "ScrollToBottom", "ScrollDownForce", true)
			self:Hook(f, "PageDown", "ScrollDown", true)

			if f:GetCurrentScroll() ~= 0 then
				f.downButton:Show()
			end
			
			if f ~= COMBATLOG then
				self:Hook(f, "AddMessage", true)
			end
		end
	end
end

function mod:DisableBottomButton()
	if not self.buttonsEnabled then return end
	self.buttonsEnabled = false
	for i = 1, NUM_CHAT_WINDOWS do
		local f = _G["ChatFrame" .. i]
		if f then
			self:Unhook(f, "ScrollUp")
			self:Unhook(f, "ScrollToTop")
			self:Unhook(f, "PageUp")					
			self:Unhook(f, "ScrollDown")
			self:Unhook(f, "ScrollToBottom")
			self:Unhook(f, "PageDown")
			
			if f ~= COMBATLOG then
				self:Unhook(f, "AddMessage")
			end
			f.downButton:Hide()
		end
	end
end

function mod:ScrollUp(frame)
	frame.downButton:Show()
end

function mod:ScrollDown(frame)
	if frame:GetCurrentScroll() == 0 then
		frame.downButton:Hide()
	end
end

function mod:ScrollDownForce(frame)
	frame.downButton:Hide()
end

function mod:AddMessage(frame, text, ...)
	if frame:GetCurrentScroll() > 0 then
		frame.downButton:Show()
	else
		frame.downButton:Hide()
	end
end

function mod:GetOptions()
	return options
end
