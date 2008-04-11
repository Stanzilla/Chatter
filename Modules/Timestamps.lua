local mod = Chatterbox:NewModule("Timestamps", "AceHook-3.0")

local SELECTED_FORMAT
local COLOR
local FORMATS = {
	["%I:%M:%S %p"] = "HH:MM:SS AM (12-hour clock)",
	["%X"] = "HH:MM:SS (24-hour clock)",
	["%I:%M"] = "HH:MM (12-hour clock)",
	["%H:%M"] = "HH:MM (24-hour clock)",
	["%M:%S"] = "MM:SS",
}

local defaults = {
	profile = { format = "%X", color = { r = 0.45, g = 0.45, b = 0.45 } }
}

local options = {
	format = {
		type = "select",
		name = "Timestamp format",
		desc = "Timestamp format",
		values = FORMATS,
		get = function() return mod.db.profile.format end,
		set = function(info, v)
			mod.db.profile.format = v
			SELECTED_FORMAT = v
		end
	},
	color = {
		type = "color",
		name = "Timestamp color",
		desc = "Timestamp color",
		get = function()
			local c = mod.db.profile.color
			return c.r, c.g, c.b
		end,
		set = function(info, r, g, b, a)
			local c = mod.db.profile.color
			c.r, c.g, c.b = r, g, b
			COLOR = ("%02x%02x%02x"):format(r * 255, g * 255, b * 255)
		end	
	}
}

function mod:OnInitialize()
	self.db = Chatterbox.db:RegisterNamespace("Timestamps", defaults)
end

function mod:OnEnable()
	SELECTED_FORMAT = self.db.profile.format
	local c = self.db.profile.color	
	COLOR = ("%02x%02x%02x"):format(c.r * 255, c.g * 255, c.b * 255)
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame" .. i]
		if cf ~= COMBATLOG then
			self:RawHook(cf, "AddMessage", true)
		end
	end
end

function mod:AddMessage(frame, text, ...)
	if not text then 
		return self.hooks[frame].AddMessage(frame, text, ...)
	end
	text = "|cff"..COLOR.."["..date(SELECTED_FORMAT).."]|r "..text
	return self.hooks[frame].AddMessage(frame, text, ...)
end

function mod:Info()
	return "Adds timestamps to chat."
end

function mod:GetOptions()
	return options
end
