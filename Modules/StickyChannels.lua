local mod = Chatterbox:NewModule("StickyChannels")

function mod:OnEnable()
	ChatTypeInfo.SAY.sticky = 1
	ChatTypeInfo.EMOTE.sticky = 1
	ChatTypeInfo.YELL.sticky = 1
	ChatTypeInfo.OFFICER.sticky = 1
	ChatTypeInfo.RAID_WARNING.sticky = 1
	ChatTypeInfo.WHISPER.sticky = 1
	ChatTypeInfo.CHANNEL.sticky = 1
end

function mod:OnDisable()
	ChatTypeInfo.EMOTE.sticky = 0
	ChatTypeInfo.YELL.sticky = 0
	ChatTypeInfo.OFFICER.sticky = 0
	ChatTypeInfo.RAID_WARNING.sticky = 0
	ChatTypeInfo.WHISPER.sticky = 0
	ChatTypeInfo.CHANNEL.sticky = 0
end
