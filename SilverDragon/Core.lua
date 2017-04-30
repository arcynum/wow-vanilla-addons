local tablet = AceLibrary("Tablet-2.0")
local L = AceLibrary("AceLocale-2.2"):new("SilverDragon")

SilverDragon = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceConsole-2.0", "AceDB-2.0", "AceHook-2.1", "FuBarPlugin-2.0")

SilverDragon.version = "2.0." .. string.sub("$Revision: 38392 $", 12, -3)
SilverDragon.date = string.sub("$Date: 2007-06-03 23:41:27 -0400 (Sun, 03 Jun 2007) $", 8, 17)
SilverDragon.hasIcon = L["DefaultIcon"]

function SilverDragon:OnInitialize()
	SilverDragon:RegisterDB("SilverDragonDB")
	SilverDragon:RegisterDefaults('profile', {
		mobs = {
			--zone
			["*"] = {},
		},
		notes = true,
		scan = true,
		announce = {
			chat = true,
			error = true,
			sound = true
		},
	})
	local optionsTable = {
		type="group",
		args={
			settings = {
				name=L["Settings"], desc=L["Configuration options"],
				type="group",
				args={
					scan = {
						name=L["Scan"], desc=L["Scan for nearby rares at a regular interval"],
						type="toggle",
						get=function() return self.db.profile.scan end,
						set=function(t)
							self.db.profile.scan = t
							if t then self:ScheduleRepeatingEvent('SilverDragon_Scan', self.CheckNearby, 5, self)
							else self:CancelScheduledEvent('SilverDragon_Scan') end
						end,
					},
					announce = {
						name=L["Announce"], desc=L["Display a notification when a rare is detected"],
						type="group", args={
							chat = {
								name=L["Chat"], desc=L["In the chatframe"],
								type="toggle",
								get=function() return self.db.profile.announce.chat end,
								set=function(t) self.db.profile.announce.chat = t end,
							},
							error = {
								name=L["Error"], desc=L["In the errorframe"],
								type="toggle",
								get=function() return self.db.profile.announce.error end,
								set=function(t) self.db.profile.announce.error = t end,
							},
							sound = {
								name=L["Sound"], desc=L["In your ears"],
								type="toggle",
								get=function() return self.db.profile.announce.sound end,
								set=function(t) self.db.profile.announce.sound = t end,
							},
						},
					},
					notes = {
						name=L["Notes"], desc=L["Make notes in Cartographer"],
						type="toggle",
						get = function() return self.db.profile.notes end,
						set = function(t)
							self.db.profile.notes = t
							self:ToggleCartographer(t)
						end,
						disabled = function()
							if Cartographer_Notes then return false
							else return true end
						end,
					}
				},
			},
			scan = {
				name=L["Do scan"], desc=L["Scan for nearby rares"],
				type="execute", func="CheckNearby",
			},
			defaults = {
				name=L["Import defaults"], desc=L["Import a default database of rares"],
				type="execute", func = function() self:ImportDefaults() end,
				disabled = function() return type(self.ImportDefaults) ~= 'function' end,
			},
		},
	}
	self:RegisterChatCommand(L["ChatCommands"], optionsTable)
	self.OnMenuRequest = optionsTable
	self.lastseen = {}
end

function SilverDragon:OnEnable()
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	if self.db.profile.scan then
		self:ScheduleRepeatingEvent('SilverDragon_Scan', self.CheckNearby, 5, self)
	end
	self:ToggleCartographer(self.db.profile.notes)
end

function SilverDragon:OnDisable()
	self:ToggleCartographer(false)
end

