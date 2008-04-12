local mod = Chatter:NewModule("Tell Target (/tt)", "AceHook-3.0", "AceEvent-3.0", "AceConsole-3.0")
local UnitIsPlayer = _G.UnitIsPlayer
local UnitCanAssist = _G.UnitCanAssist
local UnitIsCharmed = _G.UnitIsCharmed
local gsub = _G.string.gsub

function mod:OnEnable()
	-- self:SecureHook("ChatEdit_ParseText")
	self:HookScript(ChatFrameEditBox, "OnTextChanged")
	self:RegisterChatCommand("tt", "SendChatMessage")
end

function mod:OnTextChanged(obj)
	local text = obj:GetText()
	if text:sub(1, 4) == "/tt " and not self.slashCommandRegistered then
		self.slashCommandRegistered = true
		self:TellTarget(DEFAULT_CHAT_FRAME, text:sub(5))
	end
	self.hooks[obj].OnTextChanged(obj)
end
	
function mod:TellTarget(frame, msg)	
	local unitname, realm
	if UnitIsPlayer("target") and (UnitCanAssist("player", "target") or UnitIsCharmed("target"))then
		unitname, realm = UnitName("target")
		if unitname then unitname = gsub(unitname, " ", "") end
		if unitname and not UnitIsSameServer("target") then
			unitname = unitname .. "-" .. gsub(realm, " ", "")
		end
	end
	ChatFrame_SendTell((unitname or "InvalidTarget"), frame)
	ChatFrameEditBox:SetText(msg)
end

function mod:Info()
	return "Enables the /tt command to send a tell to your target."
end

function mod:SendChatMessage(input)
	ChatFrame1:AddMessage(input)
	self:TellTarget(DEFAULT_CHAT_FRAME, input)
end

