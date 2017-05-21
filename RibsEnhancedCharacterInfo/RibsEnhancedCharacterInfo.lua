local G_AddOn = "RibsEnhancedCharacterInfo"

-- General global variables.
local DEBUG = true;
local G_CurrentClass;
local G_CurrentTalents = {};

-- Global Stats
local G_STR, G_AGI, G_STAM, G_INT, G_SPI;
local G_CRIT, G_CRITDMG;

-- Core addon frame.
local Frame = CreateFrame("Frame");

-- Register the events we care about.
Frame:RegisterEvent("PLAYER_LOGIN");

-- Debug function
function Debug(message)
	if (DEBUG == true) then
		DEFAULT_CHAT_FRAME:AddMessage("|cffff0000"..message);
	end
end

-- String rounding
function StatPrint(stat)
	Debug(string.format("%.2f", stat));
end

-- Find spell by name.
function FindSpellIdByName(name)
	-- Get the spell tab information.
	local _, _, offset, numSpells = GetSpellTabInfo(GetNumSpellTabs());
	-- Calculate the total number of spells.
	local totalSpells = offset + numSpells;
	for i = 1, totalSpells do
		spellName = GetSpellName(i, "BOOKTYPE_SPELL");
		if (spellName == name) then
			return i;
		end
	end
end

-- Function to handle the player login event.
function PlayerLogin()
	DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff"..G_AddOn.."|cffffffff Loaded");

	-- Get the players class.
	_, G_CurrentClass = UnitClass("player");

	-- Get the players base statistics
	G_STR, G_AGI, G_STAM, G_INT, G_SPI = GetCurrentStatistics();

	-- Generate the players talents
	TalentQuery();

	-- Calculate crit stats
	CalculateCrit();

	-- Apply the talent modifiers to the stats.
	ApplyTalentModifiers();

	-- Print out some of the stats.
	Debug(G_AGI);
	StatPrint(G_CRIT);
end

-- Function to get the base statistics of the player.
function GetCurrentStatistics()
	_, str, _, _ = UnitStat("player", 1);
	_, agi, _, _ = UnitStat("player", 2);
	_, stam, _, _ = UnitStat("player", 3);
	_, int, _, _ = UnitStat("player", 4);
	_, spi, _, _ = UnitStat("player", 5);
	return str, agi, stam, int, spi;
end

-- Calculate the crit chance depending on the class.
function CalculateCrit()
	if (G_CurrentClass == "ROGUE") then
		G_CRIT = G_AGI / 29;
	elseif (G_CurrentClass == "HUNTER") then
		G_CRIT = G_AGI / 53;
	else
		G_CRIT = G_AGI / 20;
	end
end

-- Creates a lookup table with the characters current talents.
-- Need a event hook for when talents are changed to make sure the rates are adjusted.
function TalentQuery()
	local numTabs = GetNumTalentTabs();
	for t = 1, numTabs do
		local numTalents = GetNumTalents(t);
		for i = 1, numTalents do
			nameTalent, _, _, _, currRank, _ = GetTalentInfo(t, i);
			G_CurrentTalents[nameTalent] = currRank;
		end
	end
end

-- Function which applies talent modifiers to the numbers.
function ApplyTalentModifiers()
	if (G_CurrentClass == "HUNTER") then
		HunterTalentModifiers();
	end
end

-- Hunter talent modifiers
function HunterTalentModifiers()
	G_CRIT = G_CRIT + G_CurrentTalents["Lethal Shots"];
end

-- Handle the OnEvent callbacks.
function OnEvent()

	-- Capture the player login event.
	if (event == "PLAYER_LOGIN") then
		PlayerLogin();
	end

end

-- Register the frame to handle the event and update events.
Frame:SetScript("OnEvent", OnEvent);