local cartdb = {}
local cartdb_populated
function SilverDragon:ToggleCartographer(enable)
	if Cartographer_Notes then
		if enable then
			Cartographer_Notes:RegisterIcon("Rare", {text = L["Rare mob"], path = "Interface\\Icons\\INV_Misc_Head_Dragon_01", width=12, height=12})
			Cartographer_Notes:RegisterNotesDatabase("SilverDragon", cartdb, SilverDragon)
			if not cartdb_populated then
				for zone, mobs in pairs(self.db.profile.mobs) do
					for name in pairs(mobs) do
						local x, y, level, elite = self:GetMobInfo(zone, name)
						if x > 0 and y > 0 then
							if elite == 1 then
								Cartographer_Notes:SetNote(zone, tonumber(x)/100, tonumber(y)/100, 'Rare', 'SilverDragon', 'title', name .. " - |cFF00FF00Lv" .. level .. " |cFFFF0000Elite")
							else
								Cartographer_Notes:SetNote(zone, tonumber(x)/100, tonumber(y)/100, 'Rare', 'SilverDragon', 'title', name .. " - |cFF00FF00Lv" .. level)
							end
						end
					end
				end
			end
		else
			Cartographer_Notes:UnregisterIcon("Rare")
			Cartographer_Notes:UnregisterNotesDatabase("SilverDragon")
		end
	end
end

function SilverDragon:SetNoteHere(zone, name)
	local x,y = GetPlayerMapPosition('player')
	Cartographer_Notes:SetNote(GetRealZoneText(), x, y, 'Rare', 'SilverDragon', 'title', name)
	self:Print(string.format("Cartographer note added for %s", name))
end

function SilverDragon:PLAYER_TARGET_CHANGED()
	self:IsRare('target')
end

function SilverDragon:UPDATE_MOUSEOVER_UNIT()
	self:IsRare('mouseover')
end

function SilverDragon:SaveMob(zone, name, x, y, level, elite, ctype, subzone)
	self.db.profile.mobs[zone][name] = string.format("%s:%s:%d:%d:%s:%s:%d", math.floor(x * 1000)/10, math.floor(y * 1000)/10, level, elite, ctype, subzone, self.lastseen[name] or 0)
end

function SilverDragon:GetMobInfo(zone, name)
	if self.db.profile.mobs[zone][name] then
		-- This seems to be in place because the first 2 parameters are nil.
		local _,_,x,y,level,elite,ctype,csubzone,lastseen = string.find(self.db.profile.mobs[zone][name], "^(.*):(.*):(-?%d*):(%d*):(.*):(.*):(%d*)")
		return tonumber(x), tonumber(y), tonumber(level), tonumber(elite), ctype, csubzone, tonumber(lastseen)
	else
		return 0, 0, 0, 0, '', '', nil
	end
end

-- Function to check if the mob already exists in the data.
function SilverDragon:MobExistsInDatabase(zone, name)
	if self.db.profile.mobs[zone][name] then
		return true
	else
		return false
	end
end

-- Added a function to ensure a note is not added to cartographer if one already exists.
function SilverDragon:IsRare(unit)
	local distanceCache = {}
	local c12n = UnitClassification(unit)
	if c12n == 'rare' or c12n == 'rareelite' then
		local name = UnitName(unit)
		local distance = 1000
		if CheckInteractDistance(unit, 3) then
			distance = 10
		elseif CheckInteractDistance(unit, 4) then
			distance = 30
		end
		self:Announce(name, UnitIsDead(unit))
		if UnitIsVisible(unit) and (distanceCache[name] or 100) then
			distanceCache[name] = distance
			local x, y = GetPlayerMapPosition("player")
			local mobExists = SilverDragon:MobExistsInDatabase(GetRealZoneText(), name)
			self:SaveMob(GetRealZoneText(), name, x, y, UnitLevel(unit), c12n=='rareelite' and 1 or 0, UnitCreatureType(unit), GetSubZoneText())
			self:Update()
			if self.db.profile.notes and Cartographer_Notes and not (x == 0 and y == 0) and not mobExists then
				self:SetNoteHere(GetRealZoneText(), name)
			end
		end
	end
end

function SilverDragon:Announce(name, dead)
	-- Announce the discovery of a rare. Return true if we announced.
	-- Only announce each rare every minute, preventing spam while we're in combat.
	if (not self.lastseen[name]) or (self.lastseen[name] < (time() - 60)) then
		if self.db.profile.announce.error then
			UIErrorsFrame:AddMessage(string.format(L["%s seen!"], name), 1, 0, 0, 1, UIERRORS_HOLD_TIME)
			if dead then
				UIErrorsFrame:AddMessage(L["(it's dead)"], 1, 0, 0, 1, UIERRORS_HOLD_TIME)
			end
		end

		if self.db.profile.announce.chat then
			self:Print(string.format(L["%s seen!"], name), dead and L["(it's dead)"] or '')
		end

		if self.db.profile.announce.sound then
			PlaySound("AuctionWindowOpen")
		end
		
		self.lastseen[name] = time()
		return true
	end
