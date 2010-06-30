local mod = Chatter:NewModule("Auto Popup", "AceHook-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Chatter")
mod.modName = L["Automatic Whisper Windows"]

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_WHISPER","ProcessWhisper")
	self:RegisterEvent("CHAT_MSG_WHISPER_INFORM","ProcessWhisper")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM", "ProcessWhisper")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER","ProcessWhisper")
end

function mod:OnDisable()
	self:UnregisterEvent("CHAT_MSG_WHISPER")
	self:UnregisterEvent("CHAT_MSG_WHISPER_INFORM")
	self:UnregisterEvent("CHAT_MSG_BNWHISPER")
	self:UnregisterEvent("CHAT_MSG_BNWHISPER_INFORM")
end

function mod:ProcessWhisper(event,message,sender,language,channelString,target,flags,arg7,arg8,...)
	-- Do we have a temp window already for this target
	local type = "WHISPER"
	if event == "CHAT_MSG_BN_WHISPER" or event == "CHAT_MSG_BN_WHISPER_INFORM" then
		type = "BN_WHISPER"
	end
	if FCFManager_GetNumDedicatedFrames(type, sender) == 0 then
		FCF_OpenTemporaryWindow(type,sender)
	end
end