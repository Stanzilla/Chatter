local mod = Chatter:NewModule("Highlights", "AceHook-3.0", "AceEvent-3.0")

local Media = LibStub("LibSharedMedia-3.0")
local sounds = {}

Media:Register("sound", "Loot Chime", [[Sound\interface\igLootCreature.wav]])
Media:Register("sound", "Whisper Ping", [[Sound\interface\iTellMessage.wav]])
Media:Register("sound", "Magic Click", [[Sound\interface\MagicClick.wav]])

local player = UnitName("player")
local defaults = {
	profile = {
		words = {
			[player] = player:lower()
		},
		sound = true,
		soundFile = nil,
		popup = true,
		customChannels = {}
	}
}

local options = {
	sound = {
		type = "toggle",
		name = "Use sound",
		desc = "Play a soundfile when one of your keywords is said.",
		get = function()
			return mod.db.profile.sound
		end,
		set = function(info, v)
			mod.db.profile.sound = v
		end
	},
	soundFile = {
		type = "select",
		name = "Sound File",
		desc = "Sound file to play",
		get = function()
			return mod.db.profile.soundFile
		end,
		set = function(info, v)
			mod.db.profile.soundFile = v
			PlaySoundFile(Media:Fetch("sound", v))
		end,
		values = sounds,
		disabled = function() return not mod.db.profile.sound end
	},
	addWord = {
		type = "input",
		name = "Add Word",
		desc = "Add word to your highlight list",
		get = function() end,
		set = function(info, v)
			mod.db.profile.words[v:lower()] = v
		end
	},
	removeWord = {
		type = "select",
		name = "Remove Word",
		desc = "Remove a word from your highlight list",
		get = function() end,
		set = function(info, v)
			mod.db.profile.words[v:lower()] = nil
		end,
		values = function() return mod.db.profile.words end,
		confirm = function(info, v) return ("Remove this word from your highlights?") end
	}	
}

function mod:OnInitialize()
	self.db = Chatter.db:RegisterNamespace("Highlight", defaults)
	Media.RegisterCallback(mod, "LibSharedMedia_Registered")
	self:AddCustomChannels(GetChannelList())
end

function mod:LibSharedMedia_Registered()
	for k, v in pairs(Media:List("sound")) do
		sounds[v] = v
	end
end

local words
function mod:OnEnable()
	words = self.db.profile.words
	self:RegisterEvent("CHAT_MSG_SAY", "ParseChat")
	
	self:RegisterEvent("CHAT_MSG_GUILD", "ParseChat")
	self:RegisterEvent("CHAT_MSG_BATTLEGROUND", "ParseChat")
	self:RegisterEvent("CHAT_MSG_BATTLEGROUND_LEADER", "ParseChat")
	self:RegisterEvent("CHAT_MSG_OFFICER", "ParseChat")
	self:RegisterEvent("CHAT_MSG_PARTY", "ParseChat")
	self:RegisterEvent("CHAT_MSG_RAID_LEADER", "ParseChat")
	self:RegisterEvent("CHAT_MSG_RAID", "ParseChat")
	self:RegisterEvent("CHAT_MSG_RAID_WARNING", "ParseChat")
	self:RegisterEvent("CHAT_MSG_SAY", "ParseChat")
	self:RegisterEvent("CHAT_MSG_WHISPER", "ParseChat")
	
	self:RegisterEvent("CHAT_MSG_CHANNEL", "ParseChat")
	self:RegisterEvent("CHAT_MSG_WHISPER", "ParseChat")
	self:RegisterEvent("CHAT_MSG_YELL", "ParseChat")
	self:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE")
	self:AddCustomChannels(GetChannelList())
	self:AddCustomChannels(
		"YELL", "Yell",
		"GUILD", "Guild", 
		"OFFICER", "Officer", 
		"RAID", "Raid", 
		"PARTY", "Party", 
		"RAID_WARNING", "Raid Warning",
		"SAY", "Say",
		"BATTLEGROUND", "Battleground",
		"BATTLEGROUND_LEADER", "Battleground",
		"WHISPER", "Whisper"
	)
end

function mod:CHAT_MSG_CHANNEL_NOTICE(evt, notice)
	self:AddCustomChannels(GetChannelList())
end

function mod:AddCustomChannels(...)
	-- excludeChannels(EnumerateServerChannels())
	for i = 1, select("#", ...), 2 do
		local id, name = select(i, ...)
		if not options[name:gsub(" ", "_")] then
			options[name:gsub(" ", "_")] = {
				type = "select",
				name = name,
				values = sounds,
				desc = "Play a sound when a message is received in this channel",
				order = type(id) == "number" and 102 or 101,
				get = function() return self.db.profile.customChannels[id] or "None" end,
				set = function(info, v)
					self.db.profile.customChannels[id] = v
					PlaySoundFile(Media:Fetch("sound", v))
				end
			}
		end
	end
end

function mod:ParseChat(evt, msg, sender, ...)
	local msg = msg:lower()
	for k, v in pairs(words) do
		if msg:find(k) then
			self:Highlight()
			return
		end
	end

	if evt == "CHAT_MSG_CHANNEL" then
		local num = select(6, ...)
		local snd = self.db.profile.customChannels[num]
		if snd then
			PlaySoundFile(Media:Fetch("sound", snd))
			return
		end
	else
		local e = evt:gsub("^CHAT_MSG_", "")
		local snd = self.db.profile.customChannels[e]
		if snd then
			PlaySoundFile(Media:Fetch("sound", snd))
			return
		end
	end
end

function mod:Highlight()
	if self.db.profile.sound then
		PlaySoundFile(Media:Fetch("sound", self.db.profile.soundFile))
	end
end

function mod:Info()
	return "Alerts you when someone says a keyword or speaks in a specified channel."
end

function mod:GetOptions()
	return options
end

