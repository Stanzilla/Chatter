local mod = Chatter:NewModule("Scrollback")
local L = LibStub("AceLocale-3.0"):GetLocale("Chatter")
mod.modName = L["Scrollback"]
mod.toggleLabel = L["Enable Scrollback length modification"]

local defaults = {
	profile = {}
}

local options = {}
function mod:OnInitialize()
	self.db = Chatter.db:RegisterNamespace("Scrollback", defaults)
	for i = 1, NUM_CHAT_WINDOWS do
		local s = "FRAME_" .. i
		local f = _G["ChatFrame" .. i]
		options[s] = {
			type = "range",
			name = L["Chat Frame "] .. i,
			desc = L["Chat Frame "] .. i,
			min = 250,
			max = 2500,
			step = 10,
			get = function() return self.db.profile[s] or 250 end,
			set = function(info, v)
				self.db.profile[s] = v
				f:SetMaxLines(v)
			end
		}
	end
end

function mod:OnEnable()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame" .. i]
		cf:SetMaxLines(self.db.profile["FRAME_" .. i] or 250)
	end
end

function mod:OnDisable()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame" .. i]
		cf:SetMaxLines(250)
	end
end

function mod:GetOptions()
	return options
end

function mod:Info()
	return "Lets you set the scrollback length of your chat frames."
end
