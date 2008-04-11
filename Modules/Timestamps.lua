local mod = Chatterbox:NewModule("Timestamps", "AceHook-3.0")

function mod:OnEnable()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame" .. i]
		if cf ~= COMBATLOG then
			self:RawHook(cf, "AddMessage", true)
		end
	end
end

local COLOR = "777777"
function mod:AddMessage(frame, text, ...)
	if not text then 
		return self.hooks[frame].AddMessage(frame, text, ...)
	end
	text = "|cff"..COLOR.."["..date("%X").."]|r "..text
	return self.hooks[frame].AddMessage(frame, text, ...)
end

function mod:Info()
	return "Adds timestamps to chat."
end
