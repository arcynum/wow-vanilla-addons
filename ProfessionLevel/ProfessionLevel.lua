--[[ ProfessionLevel: Adds gathering profession level requirements to the tooltip
Original addon developed by Dae
Updated and improved for WoW 1.12 by Beegee

Version 1.2
	Added limited support for lockpicking
	Fixed level ?? Bosses incorrectly showing a skinning level of 1
	Fixed skinning levels 11-20 incorrectly showing a skinning level of 1
Version 1.1
	Fixed mining node names and levels
	Fixed herbalism node names and levels
	Added skill colors
Known issues:
	Does not show info when mouseover multiple minimap objects at once
	Some lockpicking skill levels are not fully accurate
]]


-- Mining data
MINING_NODE_LEVEL = {
	["Copper Vein"] = 1,
	["Tin Vein"] = 65,
	["Incendicite"] = 65,
	["Silver Vein"] = 75,
	["Iron Deposit"] = 125,
	["Indurium Deposit"] = 150,
	["Lesser Bloodstone Deposit"] = 155,
	["Gold Vein"] = 155,
	["Mithril Deposit"] = 175,
	["Ooze Covered Mithril Deposit"] = 175,
	["Truesilver Deposit"] = 230,
	["Small Thorium Vein"] = 245,
	["Rich Thorium Vein"] = 275,
	["Ooze Covered Rich Thorium Vein"] = 275,
	["Hakkari Thorium Vein"] = 250,
	["Dark Iron Deposit"] = 230,
	["Small Obsidian Chunk"] = 305,
	["Large Obsidian Chunk"] = 305
}

-- Herbalism data
HERBALISM_NODE_LEVEL = {
	["Peacebloom"] = 1,
	["Silverleaf"] = 1,
	["Earthroot"] = 15,
	["Mageroyal"] = 50,
	["Briarthorn"] = 70,
	["Stranglekelp"] = 85,
	["Bruiseweed"] = 100,
	["Wild Steelbloom"] = 115,
	["Grave Moss"] = 120,
	["Kingsblood"] = 125,
	["Liferoot"] = 150,
	["Fadeleaf"] = 160,
	["Goldthorn"] = 170,
	["Khadgar's Whisker"] = 185,
	["Wintersbite"] = 195,
	["Firebloom"] = 205,
	["Purple Lotus"] = 210,
	["Arthas' Tears"] = 220,
	["Sungrass"] = 230,
	["Blindweed"] = 235,
	["Ghost Mushroom"] = 245,
	["Gromsblood"] = 250,
	["Golden Sansam"] = 260,
	["Dreamfoil"] = 270,
	["Mountain Silversage"] = 280,
	["Plaguebloom"] = 285,
	["Icecap"] = 290,
	["Black Lotus"] = 300
}

-- Lockpicking data
-- Skill level ranges do not match other professions?
LOCKPICKING_OBJECT_LEVEL = {
	["Ornate Bronze Lockbox"] = 1,
	["Practice Lockbox"] = 1,
	["Buckaneer's Strongbox"] = 1,
	["Small Locked Chest"] = 1,
	["Battered Junkbox"] = 1,
	["Heavy Bronze Lockbox"] = 25,
	["The Jewel of the Southsea"] = 25,
	["Large Iron Bound Chest"] = 25,
	["Iron Lockbox"] = 70,
	["Worn Junkbox"] = 70,
	--["Battered Footlocker"] = 70, -- Name Collison
	--["Battered Footlocker"] = 110, -- Name Collison
	--["Battered Footlocker"] = 150, -- Name Collison
	--["Waterlogged Footlocker"] = 70, -- Name Collison
	--["Waterlogged Footlocker"] = 110, -- Name Collison
	--["Waterlogged Footlocker"] = 150, -- Name Collison
	["Sturdy Locked Chest"] = 70,
	["Gallywix's Lockbox"] = 70,
	["Duskwood Chest"] = 70,
	["Strong Iron Lockbox"] = 125,
	["Cozzle's Footlocker"] = 160,
	["Sturdy Junkbox"] = 175,
	--["Mossy Footlocker"] = 175, -- Name Collison
	--["Mossy Footlocker"] = 225, -- Name Collison
	--["Dented Footlocker"] = 175, -- Name Collison
	--["Dented Footlocker"] = 200, -- Name Collison
	--["Dented Footlocker"] = 225, -- Name Collison
	["Ironbound Locked Chest"] = 175,
	["Large Mithril Bound Chest"] = 175,
	["Steel Lockbox"] = 175,
	["Reinforced Steel Lockbox"] = 225,
	["Mithril Lockbox"] = 225,
	["Thorium Lockbox"] = 225,
	["Eternium Lockbox"] = 225,
	["Cell Door"] = 250,
	["Heavy Junkbox"] = 250,
	["Scarlet Footlocker"] = 250,
	["Reinforced Locked Chest"] = 250,
	["Shadowforge Gate"] = 250,
	["The Shadowforge Lock"] = 250,
	["East Garrison Door"] = 250,
	["Scholomance Door"] = 280,
	["Elders' Square Service Entrance"] = 300,
	["Service Entrance Gate"] = 300,
	["Gauntlet Gate"] = 300
}


