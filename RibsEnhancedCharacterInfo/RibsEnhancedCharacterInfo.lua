local G_AddOn = "RibsEnhancedCharacterInfo"

-- General global variables.
local DEBUG = true;

-- Core addon frame.
local Frame = CreateFrame("Frame");

-- Register the events we care about.
Frame:RegisterEvent("PLAYER_LOGIN");

-- Debug function
local function Debug(message)
	if (DEBUG == true) then
		DEFAULT_CHAT_FRAME:AddMessage("|cffff0000"..message);
	end
end

-- Find spell by name.
local function FindSpellIdByName(name)
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
local function PlayerLogin()
	DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff"..G_AddOn.."|cffffffff Loaded");

	local _, str, _, _ = UnitStat("player", 1);
	local _, agi, _, _ = UnitStat("player", 2);
	local _, stam, _, _ = UnitStat("player", 3);
	local _, int, _, _ = UnitStat("player", 4);
	local _, spi, _, _ = UnitStat("player", 5);

	Debug(agi);
	Debug(agi / 53);
end

-- Handle the OnEvent callbacks.
local function OnEvent()

	-- Capture the player login event.
	if (event == "PLAYER_LOGIN") then
		PlayerLogin();
	end

end

-- Register the frame to handle the event and update events.
Frame:SetScript("OnEvent", OnEvent);