local mod = Chatter:NewModule("Timestamps", "AceHook-3.0")

local date = _G.date

local SELECTED_FORMAT
local COLOR
local FORMATS = {
	["%I:%M:%S %p"] = "HH:MM:SS AM (12-hour)",
	["%I:%M:S"] = "HH:MM (12-hour)",
	["%X"] = "HH:MM:SS (24-hour)",
	["%I:%M"] = "HH:MM (12-hour)",
	["%H:%M"] = "HH:MM (24-hour)",
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
			SELECTED_FORMAT = ("[" .. v .. "]")
		end
	},
	customFormat = {
		type = "input",
		name = "Custom format (advanced)",
		desc = "Enter a custom time format. See http://www.lua.org/pil/22.1.html for a list of valid formatting symbols.",
		get = function() return mod.db.profile.customFormat end,
		set = function(info, v)
			if #v == 0 then v = nil end
			mod.db.profile.customFormat = v
			SELECTED_FORMAT = v
		end,
		order = 101		
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
		end,
		disabled = function() return mod.db.profile.colorByChannel end
	},
	useChannelColor = {
		type = "toggle",
		name = "Use channel color",
		desc = "Color timestamps the same as the channel they appear in.",
		get = function()
			return mod.db.profile.colorByChannel
		end,
		set = function(info, v)
			mod.db.profile.colorByChannel = v
		end
	}
}

function mod:OnInitialize()
	self.db = Chatter.db:RegisterNamespace("Timestamps", defaults)
end

function mod:OnEnable()
	SELECTED_FORMAT = mod.db.profile.customFormat or ("[" .. self.db.profile.format .. "]")
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
	if self.db.profile.colorByChannel then
		text = date(SELECTED_FORMAT) .. text
	else
		text = "|cff"..COLOR..date(SELECTED_FORMAT).."|r".. text
	end
	return self.hooks[frame].AddMessage(frame, text, ...)
end

function mod:Info()
	return "Adds timestamps to chat."
end

function mod:GetOptions()
	return options
end
