local mod = Chatterbox:NewModule("Telltarget", "AceHook-3.0", "AceEvent-3.0")
local gsub = _G.string.gsub

function mod:OnEnable()
	self:RawHook("ChatEdit_ParseText", true)
end

function mod:ChatEdit_ParseText(editBox, send)
	local text = editBox:GetText()
	if text:find("/") == 1 then
		if gsub(text, "/([^%s]+)%s(.*)", "/%1", 1) == "/tt" then
			self:TellTarget(editBox.chatFrame, msg)
		end
	end
	self.hooks.ChatEdit_ParseText(editBox, send)
end
	
function mod:TellTarget(frame, msg)	
	local unitname, realm
	if UnitIsPlayer("target") and (UnitCanAssist("player", "target") or UnitIsCharmed("target"))then
		unitname, realm = UnitName("target")
		if unitname then unitname = gsub(unitname, " ", "") end
		if realm and unitname and #realm > 0 then
			unitname = unitname .. "-" .. gsub(realm, " ", "")
		end
	end
	ChatFrame_SendTell((unitname or "InvalidTarget"), frame)
end

function mod:Info()
	return "Enables the /tt command to send a tell to your target"
end