end

function SilverDragon:CheckNearby()
	self:TargetScan()
end

function SilverDragon:OnTooltipUpdate()
	local zone, subzone = GetRealZoneText(), GetSubZoneText()
	cat = tablet:AddCategory('text', zone, 'columns', 5)
	cat:AddLine(
		'text', "Name", 'textR', 1, 'textG', 1, 'textB', 1,
		'text2', "Level/Type", 'text2R', 1, 'text2G', 1, 'text2B', 1,
		'text3', "Zone", 'text3R', 1, 'text3G', 1, 'text3B', 1,
		'text4', "Last Seen", 'text4R', 1, 'text4G', 1, 'text4B', 1,
		'text5', "Location", 'text5R', 1, 'text5G', 1, 'text5B', 1
	)
	for name in pairs(self.db.profile.mobs[zone]) do
		local x,y,level,elite,ctype,csubzone,lastseen = self:GetMobInfo(zone, name)
		cat:AddLine(
			'text', name, 'textR', subzone == csubzone and 0 or nil, 'textG', subzone == csubzone and 1 or nil, 'textB', subzone == csubzone and 0 or nil,
			'text2', string.format("Level %s%s %s", (level and tonumber(level) > 1) and level or '?', elite==1 and '+' or '', ctype and ctype or '?'),
			'text3', csubzone,
			'text4', self:LastSeen(lastseen),
			'text5', string.format("%s, %s", x, y)
		)
	end
end

function SilverDragon:LastSeen(t)
	if t == 0 then
		return L['Never']
	end

	local lastseen
	local currentTime = time()
	local minutes = math.ceil((currentTime - t) / 60)

	if (currentTime - t) < 60 then
		lastseen = L["Now"]
	elseif minutes > 59 then
		local hours = math.ceil((currentTime - t) / 3600)
		if hours > 23 then
			lastseen = math.ceil((currentTime - t) / 86400)..L[" day(s)"]
		else
			lastseen = hours..L[" hour(s)"]
		end
	else
		lastseen = minutes..L[" minute(s)"]
	end

	return lastseen
end

function SilverDragon:OnTextUpdate()
	self:SetText(L["Rares"])
end

----------------------------
-- Cartographer Overrides --
----------------------------

function SilverDragon:OnNoteTooltipRequest(zone, id, data, inMinimap)
	local x,y,level,elite,ctype,csubzone,lastseen = self:GetMobInfo(zone, data.title)
	local cat = tablet:AddCategory('text', data.title, 'justify', 'CENTER')
	cat:AddLine('text', string.format("level %s%s %s", (level and tonumber(level) > 1) and level or '?', elite==1 and '+' or '', ctype and ctype or '?'))
	cat:AddLine('text', self:LastSeen(lastseen))
end

function SilverDragon:OnNoteTooltipLineRequest(zone, id, data, inMinimap)
	local x,y,level,elite,ctype,csubzone,lastseen = self:GetMobInfo(zone, data.title)
	return 'text', string.format("%s: level %s%s %s", data.title, (level and tonumber(level) > 1) and level or '?', elite==1 and '+' or '', ctype and ctype or '?')
end

---------------------
-- Target Scanning --
---------------------

function SilverDragon:TargetScan()
	for i=1, GetNumPartyMembers(), 1 do
		PartyTarget = "party" .. i .. "target"
		PartyPetTarget = "partypet" .. i .. "target"
		self:IsRare(PartyTarget)
		self:IsRare(PartyPetTarget)
		
	end
end

-------------
-- Imports --
-------------

function SilverDragon:RaretrackerImport()
	if RT_Database then
		for zone, mobs in pairs(RT_Database) do
			for name, info in pairs(mobs) do
				if not self.db.profile.mobs[zone][name] then
					self:SaveMob(zone, name, info.locX or 0, info.locY or 0, info.level, info.elite or 0, info.creatureType or '', info.subZone or '')
				end
			end
		end
	else
		self:Print(L["Raretracker needs to be loaded for this to work."])
	end
end
