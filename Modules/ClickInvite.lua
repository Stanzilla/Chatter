local mod = Chatterbox:NewModule("Invite Links", "AceHook-3.0")

local gsub = _G.string.gsub
local ipairs = _G.ipairs
local fmt = _G.string.format
local sub = _G.string.sub

function mod:OnEnable()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame" .. i]
		if cf ~= COMBATLOG then
			self:RawHook(cf, "AddMessage", true)
		end
	end
	self:RawHook(nil, "SetItemRef", true)
end

local style = "|cffffffff|Hinvite:%s|h[%s]|h|r"
local strings = {"invite", "Invite", "INVITE"}
local valid_events = {
	CHAT_MSG_SAY = true,
	CHAT_MSG_CHANNEL = true,
	CHAT_MSG_WHISPER = true,
	CHAT_MSG_OFFICER = true,
	CHAT_MSG_GUILD = true
}
function mod:AddMessage(frame, text, ...)
	if not text then 
		return self.hooks[frame].AddMessage(frame, text, ...)
	end

	if valid_events[event] and type(arg2) == "string" then
		local pt = text
		for i = 1, #strings do
			local s = strings[i]
			text = gsub(text, s, fmt(style, arg2, s))
			if text ~= pt then break end
		end
	end
		
	return self.hooks[frame].AddMessage(frame, text, ...)
end

function mod:SetItemRef(link, text, button)
	if sub(link, 1, 6) == "invite" then
		local name = sub(link, 8)
		InviteUnit(name)
		return
	end
	return self.hooks.SetItemRef(link, text, button)
end

function mod:Info()
	return "Lets you click the word 'invite' in chat to invite people to your party."
end
