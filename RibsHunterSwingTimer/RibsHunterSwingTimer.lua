local G_AddOn = "RibsHunterSwingTimer"

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
local DEBUG = false;
local G_SwingStart = false;
local G_Shooting = false;
local G_PosX, G_PosY;
local G_InterruptTime;
local G_SwingTime;
local G_InCombat = false;

-- Core addon frame.
local Frame = CreateFrame("Frame");

-- Register the events we care about.
Frame:RegisterEvent("PLAYER_LOGIN");
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
	AutoShotFontString:SetTextColor(1.0, 1.0, 1.0, 1.0);

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

-- Function to manage auto shot starting.
local function ShotStart()
	Debug("Shot Start");
	G_Shooting = true;
end

-- Function to manage auto shot ending.
local function ShotEnd()
	Debug("Shot End");
	G_Shooting = false;
	AutoShotFontString:SetText("");
	AutoShotFontString:SetTextColor(1.0, 1.0, 1.0, 1.0);
end

-- Function to manage swing starting.
-- This makes the bar red. Meaning that the swing has started.
local function SwingStart()
	Debug("Swing Start");
	G_SwingTime = UnitRangedDamage("player");
	AutoShotOverlayTexture:SetVertexColor(1, 1, 1);
	G_SwingStart = GetTime();
end

-- Function to handle the player login event.
local function PlayerLogin()
	CreateAutoShotBar();
	DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff"..G_AddOn.."|cffffffff Loaded");
end

-- Function to handle the item lock changed event.
local function ItemLockChanged()
	if (G_Shooting == true) then
		SwingStart();
	end
end

-- Function which is called when combat starts
local function CombatStarted()
	Debug("Combat Started");
	G_InCombat = true;
	AutoShotTimerFrame:SetAlpha(1);
end

-- Function which is called when combat ends
local function CombatEnded()
	Debug("Combat Ended");
	G_InCombat = false;
	AutoShotTimerFrame:SetAlpha(0);
end

-- Handle the OnEvent callbacks.
local function AutoShotOnEvent()

	-- Capture the player login event.
	if (event == "PLAYER_LOGIN") then
		PlayerLogin();

	-- Player has entered combat.
	elseif (event == "PLAYER_REGEN_DISABLED") then
		CombatStarted();

	-- Player has left combat.
	elseif (event == "PLAYER_REGEN_ENABLED") then
		CombatEnded();

	-- Capture the auto shot starting.
	elseif (event == "START_AUTOREPEAT_SPELL") then
		ShotStart();

	-- Capture the auto shot ending.
	elseif (event == "STOP_AUTOREPEAT_SPELL") then
		ShotEnd();

	-- Capture the item lock changed event.
	elseif (event == "ITEM_LOCK_CHANGED") then
		ItemLockChanged();

	end
end

-- Handle the OnEvent callbacks.
local function AutoShotOnUpdate()

	-- Currently swinging
	if (G_SwingStart ~= false) then
		-- Get the time since the swing started.
		local relative = GetTime() - G_SwingStart;

		if (relative <= 0.5) then
			AutoShotFontString:SetTextColor(0, 1.0, 0, 1.0);
			AutoShotFontString:SetText("Aimed Shot Now");
		else
			AutoShotFontString:SetTextColor(1.0, 0, 0, 1.0);
			AutoShotFontString:SetText("Wait");
		end

		-- Set the texture to be a percent of the swing.
		AutoShotOverlayTexture:SetWidth(Table["Width"] * relative / G_SwingTime);

		-- If the time since the swing started is now longer than the swing start time.
		if (relative > G_SwingTime) then
			AutoShotOverlayTexture:SetWidth(0);
			G_SwingStart = false;
		end
	end

end

-- Register the frame to handle the event and update events.
Frame:SetScript("OnEvent", AutoShotOnEvent);
Frame:SetScript("OnUpdate", AutoShotOnUpdate);