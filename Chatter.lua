Chatter = LibStub("AceAddon-3.0"):NewAddon("Chatter", "AceConsole-3.0") 	--, "AceHook-3.0", "AceTimer-3.0", "AceConsole-3.0", "AceEvent-3.0", "LibSink-2.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local optFrame

local options = {
	type = "group",
	args = {
		aceConfig = {
			type = "execute",
			name = "Standalone Config",
			desc = "Open a standalone config window. You might consider installing |cffffff00BetterBlizzOptions|r to make the Blizzard UI options panel resizable.",
			func = function()
				InterfaceOptionsFrame:Hide()
				AceConfigDialog:SetDefaultSize("Chatter", 500, 550)
				AceConfigDialog:Open("Chatter")
			end
		},
		config = {
			type = "execute",
			guiHidden = true,
			name = "Configure",
			desc = "Configure",
			func = Chatter.OpenConfig
		},
		modules = {
			type = "group",
			name = "Modules",
			desc = "Modules",
			args = {}
		}
	}
}

local defaults = {
	profile = {
		modules = {
			["Disable Fading"] = false,
			["Chat Autolog"] = false
		}
	}
}

AceConfig:RegisterOptionsTable("Chatter", options)
Chatter:SetDefaultModuleState(false)

function Chatter:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("ChatterDB", defaults, "Default")
	for k, v in self:IterateModules() do
		options.args.modules.args[k:gsub(" ", "_")] = {
			type = "group",
			name = (v.modName or k),
			args = nil
		}
		local t
		if v.GetOptions then
			t = v:GetOptions()
		end
		t = t or {}
		t.toggle = {
			type = "toggle", 
			name = v.toggleLabel or ("Enable " .. (v.modName or k)), 
			desc = v.Info and v:Info() or ("Enable " .. (v.modName or k)), 
			order = 1,
			get = function()
				return Chatter.db.profile.modules[k] ~= false or false
			end,
			set = function(info, v)
				Chatter.db.profile.modules[k] = v
				if v then
					Chatter:EnableModule(k)
					Chatter:Print("Enabled", k, "module")
				else
					Chatter:DisableModule(k)
					Chatter:Print("Disabled", k, "module")
				end
			end
		}
		options.args.modules.args[k:gsub(" ", "_")].args = t
	end	
	optFrame = AceConfigDialog:AddToBlizOptions("Chatter", "Chatter")
	
	options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self:RegisterChatCommand("chatter", "OpenConfig")
	
	self.db.RegisterCallback(self, "OnProfileChanged", "SetUpdateConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "SetUpdateConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "SetUpdateConfig")
end

function Chatter:OpenConfig(input)
	if input == "config" then
		InterfaceOptionsFrame:Hide()
		AceConfigDialog:SetDefaultSize("Chatter", 500, 550)
		AceConfigDialog:Open("Chatter")
		return
	end
	InterfaceOptionsFrame_OpenToFrame(optFrame)
end

do
	local timer, t = nil, 0
	function update()
		t = t + arg1
		if t > 0.5 then
			timer:SetScript("OnUpdate", nil)
			Chatter:UpdateConfig()
		end
	end
	function Chatter:SetUpdateConfig()
		t = 0
		timer = timer or CreateFrame("Frame", nil, UIParent)
		timer:SetScript("OnUpdate", update)
	end
end

function Chatter:UpdateConfig()
	for k, v in self:IterateModules() do
		if v:IsEnabled() then
			v:Disable()
			v:Enable()
		end
	end
end

function Chatter:OnEnable()
	if not self.db.profile.welcomeMessaged then
		self:Print("Welcome to Chatter! Type /chatter to configure.")
		self.db.profile.welcomeMessaged = true
	end
	for k, v in self:IterateModules() do
		if self.db.profile.modules[k] ~= false then
			v:Enable()
		end
	end
end

function Chatter:OnDisable()
end
