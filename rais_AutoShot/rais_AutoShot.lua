local G_AddOn = "rais_AutoShot"

-- Load the textures.
local Textures = {
	Bar = "Interface\\AddOns\\"..G_AddOn.."\\Textures\\Bar.tga",
}

-- Create a lookup table of positions and widths.
local Table = {
	["posX"] = 0;
	["posY"] = -235;
	["Width"] = 200;
	["Height"] = 15;
}

-- General global variables.
local DEBUG = true;
local G_CastStart = false;
local G_SwingStart = false;
local G_AimedStart = false;
local G_Shooting = false;
local G_PosX, G_PosY;
local G_InterruptTime;
local G_CastTime = 0.65;
local G_SwingTime;
local G_BerserkValue = false;
local G_SpellStartTime;
local G_SpellCoolDown = 0,0;
local G_OldSpellStartTime;
local G_AimedShotId = 0;
local G_AimedShotCastTime = 3;
local G_InCombat = false;

-- Override the real interface functions to handle handle extra tasks.
CoreUseAction = UseAction;
CoreCastSpell = CastSpell;
CoreCastSpellByName = CastSpellByName;

-- Core addon frame.
local Frame = CreateFrame("Frame");

-- Register the events we care about.
Frame:RegisterEvent("PLAYER_LOGIN");
Frame:RegisterEvent("SPELLCAST_STOP");
Frame:RegisterEvent("CURRENT_SPELL_CAST_CHANGED");
Frame:RegisterEvent("START_AUTOREPEAT_SPELL");
Frame:RegisterEvent("STOP_AUTOREPEAT_SPELL");
Frame:RegisterEvent("ITEM_LOCK_CHANGED");
Frame:RegisterEvent("PLAYER_REGEN_DISABLED");
Frame:RegisterEvent("PLAYER_REGEN_ENABLED");

-- Aimed tooltip frame.
local AimedTooltipFrame = CreateFrame("GameTooltip", "AimedTooltipFrame", UIParent, "GameTooltipTemplate");
AimedTooltipFrame:SetOwner(UIParent, "ANCHOR_NONE");

-- Extra frames.
local AutoShotTimerFrame;

-- Font String.
local AutoShotFontString;

-- Textures
local AutoShotOverlayTexture;

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

-- Function to create the autoshot bar.
local function CreateAutoShotBar()
	Debug("Creating autoshot bar");

	-- Calculate the table locations depending on the screen size.
	Table["posX"] = Table["posX"] * GetScreenWidth() / 1000;
	Table["posY"] = Table["posY"] * GetScreenHeight() / 1000;
	Table["Width"] = Table["Width"] * GetScreenWidth() / 1000;
	Table["Height"] = Table["Height"] * GetScreenHeight() / 1000;

	-- Create a timer frame.
	AutoShotTimerFrame = CreateFrame("Frame", "AutoShotTimerFrame", UIParent);
	AutoShotTimerFrame:SetFrameStrata("HIGH");
	AutoShotTimerFrame:SetWidth(Table["Width"]);
	AutoShotTimerFrame:SetHeight(Table["Height"]);
	AutoShotTimerFrame:SetPoint("CENTER", UIParent, "CENTER", Table["posX"], Table["posY"]);
	AutoShotTimerFrame:SetAlpha(0);

	-- Create a texture for the timer.
	AutoShotOverlayTexture = AutoShotTimerFrame:CreateTexture(nil, "OVERLAY");
	AutoShotOverlayTexture:SetHeight(Table["Height"]);
	AutoShotOverlayTexture:SetTexture(Textures.Bar);
	AutoShotOverlayTexture:SetPoint("LEFT", AutoShotTimerFrame, "LEFT");

	-- Create a text frame.
	AutoShotFontString = AutoShotTimerFrame:CreateFontString("AutoShotFontString", "OVERLAY");
	AutoShotFontString:SetPoint("CENTER", AutoShotTimerFrame, "CENTER");
	AutoShotFontString:SetWidth(Table["Width"]);
	AutoShotFontString:SetHeight(Table["Height"]);
	AutoShotFontString:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE");

	-- Create the background texture.
	local AutoShotArtworkTexture = AutoShotTimerFrame:CreateTexture(nil, "ARTWORK");
	AutoShotArtworkTexture:SetTexture(15/100, 15/100, 15/100, 1);
	AutoShotArtworkTexture:SetAllPoints(AutoShotTimerFrame);
	
	-- Create the border texture.
	local AutoShotBorderTexture = AutoShotTimerFrame:CreateTexture(nil, "BORDER");
	AutoShotBorderTexture:SetPoint("CENTER", AutoShotTimerFrame, "CENTER");
	AutoShotBorderTexture:SetWidth(Table["Width"] + 3);
	AutoShotBorderTexture:SetHeight(Table["Height"] + 3);
	AutoShotBorderTexture:SetTexture(0, 0, 0);
	
	-- Create the background border texture.
	local AutoShotBackgroundTexture = AutoShotTimerFrame:CreateTexture(nil, "BACKGROUND");
	AutoShotBackgroundTexture:SetPoint("CENTER", AutoShotTimerFrame, "CENTER");
	AutoShotBackgroundTexture:SetWidth(Table["Width"] + 6);
	AutoShotBackgroundTexture:SetHeight(Table["Height"] + 6);
	AutoShotBackgroundTexture:SetTexture(1, 1, 1);

