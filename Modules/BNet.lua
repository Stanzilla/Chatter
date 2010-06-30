-- Strip icons like |TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61
local mod = Chatter:NewModule("BNet", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Chatter")
mod.modName = L["RealID Polish"]

function mod:OnInitialize()
end

function mod:OnEnable()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame" .. i]
		if cf ~= COMBATLOG then
			self:RawHook(cf, "AddMessage", true)
		end
	end
end

function mod:ParseLinks(text)
	if not text then return nil end
	text = gsub(text, "(|TInterface(.*)ToastIcons(.*)|t)", "")
	return text
end

function mod:AddMessage(frame, text, ...)
	return self.hooks[frame].AddMessage(frame, mod:ParseLinks(text), ...)
end