function ProfessionLevel_OnShow()
	local parentFrame = this:GetParent();
	local parentFrameName = parentFrame:GetName();
	local itemName = getglobal(parentFrameName .. "TextLeft1"):GetText();
	
	if(MINING_NODE_LEVEL[itemName]) then
		ProfessionLevel_AddMiningInfo(parentFrame, itemName);
		return;
	elseif(HERBALISM_NODE_LEVEL[itemName]) then
		ProfessionLevel_AddHerbalismInfo(parentFrame, itemName);
		return;
	elseif(LOCKPICKING_OBJECT_LEVEL[itemName] and ProfessionLevel_IsPickable()) then
		ProfessionLevel_AddLockpickingInfo(parentFrame, itemName);
		return;
	elseif(ProfessionLevel_IsSkinnable()) then
		ProfessionLevel_AddSkinningInfo(parentFrame);
		return;
	end
end

function ProfessionLevel_GetProfessionLevel(skill)
	local numskills = GetNumSkillLines();
	for c = 1, numskills do
		local skillname, _, _, skillrank = GetSkillLineInfo(c);
		if(skillname == skill) then
			return skillrank;
		end	 
	end
	return 0;
end

function ProfessionLevel_IsSkinnable()
	for c = 1, GameTooltip:NumLines() do
		local line = getglobal("GameTooltipTextLeft"..c);
		if(line and line:GetText() == "Skinnable") then return true; end
	end
	return false;
end

function ProfessionLevel_IsPickable()
	for c = 1, GameTooltip:NumLines() do
		local line = getglobal("GameTooltipTextLeft"..c);
		if(line and line:GetText() == "Locked") then return true; end
	end
	return false;
end

function ProfessionLevel_AddMiningInfo(frame, itemName)
	local levelReq = MINING_NODE_LEVEL[itemName];
	local MiningLevel = ProfessionLevel_GetProfessionLevel("Mining");
	ProfessionLevel_AddText(frame, levelReq, MiningLevel, "Mining ");
end	

function ProfessionLevel_AddHerbalismInfo(frame, itemName)
	local levelReq = HERBALISM_NODE_LEVEL[itemName];
	local HerbalismLevel = ProfessionLevel_GetProfessionLevel("Herbalism");
	ProfessionLevel_AddText(frame, levelReq, HerbalismLevel, "Herbalism ");
end

-- Experimental support for Lockpicking
function ProfessionLevel_AddLockpickingInfo(frame, itemName)
	local levelReq = LOCKPICKING_OBJECT_LEVEL[itemName];
	local LockpickingLevel = ProfessionLevel_GetProfessionLevel("Lockpicking");
	ProfessionLevel_AddText(frame, levelReq, LockpickingLevel, "Lockpicking ");
end

function ProfessionLevel_AddSkinningInfo(frame)
	local levelReq = UnitLevel("Mouseover");
	-- Bosses have a level of -1; actual skill required is max + 15
	if(levelReq == -1) then levelReq = 315;
	-- Mobs level 10 and below are clamped to a skill level of 1
	elseif(levelReq <= 10) then levelReq = 1;
	-- Mobs level 11-20 increase by 10 skill per level until 100
	elseif(levelReq <= 20) then levelReq = levelReq * 10 - 100;
	else levelReq = levelReq * 5; end
	if(levelReq > 0) then
		local SkinningLevel = ProfessionLevel_GetProfessionLevel("Skinning");
		ProfessionLevel_AddText(frame, levelReq, SkinningLevel, "Skinning ");
	end 	
end

function ProfessionLevel_AddText(frame, levelReq, profLevel, profName)
	if(profLevel == 0) then
		-- Don't have profession
		frame:AddLine(profName .. levelReq .. " Required", 1, 0, 0);
	elseif(levelReq + 100 <= profLevel) then
		-- Grey Skill
		frame:AddLine(profName .. levelReq, 0.5, 0.5, 0.5);
	elseif(levelReq + 50 <= profLevel) then
		-- Green skill
		frame:AddLine(profName .. levelReq, 0.25, 0.75, 0.25);
	elseif(levelReq + 25 <= profLevel) then
		-- Yellow skill
		frame:AddLine(profName .. levelReq, 1, 1, 0);
	elseif(levelReq <= profLevel) then
		-- Orange skill
		frame:AddLine(profName .. levelReq, 1, 0.5, 0.25);
	else
		-- Skill not high enough
		frame:AddLine(profName .. levelReq, 1, 0.125, 0.125);
	end
	frame:SetHeight(frame:GetHeight() + 14);
	if(frame:GetWidth() < 190) then frame:SetWidth(190); end
end

