local mod = Chatterbox:NewModule("Highlights", "AceHook-3.0", "AceEvent-3.0")

local Media = LibStub("LibSharedMedia-3.0")
local sounds = {}

Media:Register("sound", "Loot Chime", [[Sound\interface\igLootCreature.wav]])
Media:Register("sound", "Whisper Ping", [[Sound\interface\iTellMessage.wav]])
Media:Register("sound", "Magic Click", [[Sound\interface\MagicClick.wav]])

local defaults = {
	profile = {
		words = {},
		sound = true,
		soundFile = nil,
		popup = true
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
	self.db = Chatterbox.db:RegisterNamespace("Highlight", defaults)
	self.db.profile.words[UnitName("player"):lower()] = UnitName("player")
	Media.RegisterCallback(mod, "LibSharedMedia_Registered")
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
	self:RegisterEvent("CHAT_MSG_CHANNEL", "ParseChat")
	self:RegisterEvent("CHAT_MSG_WHISPER", "ParseChat")
	self:RegisterEvent("CHAT_MSG_YELL", "ParseChat")
end

function mod:ParseChat(evt, msg, sender)
	local msg = msg:lower()
	for k, v in pairs(words) do
		if msg:find(k) then
			self:Highlight()
		end
	end
end

function mod:Highlight()
	if self.db.profile.sound then
		PlaySoundFile(Media:Fetch("sound", self.db.profile.soundFile))
	end
end

function mod:Info()
	return "Alerts you when someone says a keyword."
end

function mod:GetOptions()
	return options
end

