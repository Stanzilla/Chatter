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
		local chatFrame = nil
		for i= 1,NUM_CHAT_WINDOWS do
			local cf = _G["ChatFrame"..i]
			if not foundSrc then
				for i = 1, cf:GetNumMessages(accessID) do
					chatFrame = cf
				end
			end
		end
		local t = FCF_OpenTemporaryWindow(type, sender, chatFrame, true)
		for i=1,NUM_CHAT_WINDOWS do
			local cf = _G["ChatFrame"..i.."EditBox"]
			cf:Show()
		end
	end
end