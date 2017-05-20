--[[ AutoProfit: Automatically vendors grey items
Original addon developed by Jason Allen
Updated and improved for WoW 1.12 by Beegee

Version 3.1:
	Added option to automatically vendor greys upon talking to a merchant
	Added option to announce vendored items
	Added option to reset AutoProfit to defaults
Version 3.0:
	Added a delay between vendoring items to avoid server rate limits
Known Issues:
	Holding a modifier key (SHIFT or CTRL) prevents items from being sold
]]

-- Global constants
local AUTOPROFIT_DELAY = 0.08;
local AUTOPROFIT_VERSION = "v3.1";
local COPPER = "|c00CC9900";
local SILVER = "|c00C0C0C0";
local GOLD = "|c00FFFF66";
local RED = "|c00FF0000";
local GREEN = "|c0000FF00";
local AP = "|c00bfffff";

-- Private global variables
local G_Time = GetTime();
local G_WaitFrame = nil;

-- Print to chatbox
local function print(msg) DEFAULT_CHAT_FRAME:AddMessage(msg, 0, .8, 1); end

-- Default exceptions list
local DefaultExceptions = {
	["Small Furry Paw"] = "",
	["Torn Bear Pelt"] = "",
	["Soft Bushy Tail"] = "",
	["Vibrant Plume"] = "",
	["Evil Bat Eye"] = "",
	["Glowing Scorpid Blood"] = ""
}

-- Public global variables
totalProfit = 0;
totalSold = 0;
rotation = 0;
rotrate = 0;
merchantClosed = true;

-- SavedVariables
AutoProfit = {
	Exceptions = { },
	Announce = false,
	AutoVendor = true
}


-- Registers events and slash commands
function AutoProfit_OnLoad()
	SLASH_AUTOPROFIT1 = "/autoprofit";
	SLASH_AUTOPROFIT2 = "/ap";
	SlashCmdList["AUTOPROFIT"] = AutoProfit_SlashCmd;
	this:RegisterEvent("MERCHANT_SHOW");
	this:RegisterEvent("MERCHANT_CLOSED");
	print(AP.."AutoProfit|r "..AUTOPROFIT_VERSION.." loaded.");
end

-- Captures the MERCHANT_SHOW and MERCHANT_CLOSED events
function AutoProfit_OnEvent(event)
	if (event == "MERCHANT_SHOW") then
		AutoProfit_Calculate();
		merchantClosed = false;
		if (totalProfit > 0 and AutoProfit.AutoVendor) then
			AutoProfit_SellJunk({0, 1});
		end
	elseif (event == "MERCHANT_CLOSED") then
		merchantClosed = true;
	end
end

-- Searches through bags to find junk items
-- args[1], Current bag (zero-index)
-- args[2], Current bag slot (one-index)
function AutoProfit_SellJunk(args)
	for bag = args[1], 4 do
		if GetContainerNumSlots(bag) > 0 then
			for slot = args[2], GetContainerNumSlots(bag) do
				if (merchantClosed == true) then AutoProfit_Sold(); return; end
				local texture, itemCount, locked, quality = GetContainerItemInfo(bag, slot);
				if (quality == 0) then
					local result = AutoSeller_ProcessLink(GetContainerItemLink(bag, slot));
					if (result > 0) then AutoProfit_SellItem(bag, slot); return; end
				elseif (quality == -1) then
					local linkcolor = AutoSeller_ProcessLink(GetContainerItemLink(bag, slot));
					if (linkcolor == 1) then AutoProfit_SellItem(bag, slot); return; end
				end
			end
			args[2] = 0; -- Reset current bag slot
		end
	end
	AutoProfit_Sold();
end

-- Sells an item
function AutoProfit_SellItem(bag, slot)
	PickupContainerItem(bag, slot);
	MerchantItemButton_OnClick("LeftButton");
	totalSold = totalSold + 1;
	if (AutoProfit.Announce) then print(AP.."AutoProfit|r: Sold "..GetContainerItemLink(bag, slot)); end

	-- Don't continue after last slot in final bag
	if (bag == 4 and slot == GetContainerNumSlots(bag)) then AutoProfit_Sold(); return; end

	-- Delay searching for next grey to avoid rate limits
	AutoProfit_Wait(AUTOPROFIT_DELAY, AutoProfit_SellJunk, bag, slot + 1);
end

function AutoProfit_Sold()
	local s = "";
	if (totalSold > 1) then s = "s"; end
	if (totalProfit > 0) then
		print(AP.."AutoProfit|r: Sold "..totalSold.." item"..s.." for "..profitString(totalProfit));
	end
	totalProfit = 0;
	totalSold = 0;
	rotrate = 0;
end

function AutoProfit_Calculate()
	for bag = 0, 4 do
		if GetContainerNumSlots(bag) > 0 then
			for slot = 0, GetContainerNumSlots(bag) do
				local texture, itemCount, locked, quality = GetContainerItemInfo(bag, slot);
				if (quality == 0) then
					local result = AutoSeller_ProcessLink(GetContainerItemLink(bag, slot));
					if (result > 0) then AutoProfit_Tooltip:SetBagItem(bag, slot); end
				elseif (quality == -1) then
					local linkcolor = AutoSeller_ProcessLink(GetContainerItemLink(bag, slot));
					if (linkcolor == 1) then AutoProfit_Tooltip:SetBagItem(bag, slot); end
				end
			end
		end
	end
end

function AutoProfit_AddCoin()
	if (arg1) then
		totalProfit = totalProfit + arg1;
	end
end

function AutoProfit_RotateModel(elapsed)
	if (rotrate > 0) then rotation = rotation + (elapsed * rotrate); end
	TreasureModel:SetRotation(rotation);
end;


