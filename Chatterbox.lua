Chatterbox = LibStub("AceAddon-3.0"):NewAddon("Chatterbox", "AceConsole-3.0") 	--, "AceHook-3.0", "AceTimer-3.0", "AceConsole-3.0", "AceEvent-3.0", "LibSink-2.0")
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
				AceConfigDialog:SetDefaultSize("Chatterbox", 500, 550)
				AceConfigDialog:Open("Chatterbox")
			end
		},
		config = {
			type = "execute",
			guiHidden = true,
			name = "Configure",
			desc = "Configure",
			func = Chatterbox.OpenConfig
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
		modules = {}
	}
}

AceConfig:RegisterOptionsTable("Chatterbox", options)
Chatterbox:SetDefaultModuleState(false)

function Chatterbox:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("ChatterboxDB", defaults)
	for k, v in self:IterateModules() do
		options.args.modules.args[k] = {
			type = "group",
			name = k,
			args = nil
		}
		local t
		if v.GetOptions then
			t = v:GetOptions()
		end
		t = t or {}
		t.toggle = {
			type = "toggle", 
			name = "Enable " .. k, 
			desc = v.Info and v:Info() or ("Enable " .. k), 
			order = 1,
			get = function()
				return Chatterbox.db.profile.modules[k] ~= false or false
			end,
			set = function(info, v)
				Chatterbox.db.profile.modules[k] = v
				if v then
					Chatterbox:EnableModule(k)
					Chatterbox:Print("Enabled", k, "module")
				else
					Chatterbox:DisableModule(k)
					Chatterbox:Print("Disabled", k, "module")
				end
			end
		}
		options.args.modules.args[k].args = t
	end	
	optFrame = AceConfigDialog:AddToBlizOptions("Chatterbox", "Chatterbox")
	
	options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self:RegisterChatCommand("chatter", "OpenConfig")
	self:RegisterChatCommand("chatterbox", "OpenConfig")
end

function Chatterbox:OpenConfig(input)
	if input == "config" then
		InterfaceOptionsFrame:Hide()
		AceConfigDialog:SetDefaultSize("Chatterbox", 500, 550)
		AceConfigDialog:Open("Chatterbox")
		return
	end
	InterfaceOptionsFrame_OpenToFrame(optFrame)
end

function Chatterbox:OnEnable()
	if not self.db.profile.welcomeMessaged then
		self:Print("Welcome to Chatterbox! Type /chatterbox to configure.")
		self.db.profile.welcomeMessaged = true
	end
	for k, v in self:IterateModules() do
		if self.db.profile.modules[k] ~= false then
			v:Enable()
		end
	end
end

function Chatterbox:OnDisable()
end
