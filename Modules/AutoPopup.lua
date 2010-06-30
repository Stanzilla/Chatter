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
		local f = FCF_OpenTemporaryWindow(type,sender)
		-- Copy over the conversation data
		local accessID = ChatHistory_GetAccessID(f.chatType, f.chatTarget);
		for i= 1,NUM_CHAT_WINDOWS do
			local cf = _G["ChatFrame"..i]
			for i = 1, cf:GetNumMessages(accessID) do
				local text, accessID, lineID, extraData = cf:GetMessageInfo(i, accessID);
				local cType, cTarget = ChatHistory_GetChatType(extraData);
				local info = ChatTypeInfo[cType];
				Chatter.loading = true
				f:AddMessage(text, info.r, info.g, info.b, lineID, false, accessID, extraData);
				Chatter.loading = false
			end
			--Remove the messages from the old frame.
			cf:RemoveMessagesByAccessID(accessID);
		end
	end
end