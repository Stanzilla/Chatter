local mod = Chatter:NewModule("Channel Colors", "AceEvent-3.0")
function mod:Info()
	return "Keeps your channel colors by name rather than by number."
end

local defaults = {
	profile = { colors = {} }
}

local options = {
}

function mod:OnInitialize()
	self.db = Chatter.db:RegisterNamespace("ChannelColors", defaults)
end

function mod:OnEnable()
	self:RegisterEvent("UPDATE_CHAT_COLOR")
	self:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE")
	self:AddChannels(GetChannelList())
end

function mod:AddChannels(...)
	for i = 1, select("#", ...), 2 do
		local id, name = select(i, ...)
		self.db.profile.colors[name] = self.db.profile.colors[name] or {}
		if not self.db.profile.colors[name].r then
			local r, g, b = GetMessageTypeColor("CHANNEL" .. id)
			self.db.profile.colors[name].r = r
			self.db.profile.colors[name].g = g
			self.db.profile.colors[name].b = b
		end
		if not options[name:gsub(" ", "_")] then
			options[name:gsub(" ", "_")] = {
				type = "color",
				name = name,
				desc = "Select a color for this channel",
				get = function()
					local c = self.db.profile.colors[name]
					if c then
						return c.r, c.g, c.b
					else
						return GetMessageTypeColor("CHANNEL" .. id)
					end
				end,
				set = function(info, r, g, b)
					self.db.profile.colors[name] = self.db.profile.colors[name] or {}
					self.db.profile.colors[name].r = r
					self.db.profile.colors[name].g = g
					self.db.profile.colors[name].b = b
					ChangeChatColor("CHANNEL" .. id, r, g, b);
				end
			}
		end
	end
end

function mod:CHAT_MSG_CHANNEL_NOTICE(evt, notice, _, _, fullname, _, _, channelType, channelNumber, channelName)	
	if notice == "YOU_JOINED" then
		self:AddChannels(GetChannelList())
		channelName = channelName:match("^(%w+)")
		local c = self.db.profile.colors[channelName] 
		if c then
			ChangeChatColor("CHANNEL" .. channelNumber, c.r, c.g, c.b);
		end
	end
end

function mod:UPDATE_CHAT_COLOR(evt, chan, r, g, b)
	if chan then
		local num = chan:match("(%d+)$")
		local name = select(2, GetChannelName(tonumber(num))):match("^(%w+)")
		self.db.profile.colors[name] = self.db.profile.colors[name] or {}
		self.db.profile.colors[name].r = r
		self.db.profile.colors[name].g = g
		self.db.profile.colors[name].b = b
	end
end

function mod:GetOptions()
	return options
end
