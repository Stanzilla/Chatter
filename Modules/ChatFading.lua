local mod = Chatterbox:NewModule("Disable Fading")
mod.toggleLabel = "Disable Fading"

function mod:OnEnable()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame" .. i]
		cf:SetFading(nil)
	end
end

function mod:OnDisable()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame" .. i]
		cf:SetFading(true)
	end
end

function mod:Info()
	return "Make windows not fade out when you mouse off of them."
end
