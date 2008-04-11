local mod = Chatterbox:NewModule("PlayerNames", "AceHook-3.0", "AceEvent-3.0")
local gsub = _G.string.gsub
local find = _G.string.find
local pairs = _G.pairs

local defaults = {
	realm = {
		names = {}
	}
}

local names = setmetatable({}, {
	__index = function(t, v)
		local c = RAID_CLASS_COLORS[mod.db.realm.names[v]]
		if c then
			t[v] = ("|cff%02x%02x%02x%s|r"):format(c.r * 255, c.g * 255, c.b * 255, v)
		else
			t[v] = string.format("|cffa0a0a0%s|r", v)
		end
		return t[v]
	end
})

function mod:OnInitialize()
	self.db = Chatterbox.db:RegisterNamespace("PlayerNames", defaults)
end

function mod:OnEnable()
	self:RegisterEvent("RAID_ROSTER_UPDATE")
	self:RegisterEvent("PARTY_MEMBERS_CHANGED")
	self:RegisterEvent("WHO_LIST_UPDATE")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("CHAT_MSG_SYSTEM")
	self:RegisterEvent("FRIENDLIST_UPDATE")
	self:RegisterEvent("GUILD_ROSTER_UPDATE")

	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame" .. i]
		if cf ~= COMBATLOG then
			self:RawHook(cf, "AddMessage", true)
		end
	end
end

function mod:AddPlayer(name, class)
	if name and class and class ~= "UNKNOWN" then
		self.db.realm.names[name] = class
		names[name] = nil
	end
end

function mod:FRIENDLIST_UPDATE(evt)
	for i = 1, GetNumFriends() do
		local name, _, class = GetFriendInfo(i)
		self:AddPlayer(name, class:upper())
	end
end

function mod:GUILD_ROSTER_UPDATE(evt)
	local n = GetNumGuildMembers()
	if not n or n == 0 then
		return
	end
	self:UnregisterEvent("GUILD_ROSTER_UPDATE")
	local offline = GetGuildRosterShowOffline()
	local selection = GetGuildRosterSelection()
	SetGuildRosterShowOffline(true)
	SetGuildRosterSelection(0)
	GetGuildRosterInfo(0)
	n = GetNumGuildMembers()
	for i = 1, n do
		local name, _, _, _, _, _, _, _, _, _, class = GetGuildRosterInfo(i)
		self:AddPlayer(name, class)
	end
	SetGuildRosterShowOffline(offline)
	SetGuildRosterSelection(selection)
end


function mod:RAID_ROSTER_UPDATE(evt)
	for i = 1, GetNumRaidMembers() do
		local n = GetRaidRosterInfo(i)
		local _, c = UnitClass(n)
		self:AddPlayer(n, c)
	end
end

function mod:PARTY_MEMBERS_CHANGED(evt)
	for i = 1, GetNumPartyMembers() do
		local n = UnitName("party" .. i)
		local _, c = UnitClass("party" .. i)
		self:AddPlayer(n, c)
	end
end

function mod:PLAYER_TARGET_CHANGED(evt)
	if not UnitExists("target") or not UnitIsPlayer("target") or not UnitIsFriend("player", "target") then return end
	local _, cls = UnitClass("target")
	self:AddPlayer(UnitName("target"), cls)
end

function mod:UPDATE_MOUSEOVER_UNIT(evt)
	if not UnitExists("mouseover") or not UnitIsPlayer("mouseover") or not UnitIsFriend("player", "mouseover") then return end
	local _, cls = UnitClass("mouseover")
	self:AddPlayer(UnitName("mouseover"), cls)
end

function mod:CHAT_MSG_SYSTEM(evt, msg)
	local name, class = select(3, msg:find("^|Hplayer:%w+|h%[(%w+)%]|h: Level %d+ %w+ (%w+)"))
	if name and class then
		self:AddPlayer(name, class:upper())
	end
end

function mod:WHO_LIST_UPDATE(evt)
	for i = 1, GetNumWhoResults() do
		local name, _, _, _, class = GetWhoInfo(i)
		self:AddPlayer(name, class:upper())
	end
end

function mod:AddMessage(frame, text, ...)
	local name = arg2
	if event == "CHAT_MSG_SYSTEM" then name = select(3, text:find("|h%[(.+)%]|h")) end
	if name then text = text:gsub("|h%["..name.."%]|h", "|h[".. names[name].."]|h") end
	return self.hooks[frame].AddMessage(frame, text, ...)
end

function mod:Info()
	return "Colors player names according to their class."
end
