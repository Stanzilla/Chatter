local mod = Chatter:NewModule("Channel Names", "AceHook-3.0", "AceEvent-3.0")

local gsub = _G.string.gsub
local find = _G.string.find
local pairs = _G.pairs

local defaults = {
	profile = {
		channels = {
			Guild = "[G]",
			Party = "[P]",
			Raid = "[R]",
			["Raid Leader"] = "[RL]",
			["Raid Warning"] = "[RW]",
			Officer = "[O]",
			LookingForGroup = "[LFG]",
			Battleground = "[BG]",
			["Battleground Leader"] = "[BL]"	
		},
		customChannels = {}
	}
}

local channels, customChannels

local options = {
	splitter = {
		type = "header",
		name = "Custom Channels"
	}
}

local serverChannels = {}
local function excludeChannels(...)
	for i = 1, select("#", ...) do
		local name = select(i, ...)
		serverChannels[name] = true
	end
end

function mod:OnInitialize()
	self.db = Chatter.db:RegisterNamespace("ChannelNames", defaults)
	for k, _ in pairs(self.db.profile.channels) do
		options[k:gsub(" ", "_")] = {
			type = "input",
			name = k,
			desc = "Replace this channel name with...",
			order = 98,
			get = function()
				local v = self.db.profile.channels[k]
				return v == "" and " " or v
			end,
			set = function(info, v)
				self.db.profile.channels[k] = #v > 0 and v or nil
			end
		}
	end
	self:AddCustomChannels(GetChannelList())
end

function mod:AddCustomChannels(...)
	-- excludeChannels(EnumerateServerChannels())
	for i = 1, select("#", ...), 2 do
		local id, name = select(i, ...)
		if not serverChannels[name] and not options[name:gsub(" ", "_")] then
			options[name:gsub(" ", "_")] = {
				type = "input",
				name = name,
				desc = "Replace this channel name with...",
				order = id <= 4 and 98 or 101,
				get = function()
					local v = self.db.profile.customChannels[id]
					return v == "" and " " or v
				end,
				set = function(info, v)
					self.db.profile.customChannels[id] = #v > 0 and v or nil
				end
			}
		end
	end
end

function mod:OnEnable()
	channels = self.db.profile.channels
	customChannels = self.db.profile.customChannels
	self:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE")
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame" .. i]
		if cf ~= COMBATLOG then
			self:RawHook(cf, "AddMessage", true)
		end
	end
end

function mod:CHAT_MSG_CHANNEL_NOTICE()
	self:AddCustomChannels(GetChannelList())
end

function mod:AddMessage(frame, text, ...)
	if not text then 
		return self.hooks[frame].AddMessage(frame, text, ...)
	end

	local oldText = text
	for k, v in pairs(channels) do
		text = gsub(text, "%[([^%]]*" .. k .. ")%] ", v == " " and "" or v .. " ")
	end
	for k, v in pairs(customChannels) do
		text = gsub(text, "%[" .. k .. "%.[^%]]*%] ", v == " " and "" or v .. " ")
	end
	return self.hooks[frame].AddMessage(frame, text, ...)
end

function mod:GetOptions()
	return options
end

function mod:Info()
	return "Enables you to replace channel names with your own names"
end
