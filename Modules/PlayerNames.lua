local mod = Chatter:NewModule("Player Class Colors", "AceHook-3.0", "AceEvent-3.0")
mod.modName = "Player Names"

local L = LibStub("AceLocale-3.0"):GetLocale("Chatter")
local local_names, local_levels = {}, {}

local gsub = _G.string.gsub
local find = _G.string.find
local pairs = _G.pairs
local lookup = {}
local classes = {"Druid", "Mage", "Paladin", "Priest", "Rogue", "Hunter", "Shaman", "Warlock", "Warrior"}

local defaults = {
	realm = {
		names = {},
		levels = {},
	},
	profile = {	saveData = false }
}

local names = setmetatable({}, {
	__index = function(t, v)
		local tab = (mod.db.profile.saveData and mod.db.realm.names[v]) or local_names[v]
		local class, level
		if tab then
			class = tab.class
			level = mod.db.profile.includeLevel and tab.level or nil
		end
		local c = RAID_CLASS_COLORS[class]
		if c then
			if level then
				t[v] = ("|cff%02x%02x%02x%s:%s|r"):format(c.r * 255, c.g * 255, c.b * 255, v, level)
			else
				t[v] = ("|cff%02x%02x%02x%s|r"):format(c.r * 255, c.g * 255, c.b * 255, v)
			end
		else
			if level then
				t[v] = string.format("|cffa0a0a0%s:%s|r", v, level)
			else
				t[v] = string.format("|cffa0a0a0%s|r", v)
			end
		end
		return t[v]
	end
})

local options = {
	save = {
		type = "toggle",
		name = "Save data",
		desc = "Save class data between sessions. Will increase memory usage.",
		get = function()
			return mod.db.profile.saveData
		end,
		set = function(info, v)
			mod.db.profile.saveData = v
			if v then
				for k, v in pairs(local_names) do
					mod.db.realm.names[k] = v
					local_names[k] = nil
				end
			else
				for k, v in pairs(mod.db.realm.names) do
					local_names[k] = v
					mod.db.realm.names[k] = nil
				end
			end
		end
	},
	includeLevel = {
		type = "toggle",
		name = "Include level",
		desc = "Include the player's level",
		get = function() return mod.db.profile.includeLevel end,
		set = function(info, val)
			mod.db.profile.includeLevel = val
			for k, v in pairs(names) do
				names[k] = nil
			end
		end
	}
}

function mod:OnInitialize()
	for i = 1, #classes do
		lookup[L[classes[i]]] = classes[i]:upper()
	end
	
	self.db = Chatter.db:RegisterNamespace("PlayerNames", defaults)
	for k, v in pairs(self.db.realm.names) do
		if type(v) == "string" then
			self.db.realm.names[k] = {class = v}
		end
	end
	
	
	if self.db.global and self.db.global.names then
		self.db.global.names = nil	-- get rid of old data
	end
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

function mod:AddPlayer(name, class, level)
	if name and class and class ~= "UNKNOWN" then
		if self.db.profile.saveData then
			self.db.realm.names[name] = self.db.realm.names[name] or {}
			self.db.realm.names[name].class = class
			self.db.realm.names[name].level = level
		else
			local_names[name] = local_names[name] or {}
			local_names[name].class = class
			local_names[name].level = level
		end
		names[name] = nil
	end
end

function mod:FRIENDLIST_UPDATE(evt)
	for i = 1, GetNumFriends() do
		local name, _, class = GetFriendInfo(i)
		if class then
			self:AddPlayer(name, lookup[class])
		end
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
		local _, c, _, l = UnitClass(n)
		self:AddPlayer(n, c, l)
	end
end

function mod:PARTY_MEMBERS_CHANGED(evt)
	for i = 1, GetNumPartyMembers() do
		local n = UnitName("party" .. i)
		local _, c = UnitClass("party" .. i)
		local l = UnitLevel("party" .. i)
		self:AddPlayer(n, c, l)
	end
end

function mod:PLAYER_TARGET_CHANGED(evt)
	if not UnitExists("target") or not UnitIsPlayer("target") or not UnitIsFriend("player", "target") then return end
	local _, cls = UnitClass("target")
	local l = UnitLevel("target")
	self:AddPlayer(UnitName("target"), cls, l)
end

function mod:UPDATE_MOUSEOVER_UNIT(evt)
	if not UnitExists("mouseover") or not UnitIsPlayer("mouseover") or not UnitIsFriend("player", "mouseover") then return end
	local _, cls = UnitClass("mouseover")
	local l = UnitLevel("mouseover")
	self:AddPlayer(UnitName("mouseover"), cls, l)
end

function mod:CHAT_MSG_SYSTEM(evt, msg)
	local name, level, class = select(3, msg:find("^|Hplayer:%w+|h%[(%w+)%]|h: %w+ (%d+) %w+ (%w+)"))
	if name and class then
		self:AddPlayer(name, lookup[class], level)
	end
end

function mod:WHO_LIST_UPDATE(evt)
	for i = 1, GetNumWhoResults() do
		local name, _, level, _, class = GetWhoInfo(i)
		if class then
			self:AddPlayer(name, lookup[class], level)
		end
	end
end

local function changeName(name, name2)
	return "|h[" .. names[name2] .. "]|h"
end

function mod:AddMessage(frame, text, ...)
	if not text then 
		return self.hooks[frame].AddMessage(frame, text, ...)
	end

	local name = arg2
	if event == "CHAT_MSG_SYSTEM" then name = select(3, text:find("|h%[([^%] ]+)|h")) end
	if name and type(name) == "string" then
		text = text:gsub("|h(%[("..name..")%])|h", changeName)
	end
	return self.hooks[frame].AddMessage(frame, text, ...)
end

function mod:Info()
	return "Colors player names according to their class."
end

function mod:GetOptions()
	return options
end
