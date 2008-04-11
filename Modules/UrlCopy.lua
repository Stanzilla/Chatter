local mod = Chatterbox:NewModule("UrlCopy", "AceHook-3.0")
local gsub = _G.string.gsub
local ipairs = _G.ipairs
local fmt = _G.string.format
local sub = _G.string.sub

local patterns = {
	{ " www%.([_A-Za-z0-9-]+)%.([_A-Za-z0-9-%.&/]+)%s?", "http://www.%1.%2"},
	{ " (%a+)://(%S+)%s?", "%1://%2"},
	{ " ([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", "%1@%2%3%4"},
	{ " ([_A-Za-z0-9-]+)%.([_A-Za-z0-9-]+)%.(%S+)%s?", "%1.%2.%3"},
	{ " ([_A-Za-z0-9-]+)%.([_A-Za-z0-9-]+)%.(%S+)%:([_0-9-]+)%s?", "%1.%2.%3:%4"},
	{ " ([_A-Za-z0-9-]+)%.(%a%a%a)%s?", "%1.%2"},
}

--[[		Popup Box		]]--
StaticPopupDialogs["ChatterboxUrlCopyDialog"] = {
	text = "URL",
	button2 = TEXT(CLOSE),
	hasEditBox = 1,
	hasWideEditBox = 1,
	showAlert = 1,
	OnShow = function()
		local editBox = _G[this:GetName().."WideEditBox"]
		if editBox then
			editBox:SetText(currentLink)
			editBox:SetFocus()
			editBox:HighlightText(0)
		end
		local button = _G[this:GetName().."Button2"]
		if button then
			button:ClearAllPoints()
			button:SetWidth(200)
			button:SetPoint("CENTER", editBox, "CENTER", 0, -30)
		end
		local icon = _G[this:GetName().."AlertIcon"]
		if icon then icon:Hide() end
	end,
	EditBoxOnEscapePressed = function() this:GetParent():Hide() end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
}

function mod:OnEnable()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame" .. i]
		if cf ~= COMBATLOG then
			self:RawHook(cf, "AddMessage", true)
		end
	end
	self:RawHook(nil, "SetItemRef", true)
end

local style = " |cffffffff|Hurl:%s|h[%s]|h|r "
function mod:AddMessage(frame, text, ...)
	for i, v in ipairs(patterns) do
		text = gsub(text, v[1], fmt(style, v[2], v[2]))
	end
	return self.hooks[frame].AddMessage(frame, text, ...)
end

function mod:SetItemRef(link, text, button)
	if sub(link, 1, 3) == "url" then
		currentLink = sub(link, 5)
		StaticPopup_Show("ChatterboxUrlCopyDialog")
		return
	end
	return self.hooks.SetItemRef(link, text, button)
end

function mod:Info()
	return "Lets you copy URLs out of chat."
end