end

-- Function which checks the global CD.
local function CheckGlobalCD()
	Debug("CheckGlobalCD");
	local serpentStingId = FindSpellIdByName("Serpent Sting");
	G_SpellStartTime, G_SpellCoolDown = GetSpellCooldown(serpentStingId, "BOOKTYPE_SPELL")
end

-- Function to manage when casting has started.
-- This makes the bar red. Meaning that the cast of the shot has started.
local function Cast_Start()
	Debug("Cast_Start");
	AutoShotOverlayTexture:SetVertexColor(1, 0, 0);
	AutoShotFontString:SetText("Casting");
	G_PosX, G_PosY = GetPlayerMapPosition("player");
	G_CastStart = GetTime();
end

-- Function to manage cast updates.
local function Cast_Update()
	local relative = GetTime() - G_CastStart
	if (relative > G_CastTime) then
		G_CastStart = false;
	elseif (G_SwingStart == false) then
		AutoShotOverlayTexture:SetWidth(Table["Width"] * relative / G_CastTime);
	end
end

-- Function to manage cast interrupts.
local function Cast_Interrupted()
	Debug("Cast_Interrupted");
	G_SwingStart = false;
	Cast_Start();
end

-- Function to manage auto shot starting.
local function Shot_Start()
	Debug("Shot_Start");
	Cast_Start();
	G_Shooting = true;
end

-- Function to manage auto shot ending.
local function Shot_End()
	Debug("Shot_End");
	G_CastStart = false;
	G_Shooting = false;
end

-- Function to manage swing starting.
-- This makes the bar red. Meaning that the swing has started.
local function Swing_Start()
	Debug("Swing_Start");
	G_SwingTime = UnitRangedDamage("player") - G_CastTime;
	AutoShotFontString:SetText("Swinging");
	AutoShotOverlayTexture:SetVertexColor(1, 1, 1);
	G_CastStart = false;
	G_SwingStart = GetTime();
end

-- Function to get the Aimed Shot ID.
local function GetAimedShotId()
	G_AimedShotId = FindSpellIdByName("Aimed Shot");
end

-- Function for when aimed shot has started.
local function Aimed_Start()
	Debug("Aimed_Start");

	-- Check if Aimed Shot is still on cooldown.
	local aimedShotId = FindSpellIdByName("Aimed Shot");
	local startTime, cooldown = GetSpellCooldown(aimedShotId, "BOOKTYPE_SPELL");

	if (startTime == 0 and cooldown == 0) then
		G_AimedStart = GetTime();
		G_CastStart = false;

		for i = 1, 32 do
			if UnitBuff("player", i) == "Interface\\Icons\\Ability_Warrior_InnerRage" then
				G_AimedShotCastTime = G_AimedShotCastTime / 1.3;
			end
			if UnitBuff("player", i) == "Interface\\Icons\\Ability_Hunter_RunningShot" then
				G_AimedShotCastTime = G_AimedShotCastTime / 1.4;
			end
			if UnitBuff("player", i) == "Interface\\Icons\\Racial_Troll_Berserk" then
				G_AimedShotCastTime = G_AimedShotCastTime / (1 + G_BerserkValue);
			end
			if UnitBuff("player", i) == "Interface\\Icons\\Inv_Trinket_Naxxramas04" then
				G_AimedShotCastTime = G_AimedShotCastTime / 1.2;
			end
		end
	end

end

-- Function which override the UseAction function.
-- This intercepts the aimed shot cast.
function UseAction(slot, checkFlags, checkSelf)
	Debug("UseAction");
	AimedTooltipFrame:ClearLines();
	AimedTooltipFrame:SetAction(slot);
	local spellName = AimedTooltipFrameTextLeft1:GetText();
	if (spellName == "Aimed Shot") then
		Aimed_Start();
	end
	CoreUseAction(slot, checkFlags, checkSelf);
end

-- Function which override the CastSpell function.
-- This checks for casted things which are Aimed Shot.
function CastSpell(spellID, spellTab)
	Debug("CastSpell");
	GetAimedShotId();
	if (spellID == G_AimedShotId and spellTab == "BOOKTYPE_SPELL") then
		Aimed_Start();
	end
	CoreCastSpell(spellID, spellTab);
end

