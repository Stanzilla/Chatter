local mod = Chatterbox:NewModule("Alt Linking", "AceHook-3.0")
local NAMES

local defaults = { realm = {} }

local accept = function(char)
	local editBox = getglobal(this:GetParent():GetName().."EditBox")
	local main = editBox:GetText()
	mod:AddAlt(char, main)
	this:GetParent():Hide()
end

StaticPopupDialogs['MENUITEM_SET_MAIN'] = {
	text		= "Who is %s's main?",
	button1		= TEXT(ACCEPT),
	button2		= TEXT(CANCEL),
	hasEditBox	= 1,
	maxLetters	= 128,
	exclusive	= 0,
	OnShow = function()
		_G[this:GetName().."EditBox"]:SetFocus()
	end,
	OnHide = function()
		if ( ChatFrameEditBox:IsShown() ) then
			ChatFrameEditBox:SetFocus();
		end
		_G[this:GetName().."EditBox"]:SetText("");
	end,
	OnAccept = accept,
	EditBoxOnEnterPressed = accept,
	EditBoxOnEscapePressed = function() this:GetParent():Hide() end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1
}	

UnitPopupButtons["SET_MAIN"] = {
	text = "Set Main",
	dist = 0,
	func = mod.GetMainName
}

function mod:OnInitialize()
	self.db = Chatterbox.db:RegisterNamespace("AltLinks", defaults)
end

function mod:OnEnable()
	NAMES = self.db.realm
	UnitPopupButtons["SET_MAIN"].func = self.GetMainName
	tinsert(UnitPopupMenus["SELF"], 	#UnitPopupMenus["SELF"] - 1,	"SET_MAIN")
	tinsert(UnitPopupMenus["PLAYER"], 	#UnitPopupMenus["PLAYER"] - 1,	"SET_MAIN")
	tinsert(UnitPopupMenus["FRIEND"],	#UnitPopupMenus["FRIEND"] - 1,	"SET_MAIN")
	tinsert(UnitPopupMenus["PARTY"], 	#UnitPopupMenus["PARTY"] - 1,	"SET_MAIN")
	self:SecureHook("UnitPopup_ShowMenu")
	
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame" .. i]
		if cf ~= COMBATLOG then
			self:RawHook(cf, "AddMessage", true)
		end
	end	
end

local types = {"SELF", "PLAYER", "FRIEND", "PARTY"}
function mod:OnDisable()
	for j = 1, #types do
		local t = types[i]
		for i = 1, #UnitPopupMenus[t] do
			if #UnitPopupMenus[t][i] == "SET_MAIN" then
				tremove(#UnitPopupMenus[t], i)
				break
			end
		end
	end
end

function mod.GetMainName()
	local alt = _G[UIDROPDOWNMENU_INIT_MENU].name
	local popup = StaticPopup_Show("MENUITEM_SET_MAIN", alt)
	if popup then popup.data = alt end
end

function mod:UnitPopup_ShowMenu(dropdownMenu, which, unit, name, userData, ...)
	for i=1, UIDROPDOWNMENU_MAXBUTTONS do
		button = _G["DropDownList"..UIDROPDOWNMENU_MENU_LEVEL.."Button"..i];
		if button.value == "SET_MAIN" then
		    button.func = UnitPopupButtons["SET_MAIN"].func
		end
	end
end

function mod:AddAlt(alt, main)
	self.db.realm[alt] = main
end

function mod:AddMessage(frame, text, ...)
	if not text then 
		return self.hooks[frame].AddMessage(frame, text, ...)
	end

	local name = arg2
	if event == "CHAT_MSG_SYSTEM" then name = select(3, text:find("|h%[(.+)%]|h")) end
	if name and type(name) == "string" then
		local alt = NAMES[name]
		if alt then
			text = text:gsub("|h%[([^%]]+"..name.."[^%]]+)%]|h", "|h[%1 (" .. alt .. ")]|h") 
		end
	end
	return self.hooks[frame].AddMessage(frame, text, ...)
end
