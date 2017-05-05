----------------------------------------------------------------
--	ProfessionLevel 1.1
--	Adds gathering profession level requirements to the tooltip
--	Original addon developed by Dae

--	Version 1.1
--		Fixed mining node names and levels
--		Fixed herbalism node names and levels
--		Added skill colors
--	Known issues:
--		Does not show info when mouseover multiple minimap objects at once
----------------------------------------------------------------


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

function ProfessionLevel_OnShow()
    local parentFrame = this:GetParent();
    local parentFrameName = parentFrame:GetName();
    local itemName = getglobal(parentFrameName.."TextLeft1"):GetText();
    
    if(MINING_NODE_LEVEL[itemName]) then
    	ProfessionLevel_AddMiningInfo(parentFrame, itemName);
    end
    
    if(HERBALISM_NODE_LEVEL[itemName]) then
    	ProfessionLevel_AddHerbalismInfo(parentFrame, itemName);
    end
    
    if(ProfessionLevel_IsSkinnable()) then
		ProfessionLevel_AddSkinningInfo(parentFrame);
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

function ProfessionLevel_AddMiningInfo(frame, itemname)
    local levelreq = MINING_NODE_LEVEL[itemname];
    local MiningLevel = ProfessionLevel_GetProfessionLevel("Mining");
    ProfessionLevel_AddInfo(frame, levelreq, MiningLevel, "Mining ");
end    

function ProfessionLevel_AddHerbalismInfo(frame, itemname)
    local levelreq = HERBALISM_NODE_LEVEL[itemname];
    local HerbalismLevel = ProfessionLevel_GetProfessionLevel("Herbalism");
	ProfessionLevel_AddInfo(frame, levelreq, HerbalismLevel, "Herbalism ");
end

function ProfessionLevel_AddSkinningInfo(frame)
    local levelreq = 5 * UnitLevel("Mouseover");
	-- Mobs level 10 and below are clamped to a skill level of 1
    if(levelreq < 100) then levelreq = 1; end
    if(levelreq > 0) then
		local SkinningLevel = ProfessionLevel_GetProfessionLevel("Skinning");
    	ProfessionLevel_AddInfo(frame, levelreq, SkinningLevel, "Skinning ");
   end 	
end

function ProfessionLevel_IsSkinnable()
    for c = 1, GameTooltip:NumLines() do
        local line = getglobal("GameTooltipTextLeft"..c);
        if(line and line:GetText() == "Skinnable") then return true; end
    end
    return false;
end

function ProfessionLevel_AddInfo(frame, levelreq, proflevel, profname)
	if(proflevel == 0) then
		-- Don't have profession
		frame:AddLine(profname .. levelreq.." Required", 1, 0, 0);
	elseif(levelreq + 100 <= proflevel) then
		-- Grey Skill
		frame:AddLine(profname .. levelreq, 0.5, 0.5, 0.5);
	elseif(levelreq + 50 <= proflevel) then
		-- Green skill
		frame:AddLine(profname .. levelreq, 0.25, 0.75, 0.25);
	elseif(levelreq + 25 <= proflevel) then
		-- Yellow skill
		frame:AddLine(profname .. levelreq, 1, 1, 0);
	elseif(levelreq <= proflevel) then
		-- Orange skill
		frame:AddLine(profname .. levelreq, 1, 0.5, 0.25);
	else
		-- Skill not high enough
		frame:AddLine(profname .. levelreq, 1, 0.125, 0.125);
	end
	frame:SetHeight(frame:GetHeight() + 14);
	frame:SetWidth(190);
end

