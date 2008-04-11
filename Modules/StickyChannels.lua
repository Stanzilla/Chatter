local mod = Chatterbox:NewModule("StickyChannels")

local channels = {
	SAY = "Say",
	EMOTE = "Emote",
	YELL = "Yell",
	OFFICER = "Officer",
	RAID_WARNING = "Raid warning",
	WHISPER = "Whisper",
	CHANNEL = "Custom channels"
}
local options = {}
local defaults = {profile = {}}

function mod:OnInitialize()
	self.db = Chatterbox.db:RegisterNamespace("StickyChannels", defaults)
	for k, v in pairs(channels) do
		defaults.profile[k] = true
		options[k] = {
			type = "toggle",
			name = v,
			desc = "Make " .. v .. " sticky",
			get = function() return mod.db.profile[k] end,
			set = function(info, v)
				mod.db.profile[k] = v
				ChatTypeInfo[k].sticky = v and 1 or 0
			end
		}
	end
end

function mod:OnEnable()
	for k, v in pairs(channels) do
		ChatTypeInfo[k].sticky = self.db.profile[k]
	end
end

function mod:OnDisable()
	ChatTypeInfo.EMOTE.sticky = 0
	ChatTypeInfo.YELL.sticky = 0
	ChatTypeInfo.OFFICER.sticky = 0
	ChatTypeInfo.RAID_WARNING.sticky = 0
	ChatTypeInfo.WHISPER.sticky = 0
	ChatTypeInfo.CHANNEL.sticky = 0
end

function mod:GetOptions()
	return options
end