-- Function which override the CastSpellByName function.
-- This checks for casted things which are called Aimed Shot.
function CastSpellByName(spellName)
	Debug("CastSpellByName");
	if (spellName == "Aimed Shot") then
		Aimed_Start();
	end
	CoreCastSpellByName(spellName);
end

-- Function to handle the player login event.
local function PlayerLogin()
	CreateAutoShotBar();
	DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff"..G_AddOn.."|cffffffff Loaded");
end

-- Function to handle the spellcast stop event.
local function SpellcastStop()
	Debug("SpellcastStop");
	if (G_AimedStart ~= false) then
		G_AimedStart = false;
	end
	CheckGlobalCD();
	if (G_SpellCoolDown == 1.5) then
		G_OldSpellStartTime = G_SpellStartTime;
	end
end

-- Function to handle the current spell cast changed event.
local function CurrentSpellCastChanged()
	if (G_SwingStart == false and G_AimedStart == false) then
		G_InterruptTime = GetTime();
		Cast_Interrupted();
	end
end

-- Function to handle the item lock changed event.
local function ItemLockChanged()
	if (G_Shooting == true) then 
		CheckGlobalCD();
		if (G_AimedStart ~= false) then
			Cast_Start();
		elseif (G_SpellCoolDown ~= 1.5) then
			Swing_Start();
		elseif (G_OldSpellStartTime == G_SpellStartTime) then
			Swing_Start();
		else
			G_OldSpellStartTime = G_SpellStartTime;
		end
	end
end

-- Function called from the event.
local function UnitAura()
	for i = 1, 16 do
		if (UnitBuff("player", i) == "Interface\\Icons\\Racial_Troll_Berserk") then
			if (G_BerserkValue == false) then
				if ((UnitHealth("player") / UnitHealthMax("player")) >= 0.40) then
					G_BerserkValue = (1.30 - (UnitHealth("player") / UnitHealthMax("player"))) / 3;
				else
					G_BerserkValue = 0.30;
				end
			end
		else
			G_BerserkValue = false;
		end
	end
end

-- Function which is called when combat starts
local function CombatStarted()
	Debug("CombatStarted");
	G_InCombat = true;
	AutoShotTimerFrame:SetAlpha(1);
end

-- Function which is called when combat ends
local function CombatEnded()
	Debug("CombatEnded");
	G_InCombat = false;
	AutoShotTimerFrame:SetAlpha(0);
end

-- Handle the OnEvent callbacks.
local function AutoShotOnEvent()

	-- Capture the player login event.
	if (event == "PLAYER_LOGIN") then
		PlayerLogin();

	elseif (event == "PLAYER_REGEN_DISABLED") then
		CombatStarted();

	elseif (event == "PLAYER_REGEN_ENABLED") then
		CombatEnded();

	-- Capture the auto shot starting.
	elseif (event == "START_AUTOREPEAT_SPELL") then
		Shot_Start();

	-- Capture the auto shot ending.
	elseif (event == "STOP_AUTOREPEAT_SPELL") then
		Shot_End();

	-- Capture the spellcast stop event.
	elseif (event == "SPELLCAST_STOP") then
		SpellcastStop();

	-- Capture the current spell changed event.
	elseif (event == "CURRENT_SPELL_CAST_CHANGED") then
		CurrentSpellCastChanged();

	-- Capture the item lock changed event.
	elseif (event == "ITEM_LOCK_CHANGED") then
		ItemLockChanged();

	-- Capture the unit aura event.
	elseif (event == "UNIT_AURA") then
		UnitAura();
	end
end

-- Handle the OnEvent callbacks.
local function AutoShotOnUpdate()

	-- Currently auto-shotting.
	if (G_Shooting == true) then
		if (G_CastStart ~= false) then
			-- Get the players position.
			local currentPlayerPosX, currentPlayerPosY = GetPlayerMapPosition("player");
			-- If the player hasn't moved, updated. Otherwise interrupted.
			if (G_PosX == currentPlayerPosX and G_PosY == currentPlayerPosY) then
				Cast_Update();
			else
				Cast_Interrupted();
			end
		end
	end

	-- Currently swinging
	if (G_SwingStart ~= false) then
		-- Get the time since the swing started.
		local relative = GetTime() - G_SwingStart;
		-- Set the texture to be a percent of the swing.
		AutoShotOverlayTexture:SetWidth(Table["Width"] * relative / G_SwingTime);
		-- If the time since the swing started is now longer than the swing start time.
		if (relative > G_SwingTime) then
			-- If im shooting, but its not aimed shot then cast start.
			if (G_Shooting == true and G_AimedStart == false) then
				Cast_Start();
			else
				AutoShotOverlayTexture:SetWidth(0);
			end
			G_SwingStart = false;
		end
	end

end

-- Register the frame to handle the event and update events.
Frame:SetScript("OnEvent", AutoShotOnEvent);
Frame:SetScript("OnUpdate", AutoShotOnUpdate);