local mod = Chatter:NewModule("Invite Links", "AceHook-3.0")

local gsub = _G.string.gsub
local ipairs = _G.ipairs
local fmt = _G.string.format
local sub = _G.string.sub

local options = {
	addWord = {
		type = "input",
		name = "Add Word",
		desc = "Add word to your invite trigger list",
		get = function() end,
		set = function(info, v)
			mod.db.profile.words[v:lower()] = v
		end
	},
	removeWord = {
		type = "select",
		name = "Remove Word",
		desc = "Remove a word from your invite trigger list",
		get = function() end,
		set = function(info, v)
			mod.db.profile.words[v:lower()] = nil
		end,
		values = function() return mod.db.profile.words end,
		confirm = function(info, v) return ("Remove this word from your trigger list?") end
	}
}

local defaults = {
	profile = {
		words = {}
	}
}

local words

function mod:OnInitialize()
	self.db = Chatter.db:RegisterNamespace(self:GetName(), defaults)
end

function mod:OnEnable()
	words = self.db.profile.words
	if not next(words) then
		words["invite"] = "invite"
		words["inv"] = "inv"
	end
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

function addLinks(t)
	if words[t:lower()] then
		t = fmt(style, arg2, t)
	end
	return t
end

function mod:AddMessage(frame, text, ...)
	if not text then 
		return self.hooks[frame].AddMessage(frame, text, ...)
	end

	if valid_events[event] and type(arg2) == "string" then
		text = gsub(text, "%w+", addLinks)
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

function mod:GetOptions()
	return options
end
