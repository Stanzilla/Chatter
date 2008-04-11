local mod = Chatterbox:NewModule("Tiny Chat")

function mod:Info()
	return "Allows you to make the chat frames much smaller than usual."
end

function mod:OnEnable()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame" .. i]
		cf:SetMinResize(50, 20)
		cf:SetMaxResize(5000, 5000)
	end
end

function mod:OnDisable()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame" .. i]
		cf:SetMinResize(296, 75)
		cf:SetMaxResize(608, 400)
	end
end

--[[
<minResize>
	<AbsDimension x="296" y="75"/>
</minResize>
<maxResize>
	<AbsDimension x="608" y="400"/>
</maxResize>
]]--