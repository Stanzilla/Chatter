local mod = Chatter:NewModule("Chat Font")
local Media = LibStub("LibSharedMedia-3.0")
local fonts = {}
local fonts_and_default = {Default = "Default"}

local defaults = {
	profile = {
		frames = {}
	}
}

local outlines = {[""] = "None", ["OUTLINE"] = "Outline", ["THICKOUTLINE"] = "Thick Outline"}

local options = {
	font = {
		type = "select",
		name = "Font",
		desc = "Font",
		values = fonts,
		get = function() return mod.db.profile.font end,
		set = function(info, v) 
			mod.db.profile.font = v
			mod:SetFont(nil, v)
		end
	},
	fontsize = {
		type = "range",
		name = "Font size",
		desc = "Font size",
		min = 4,
		max = 30,
		step = 1,
		bigStep = 1,
		get = function() return mod.db.profile.fontsize end,
		set = function(info, v)
			mod.db.profile.fontsize = v
			mod:SetFont(cf, nil, v)
		end
	},
	outline = {
		type = "select",
		name = "Font Outline",
		desc = "Font outlining",
		values = outlines,
		get = function() return mod.db.profile.outline or "" end,
		set = function(info, v) 
			mod.db.profile.outline = v
			mod:SetFont(nil, nil, nil, v)
		end
	}
}

function mod:OnInitialize()
	for i = 1, NUM_CHAT_WINDOWS do
		defaults.profile.frames["FRAME_" .. i] = {}
	end
	self.db = Chatter.db:RegisterNamespace("ChatFont", defaults)
	Media.RegisterCallback(mod, "LibSharedMedia_Registered")
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame" .. i]
		local t = {
			type = "group",
			name = "Chat Frame " .. i,
			desc = "Chat Frame " .. i,
			args = {
				fontsize = {
					type = "range",
					name = "Font size",
					desc = "Font size",
					min = 4,
					max = 30,
					step = 1,
					bigStep = 1,
					get = function() return mod.db.profile.frames["FRAME_" .. i].fontsize or mod.db.profile.fontsize end,
					set = function(info, v)
						mod.db.profile.frames["FRAME_" .. i].fontsize = v
						mod:SetFont(cf, nil, v)
					end
				},
				font = {
					type = "select",
					name = "Font",
					desc = "Font",
					values = fonts_and_default,
					get = function() return mod.db.profile.frames["FRAME_" .. i].font or mod.db.profile.font end,
					set = function(info, v) 
						mod.db.profile.frames["FRAME_" .. i].font = v
						mod:SetFont(cf, v)
					end
				},
				outline = {
					type = "select",
					name = "Font Outline",
					desc = "Font outlining",
					values = outlines,
					get = function() return mod.db.profile.frames["FRAME_" .. i].outline or "" end,
					set = function(info, v) 
						mod.db.profile.frames["FRAME_" .. i].outline = v
						mod:SetFont(cf, nil, nil, v)
					end
				}
			}
		}
		options["frame" .. i] = t
	end	
end

function mod:LibSharedMedia_Registered()
	for k, v in pairs(Media:List("font")) do
		fonts[v] = v
		fonts_and_default[v] = v
	end
end

function mod:OnEnable()
	self:SetFont()
end

function mod:OnDisable()
	self:SetFont(nil, "Fritz Quadrata", 12, "")
end

function mod:SetFont(cf, font, size, outline)
	if cf then		
		self:SetFrameFont(cf, font, size, outline)
	else
		for i = 1, NUM_CHAT_WINDOWS do
			cf = _G["ChatFrame" .. i]
			self:SetFrameFont(cf, font, size, outline)
		end
	end
end

function mod:SetFrameFont(cf, font, size, outline)
	local f = "FRAME_" .. cf:GetName():match("%d+")
	local prof = self.db.profile.frames[f]
	local profFont = prof.font
	if profFont == "Default" then
		profFont = nil
	end
	local f, s, m = cf:GetFont() 
	font = Media:Fetch("font", font or profFont or self.db.profile.font or f)
	size = size or prof.fontsize or self.db.profile.fontsize or s
	outline = outline or prof.outline or self.db.profile.outline or m
	cf:SetFont(font, size, outline)
end

function mod:GetOptions()
	return options
end

function mod:Info()
	return "Enables you to set a custom font and font size for your chat frames"
end
