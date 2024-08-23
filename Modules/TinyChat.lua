local addon, private = ...
local Chatter = LibStub("AceAddon-3.0"):GetAddon(addon)
local mod = Chatter:NewModule("Tiny Chat")
local L = LibStub("AceLocale-3.0"):GetLocale(addon)

mod.modName = L["Tiny Chat"]
mod.toggleLabel = L["Tiny Chat"]

function mod:Info()
	return L["Allows you to make the chat frames much smaller than usual."]
end

function mod:Decorate(frame)
	frame:SetResizeBounds(50, 20, 5000, 5000)
end

function mod:OnEnable()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame" .. i]
		cf:SetResizeBounds(50, 20, 5000, 5000)
	end
	for index,name in ipairs(self.TempChatFrames) do
		local cf = _G[name]
		if cf then
			cf:SetResizeBounds(50, 20, 5000, 5000)
		end
	end
end

function mod:OnDisable()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame" .. i]
		cf:SetResizeBounds(296, 75, 608, 400)
	end
	for index,name in ipairs(self.TempChatFrames) do
		local cf = _G[name]
		if cf then
			cf:SetResizeBounds(296, 75, 608, 400)
		end
	end
end