function AutoProfit_SlashCmd(msg)
	--No switch statement in Lua? Lots of ugly if's to follow.
	if(not msg or msg == "" or msg == "help" or msg == "?") then
		print(AP.."AutoProfit|r "..AUTOPROFIT_VERSION.." commands:");
		print(AP.."/autoprofit [item link]|r: Add or Remove an item to the exception list.");
		print(AP.."/autoprofit list|r: List all items on your exception list.");
		print(AP.."/autoprofit [number]|r: Remove item at that location in your exception list.");
		print(AP.."/autoprofit purge|r: Remove all items from your exception list.");
		print(AP.."/autoprofit announce|r: Toggle chat output of vendored items ("..enabledString(AutoProfit.Announce)..").");
		print(AP.."/autoprofit autovendor|r: Toggle automatic vendoring of greys ("..enabledString(AutoProfit.AutoVendor)..").");
		print(AP.."/autoprofit reset|r: Resets AutoProfit to default settings.");
		return;
	end

	if (msg == "purge") then
		AutoProfit.Exceptions = { };
		print(AP.."AutoProfit|r: Deleted all exceptions.");
		return;
	elseif (msg == "list") then
		if (table.getn(AutoProfit.Exceptions) > 0) then
			print("AutoProfit Exceptions: ");
			for i = 1, table.getn(AutoProfit.Exceptions) do
				print("[|c00bfffff"..i.."|r] "..AutoProfit.Exceptions[i]);
			end
		else
			print(AP.."AutoProfit|r: Your exceptions list is empty.");
		end
		return;
	elseif (msg == "announce") then
		if (AutoProfit.Announce) then
			AutoProfit.Announce = false;
		else
			AutoProfit.Announce = true;
		end
		print(AP.."AutoProfit|r: announcing is "..enabledString(AutoProfit.Announce)..".");
	elseif (msg == "autovendor") then
		if (AutoProfit.AutoVendor) then
			AutoProfit.AutoVendor = false;
		else
			AutoProfit.AutoVendor = true;
		end
		print(AP.."AutoProfit|r: automatic vendoring "..enabledString(AutoProfit.AutoVendor)..".");
	elseif (msg == "reset") then
		AutoProfit = {
			Exceptions = { },
			Announce = false,
			AutoVendor = true
		}
		print(AP.."AutoProfit|r: settings have been reset.");
	end
	
	if (string.len(msg) < 5) then
		if (tonumber(msg) == nil) then return; end
		if (tonumber(msg) > table.getn(AutoProfit.Exceptions)) then 
			return;
		else
			print(AP.."AutoProfit|r: Removed "..AutoProfit.Exceptions[tonumber(msg)].." from exceptions list.");
			table.remove(AutoProfit.Exceptions, tonumber(msg));
			return;
		end
	end
		
	if (string.find(msg, "Hitem:") == nil) then return; end
	
	local removed = 0;
	
	if (table.getn(AutoProfit.Exceptions) > 0) then	
		for i = 1, table.getn(AutoProfit.Exceptions) do
			if (msg == AutoProfit.Exceptions[i]) then
				print(AP.."AutoProfit|r: Removed "..AutoProfit.Exceptions[i].." from exceptions list.");
				table.remove(AutoProfit.Exceptions, i);
				removed = 1;
			end
		end
	end
	
	if (removed == 0) then
		table.insert(AutoProfit.Exceptions, msg);
		print(AP.."AutoProfit|r: Added "..msg.." to exceptions list.");
	end
end


function AutoSeller_ProcessLink(link)
	local color;
	local item;
	local name;
	
	for color, item, name in string.gfind(link, "|c(%x+)|Hitem:(%d+:%d+:%d+:%d+)|h%[(.-)%]|h|r") do
		--This prevents Dark Moon Faire items from being sold to the vendor.
		if (DefaultExceptions[name]) then return 0; end		
		
		if (color == "ff9d9d9d") then
			for i = 1, table.getn(AutoProfit.Exceptions) do
				if (link == AutoProfit.Exceptions[i]) then return 0; end
			end
			return 1;
		end
		
		if (color == "ffffffff") then
			for i = 1, table.getn(AutoProfit.Exceptions) do
				if (link == AutoProfit.Exceptions[i]) then return 1; end
			end
			return 0;
		end
		
		return 0;
	end
end

-- Waits for `delay` to execute `func` with optional parameters
function AutoProfit_Wait(delay, func, ...)
	if(type(delay) ~= "number" or type(func) ~= "function") then return; end
	if(G_WaitFrame == nil) then
		G_WaitFrame = CreateFrame("Frame", "AutoProfitWaitFrame", UIParent);
		G_WaitFrame:SetScript("onUpdate",function (self, elapse)
		if(GetTime() - G_Time >= delay) then
				G_WaitFrame:Hide();
				G_WaitFrame = nil;
				func(arg);
				return;
			end
		end);
	end
	G_Time = GetTime();
end

-- Returns a string representation of `total` in gold, silver, and copper.
function profitString(total)
	if (total == 0) then return COPPER.."0c"; end
	
	local str = "";
	local gold, silver, copper;

	copper = mod(floor(total + .5), 100);
	silver = mod(floor(total / 100), 100);
	gold = mod(floor(total / 100000), 100);
	 
	if (gold > 0) then str = GOLD..gold.."g" end;

	if (silver > 0) then
		if (str ~= "") then str = str.." " end;
		str = str..SILVER..silver.."s";
	end;

	if (copper > 0) then
		if (str ~= "") then str = str.." " end;
		str = str..COPPER..copper.."c";
	end;

	return str;
end

-- Returns a string 'enabled' or 'disabled'.
function enabledString(bool)
	if (bool) then
		return GREEN.."enabled|r";
	else
		return RED.."disabled|r";
	end
end