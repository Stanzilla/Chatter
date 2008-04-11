local mod = Chatterbox:NewModule("ChatScroll", "AceHook-3.0")
local IsShiftKeyDown = _G.IsShiftKeyDown
local IsControlKeyDown = _G.IsControlKeyDown

local scrollFunc = function(self, arg1)
	if arg1 > 0 then
		if IsShiftKeyDown() then
			self:ScrollToTop()
		elseif IsControlKeyDown() then
			self:PageUp()
		else
			self:ScrollUp()
		end
	elseif arg1 < 0 then
		if IsShiftKeyDown() then
			self:ScrollToBottom()
		elseif IsControlKeyDown() then
			self:PageDown()
		else
			self:ScrollDown()
		end
	end
end

function mod:OnEnable()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G[("%s%d"):format("ChatFrame", i)]
		cf:SetScript("OnMouseWheel", scrollFunc)
		cf:EnableMouseWheel(true)
	end
end

function mod:OnDisable()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G[("%s%d"):format("ChatFrame", i)]
		cf:SetScript("OnMouseWheel", nil)
		cf:EnableMouseWheel(false)
	end
end
