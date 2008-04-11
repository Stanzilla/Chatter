local mod = Chatterbox:NewModule("Edit Box Polish")

local Media = LibStub("LibSharedMedia-3.0")
local backgrounds, borders = {}, {}

local VALID_ATTACH_POINTS = {
	TOP = "Top",
	BOTTOM = "Bottom",
}

local options = {
	background = {
		type = "select",
		name = "Background texture",
		desc = "Background texture",
		values = backgrounds,
		get = function() return mod.db.profile.background end,
		set = function(info, v)
			mod.db.profile.background = v
			mod:SetBackdrop()
		end
	},
	border = {
		type = "select",
		name = "Border texture",
		desc = "Border texture",
		values = borders,
		get = function() return mod.db.profile.border end,
		set = function(info, v)
			mod.db.profile.border = v
			mod:SetBackdrop()
		end
	},
	backgroundColor = {
		type = "color",
		name = "Background color",
		desc = "Background color",
		hasAlpha = true,
		get = function()
			local c = mod.db.profile.backgroundColor
			return c.r, c.g, c.b, c.a
		end,
		set = function(info, r, g, b, a)
			local c = mod.db.profile.backgroundColor
			c.r, c.g, c.b, c.a = r, g, b, a
			mod:SetBackdrop()
		end
	},
	borderColor = {
		type = "color",
		name = "Border color",
		desc = "Border color",
		hasAlpha = true,
		get = function()
			local c = mod.db.profile.borderColor
			return c.r, c.g, c.b, c.a
		end,
		set = function(info, r, g, b, a)
			local c = mod.db.profile.borderColor
			c.r, c.g, c.b, c.a = r, g, b, a
			mod:SetBackdrop()
		end
	},
	inset = {
		type = "range",
		name = "Background Inset",
		desc = "Background Inset",
		min = 1,
		max = 64,
		step = 1,
		bigStep = 1,
		get = function() return mod.db.profile.inset end,
		set = function(info, v)
			mod.db.profile.inset = v
			mod:SetBackdrop()
		end
	},
	tileSize = {
		type = "range",
		name = "Tile Size",
		desc = "Tile Size",
		min = 1,
		max = 64,
		step = 1,
		bigStep = 1,
		get = function() return mod.db.profile.tileSize end,
		set = function(info, v)
			mod.db.profile.tileSize = v
			mod:SetBackdrop()
		end
	},
	edgeSize = {
		type = "range",
		name = "Edge Size",
		desc = "Edge Size",
		min = 1,
		max = 64,
		step = 1,
		bigStep = 1,
		get = function() return mod.db.profile.edgeSize end,
		set = function(info, v)
			mod.db.profile.edgeSize = v
			mod:SetBackdrop()
		end
	},
	attach = {
		type = "select",
		name = "Attach to...",
		desc = "Attach edit box to...",
		get = function() return mod.db.profile.attach end,
		values = VALID_ATTACH_POINTS,
		set = function(info, v)
			mod.db.profile.attach = v
			mod:SetAttach()
		end
	}
}

local defaults = {
	profile = {
		background = "Blizzard Tooltip",
		border = "Blizzard Dialog",
		backgroundColor = {r = 0, g = 0, b = 0, a = 1},
		borderColor = {r = 1, g = 1, b = 1, a = 1},
		inset = 4,
		edgeSize = 24,
		tileSize = 16,
		attach = "BOTTOM",
	}
}

function mod:LibSharedMedia_Registered()
	for k, v in pairs(Media:List("background")) do
		backgrounds[v] = v
	end
	for k, v in pairs(Media:List("border")) do
		borders[v] = v
	end
end

function mod:OnInitialize()
	self.db = Chatterbox.db:RegisterNamespace("EditBox", defaults)
	Media.RegisterCallback(mod, "LibSharedMedia_Registered")
	self.frame = CreateFrame("Frame", nil, ChatFrameEditBox)
	self.frame:SetAllPoints(ChatFrameEditBox)
	self.frame:SetFrameStrata("HIGH")
end

function mod:OnEnable()
	self:LibSharedMedia_Registered()
	ChatFrameEditBox:SetAltArrowKeyMode(false)
	local left, mid, right = select(6, ChatFrameEditBox:GetRegions())
	left:Hide()
	mid:Hide()
	right:Hide()
	self.frame:Show()
	self:SetBackdrop()
	self:SetAttach()
end

function mod:OnDisable()
	ChatFrameEditBox:SetAltArrowKeyMode(true)
	local left, mid, right = select(6, ChatFrameEditBox:GetRegions())
	left:Show()
	mid:Show()
	right:Show()
	self.frame:Hide()
	self:SetAttach("BOTTOM")
end

function mod:GetOptions()
	return options
end

function mod:SetBackdrop()
	self.frame:SetBackdrop({
		bgFile = Media:Fetch("background", self.db.profile.background),
		edgeFile = Media:Fetch("border", self.db.profile.border),
		tile = true,
		tileSize = self.db.profile.tileSize,
		edgeSize = self.db.profile.edgeSize,
		insets = {left = self.db.profile.inset, right = self.db.profile.inset, top = self.db.profile.inset, bottom = self.db.profile.inset}
	})
	local c = self.db.profile.backgroundColor
	self.frame:SetBackdropColor(c.r, c.g, c.b, c.a)
	
	local c = self.db.profile.borderColor
	self.frame:SetBackdropBorderColor(c.r, c.g, c.b, c.a)
end

function mod:SetAttach(val)
	ChatFrameEditBox:ClearAllPoints()
	local val = val or self.db.profile.attach
	if val == "TOP" then
		ChatFrameEditBox:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT")
		ChatFrameEditBox:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT")
	else
		ChatFrameEditBox:SetPoint("TOPLEFT", ChatFrame1, "BOTTOMLEFT")
		ChatFrameEditBox:SetPoint("TOPRIGHT", ChatFrame1, "BOTTOMRIGHT")
	end
end

function mod:Info()
	return "Lets you customize the position and look of the edit box"
end
