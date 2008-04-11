local mod = Chatterbox:NewModule("ChatFrameBorders")
local Media = LibStub("LibSharedMedia-3.0")
local backgrounds, borders = {}, {}

local options = {
}

local defaults = {
	profile = {
		frames = {}
	}
}

local frame_defaults = {
	enable = true,
	background = "Blizzard Tooltip",
	border = "Blizzard Tooltip",
	inset = 4,
	edgeSize = 16,
	backgroundColor = { r = 0, g = 0, b = 0, a = 1 },
	borderColor = { r = 1, g = 1, b = 1, a = 1 },
}

local function deepcopy(tbl)
   local new = {}
   for key,value in pairs(tbl) do
      new[key] = type(value) ~= "table" and value or deepcopy(value)  -- if it's a table, run deepCopy on it too, so we get a copy and not the original
   end
   return new
end

local frames = {}
function mod:OnInitialize()
	for i = 1, NUM_CHAT_WINDOWS do
		defaults.profile.frames["FRAME_" .. i] = deepcopy(frame_defaults)
		if _G["ChatFrame" .. i] == COMBATLOG then
			defaults.profile.frames["FRAME_" .. i].enable = false
		end
	end
	
	self.db = Chatterbox.db:RegisterNamespace("ChatFrameBorders", defaults)
	
	Media.RegisterCallback(mod, "LibSharedMedia_Registered")
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame" .. i]
		local frame = CreateFrame("Frame", nil, cf, "ChatFrameBorderTemplate")
		frame:EnableMouse(false)
		cf:SetFrameStrata("LOW")
		frame:SetFrameStrata("BACKGROUND")
		frame:Hide()
		frame.id = "FRAME_" .. i
		tinsert(frames, frame)
		local t = {
			type = "group",
			name = "Frame " .. i,
			desc = "Frame " .. i,
			args = {
				enable = {
					type = "toggle",
					name = "Enable",
					desc = "Enable borders on this frame",
					order = 1,
					get = function()
						return mod.db.profile.frames[frame.id].enable
					end,
					set = function(info, v)
						mod.db.profile.frames[frame.id].enable = v
						if v then
							frame:Show()
						else
							frame:Hide()
						end
					end
				},
				background = {
					type = "select",
					name = "Background texture",
					desc = "Background texture",
					values = backgrounds,
					get = function() return mod.db.profile.frames[frame.id].background end,
					set = function(info, v)
						mod.db.profile.frames[frame.id].background = v
						mod:SetBackdrop(frame)
					end
				},
				border = {
					type = "select",
					name = "Border texture",
					desc = "Border texture",
					values = borders,
					get = function() return mod.db.profile.frames[frame.id].border end,
					set = function(info, v)
						mod.db.profile.frames[frame.id].border = v
						mod:SetBackdrop(frame)
					end
				},
				backgroundColor = {
					type = "color",
					name = "Background color",
					desc = "Background color",
					hasAlpha = true,
					get = function()
						local c = mod.db.profile.frames[frame.id].backgroundColor
						return c.r, c.g, c.b, c.a
					end,
					set = function(info, r, g, b, a)
						local c = mod.db.profile.frames[frame.id].backgroundColor
						c.r, c.g, c.b, c.a = r, g, b, a
						mod:SetBackdrop(frame)
					end
				},
				borderColor = {
					type = "color",
					name = "Border color",
					desc = "Border color",
					hasAlpha = true,
					get = function()
						local c = mod.db.profile.frames[frame.id].borderColor
						return c.r, c.g, c.b, c.a
					end,
					set = function(info, r, g, b, a)
						local c = mod.db.profile.frames[frame.id].borderColor
						c.r, c.g, c.b, c.a = r, g, b, a
						mod:SetBackdrop(frame)
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
					get = function() return mod.db.profile.frames[frame.id].inset end,
					set = function(info, v)
						mod.db.profile.frames[frame.id].inset = v
						mod:SetBackdrop(frame)
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
					get = function() return mod.db.profile.frames[frame.id].tileSize end,
					set = function(info, v)
						mod.db.profile.frames[frame.id].tileSize = v
						mod:SetBackdrop(frame)
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
					get = function() return mod.db.profile.frames[frame.id].edgeSize end,
					set = function(info, v)
						mod.db.profile.frames[frame.id].edgeSize = v
						mod:SetBackdrop(frame)
					end
				}
			}
		}
		options[frame.id] = t
	end
end

function mod:LibSharedMedia_Registered()
	for k, v in pairs(Media:List("background")) do
		backgrounds[v] = v
	end
	for k, v in pairs(Media:List("border")) do
		borders[v] = v
	end
end

function mod:OnEnable()
	self:SetBackdrops()
	for i = 1, #frames do
		frames[i]:Show()
	end
end

function mod:OnDisable()
	for i = 1, #frames do
		ChatFrame1:AddMessage(frames[i]:GetName())
		frames[i]:Hide()
	end
end

function mod:SetBackdrops()
	for i = 1, #frames do
		self:SetBackdrop(frames[i])
	end
end

do
	function mod:SetBackdrop(frame)
		local profile = self.db.profile.frames[frame.id]
		frame:SetBackdrop({
			bgFile = Media:Fetch("background", profile.background),
			edgeFile = Media:Fetch("border", profile.border),
			tile = true,
			tileSize = profile.tileSize,
			edgeSize = profile.edgeSize,
			insets = {left = profile.inset, right = profile.inset, top = profile.inset, bottom = profile.inset}
		})
		local c = profile.backgroundColor or bgdefault
		frame:SetBackdropColor(c.r, c.g, c.b, c.a)
		
		local c = profile.borderColor or borderdefault
		frame:SetBackdropBorderColor(c.r, c.g, c.b, c.a)
	end
end

function mod:GetOptions()
	return options
end
