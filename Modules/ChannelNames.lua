local mod = Chatterbox:NewModule("ChannelNames", "AceHook-3.0")
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

local options = {}

local serverChannels = {}
local function excludeChannels(...)
	for i = 1, select("#", ...) do
		local name = select(i, ...)
		serverChannels[name] = true
	end
end

function mod:OnInitialize()
	self.db = Chatterbox.db:RegisterNamespace("ChannelNames", defaults)
	for k, _ in pairs(self.db.profile.channels) do
		options[k:gsub(" ", "_")] = {
			type = "input",
			name = k,
			desc = "Replace this channel name with...",
			get = function() return self.db.profile.channels[k] end,
			set = function(info, v)
				self.db.profile.channels[k] = v
			end
		}
	end
	self:AddCustomChannels(GetChannelList())
end

function mod:AddCustomChannels(...)
	excludeChannels(EnumerateServerChannels())
	for i = 1, select("#", ...), 2 do
		local id, name = select(i, ...)
		if not serverChannels[name] then
			options[name:gsub(" ", "_")] = {
				type = "input",
				name = name,
				desc = "Replace this channel name with...",
				order = 101,
				get = function() return self.db.profile.customChannels[GetChannelName(name)] end,
				set = function(info, v)
					self.db.profile.customChannels[GetChannelName(name)] = v
				end
			}
		end
	end
end

function mod:OnEnable()
	channels = self.db.profile.channels
	customChannels = self.db.profile.customChannels
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame" .. i]
		if cf ~= COMBATLOG then
			self:RawHook(cf, "AddMessage", true)
		end
	end
end

function mod:AddMessage(frame, text, ...)
	local oldText = text
	for k, v in pairs(channels) do
		text = gsub(text, "%[([^%]]*" .. k .. ")%]", v)
	end
	for k, v in pairs(customChannels) do
		text = gsub(text, "%[" .. k .. ".[^%]]*%]", v)
	end
	return self.hooks[frame].AddMessage(frame, text, ...)
end

function mod:GetOptions()
	return options
end
