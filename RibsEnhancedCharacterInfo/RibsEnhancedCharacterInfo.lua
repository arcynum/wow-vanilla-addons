-- Addon Name
local G_AddOn = "RibsEnhancedCharacterInfo";

-- Global scope variable.
EnhancedCharacterInfo = {

	-- General global variables.
	debug = true;
	currentClass = "";
	currentTalents = {};

	-- Player statistics
	G_STR;
	G_AGI;
	G_STAM;
	G_INT;
	G_SPI;
	G_CRIT;
	G_CRITDMG;

	types = {
		"STR", 			-- strength	
		"AGI", 			-- agility
		"STA", 			-- stamina
		"INT", 			-- intellect
		"SPI", 			-- spirit
		"ARMOR", 		-- reinforced armor (not base armor)
  
		"ARCANERES",	-- arcane resistance
		"FIRERES",  	-- fire resistance
		"NATURERES",	-- nature resistance 	
		"FROSTRES", 	-- frost resistance
		"SHADOWRES",	-- shadow resistance
	
		"FISHING",  	-- fishing skill
		"MINING",		-- mining skill
		"HERBALISM",	-- herbalism skill
		"SKINNING", 	-- skinning skill
		"DEFENSE",  	-- defense skill

		"BLOCK",    	-- chance to block
		"BLOCKVALUE",	-- increased block value
		"DODGE",		-- chance to dodge
		"PARRY",		-- chance to parry
		"ATTACKPOWER",	-- attack power
		"ATTACKPOWERUNDEAD", -- attack power against undead
		"ATTACKPOWERFERAL",  -- attack power in feral form
		
		"CRIT",			-- chance to get a critical strike
		"RANGEDATTACKPOWER", -- ranged attack power
		"RANGEDCRIT",	-- chance to get a crit with ranged weapons
		"TOHIT",		-- chance to hit

		"DMG",			-- spell damage
		"DMGUNDEAD",	-- spell damage against undead
		
		"ARCANEDMG",	-- arcane spell damage
		"FIREDMG",		-- fire spell damage
		"FROSTDMG",		-- frost spell damage
		"HOLYDMG",		-- holy spell damage
		"NATUREDMG",	-- nature spell damage
		"SHADOWDMG",	-- shadow spell damage
		"SPELLCRIT",	-- chance to crit with spells
		"HEAL",			-- healing 
		"HOLYCRIT", 	-- chance to crit with holy spells
		"SPELLTOHIT", 	-- Chance to Hit with spells

		"SPELLPEN", 	-- amount of spell resist reduction

		"HEALTHREG",	-- health regeneration per 5 sec.
		"MANAREG",		-- mana regeneration per 5 sec.
		"HEALTH",		-- health points
		"MANA",			-- mana points
	};

	slots = {
		"Head",
		"Neck",
		"Shoulder",
		"Shirt",
		"Chest",
		"Waist",
		"Legs",
		"Feet",
		"Wrist",
		"Hands",
		"Finger0",
		"Finger1",
		"Trinket0",
		"Trinket1",
		"Back",
		"MainHand",
		"SecondaryHand",
		"Ranged",
		"Tabard",
	};

};

-- Debug function
function EnhancedCharacterInfo:Debug(message)
	if (self.debug) then
		if (message ~= nil) then
			DEFAULT_CHAT_FRAME:AddMessage("|cffff0000" .. message);
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cffff0000" .. "Variable is nil");
		end
	end
end

-- String rounding
function EnhancedCharacterInfo:StatPrint(stat)
	self:Debug(string.format("%.2f", stat));
end

-- Find spell by name.
function EnhancedCharacterInfo:FindSpellIdByName(name)
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
function EnhancedCharacterInfo:PlayerLogin()
	DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff"..G_AddOn.."|cffffffff Loaded");

	-- Set the tooltip owner.
	EnhancedCharacterInfoTooltip:SetOwner(UIParent, "ANCHOR_NONE");

	-- Get the players class.
	_, self.currentClass = UnitClass("player");

	-- Wut
	stats = GetInventoryItemLink("player", 16);
	self:Debug(stats);

	-- Set the item slot thing.
	slotid, _ = GetInventorySlotInfo("HeadSlot");
	hasItem = EnhancedCharacterInfoTooltip:SetInventoryItem("player", slotid);

	self:ScanTooltip();

	-- Get the players base statistics
	self:GetCurrentStatistics();

	-- Generate the players talents
	self:TalentQuery();

	-- Calculate crit stats
	self:CalculateCrit();

	-- Apply the talent modifiers to the stats.
	self:ApplyTalentModifiers();

	-- Print out some of the stats.
	self:Debug(self.G_AGI);
	self:StatPrint(self.G_CRIT);
end

-- Function to get the base statistics of the player.
function EnhancedCharacterInfo:GetCurrentStatistics()
	_, self.G_STR, _, _ = UnitStat("player", 1);
	_, self.G_AGI, _, _ = UnitStat("player", 2);
	_, self.G_STAM, _, _ = UnitStat("player", 3);
	_, self.G_INT, _, _ = UnitStat("player", 4);
	_, self.G_SPI, _, _ = UnitStat("player", 5);
end

-- Calculate the crit chance depending on the class.
function EnhancedCharacterInfo:CalculateCrit()
	if (self.currentClass == "ROGUE") then
		self.G_CRIT = self.G_AGI / 29;
	elseif (self.currentClass == "HUNTER") then
		self.G_CRIT = self.G_AGI / 53;
	else
		self.G_CRIT = self.G_AGI / 20;
	end
end

-- Creates a lookup table with the characters current talents.
-- Need a event hook for when talents are changed to make sure the rates are adjusted.
function EnhancedCharacterInfo:TalentQuery()
	local numTabs = GetNumTalentTabs();
	for t = 1, numTabs do
		local numTalents = GetNumTalents(t);
		for i = 1, numTalents do
			nameTalent, _, _, _, currRank, _ = GetTalentInfo(t, i);
			self.currentTalents[nameTalent] = currRank;
		end
	end
end

-- Function which applies talent modifiers to the numbers.
function EnhancedCharacterInfo:ApplyTalentModifiers()
	if (self.currentClass == "HUNTER") then
		self:HunterTalentModifiers();
	end
end

-- Hunter talent modifiers
function EnhancedCharacterInfo:HunterTalentModifiers()
	self.G_CRIT = self.G_CRIT + self.currentTalents["Lethal Shots"];
end

function EnhancedCharacterInfo:ScanEquippedItems()
	for i, slotname in self.slots do
		slotid, _ = GetInventorySlotInfo(slotname.. "Slot");
		hasItem = BonusScannerTooltip:SetInventoryItem("player", slotid);
		if (hasItem) then
			self.temp.slot = slotname;
			BonusScanner:ScanTooltip();
			-- if set item, mark set as already scanned
			if (self.temp.set ~= "") then
				self.temp.sets[BonusScanner.temp.set] = 1;
			end;
		end
	end
end

-- Function for scanning toolips
function EnhancedCharacterInfo:ScanTooltip()
	local tmpTxt, line;
	local lines = EnhancedCharacterInfoTooltip:NumLines();
	for i = 2, lines, 1 do
		tmpText = getglobal("EnhancedCharacterInfoTooltipTextLeft"..i);
		val = nil;
		if (tmpText:GetText()) then
			line = tmpText:GetText();
			self:Debug(line);
		end
	end
end

-- Handle the OnLoad callbacks.
function EnhancedCharacterInfo:OnLoad()
	EnhancedCharacterInfoFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
	EnhancedCharacterInfoFrame:RegisterEvent("PLAYER_LEAVING_WORLD");
end

-- Handle the OnEvent callbacks.
function EnhancedCharacterInfo:OnEvent()
	if (event == "PLAYER_ENTERING_WORLD") then
		self:PlayerLogin();
	end
end