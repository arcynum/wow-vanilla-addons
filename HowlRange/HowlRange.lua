
HowlRangeFrame = CreateFrame("FRAME", "HowlRangeFrame");
HowlRangeFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
HowlRangeFrame:RegisterEvent("PLAYER_LEAVING_WORLD");

function HowlRange_OnEvent(self, event, ...)
	print("Hello World! Hello " .. event);
	DEFAULT_CHAT_FRAME:AddMessage("Hello World! Hello " .. event);
end

function HowlRange_OnUpdate(elapsed)

end

function HowlRange_RegisterEvents()
	-- HowlRangeFrame:RegisterEvent("ITEM_LOCK_CHANGED");
	-- HowlRangeFrame:RegisterEvent("PLAYER_DEAD");
end

function HowlRange_UnregisterEvents()
	-- HowlRangeFrame:UnregisterEvent("ITEM_LOCK_CHANGED");
	-- HowlRangeFrame:UnregisterEvent("PLAYER_DEAD");
end

function HowlRange_Print(text)
	DEFAULT_CHAT_FRAME:AddMessage(text);
end

HowlRangeFrame:SetScript("OnEvent", HowlRange_OnEvent);
HowlRangeFrame:SetScript("OnUpdate", HowlRange_OnUpdate);

-- function HowlRange:OnInitialize()
-- 	self:Print("HowlRange OnInitialize")
-- end

-- function HowlRange:OnEnable()
-- 	self:Print("HowlRange OnEnable")
-- 	self:ScheduleRepeatingEvent('HowlRange_Scan', self.CheckPetDistance, 5, self)
-- end

-- function HowlRange:OnDisable()
-- 	self:Print("HowlRange OnDisable")
-- end

-- function HowlRange:CheckPetDistance()
-- 	local playerLocation = GetPlayerMapPosition("player")
-- 	local petLocation = GetPlayerMapPosition("pet")
-- 	self:GetDistance(playerLocation, petLocation)
-- end

-- function HowlRange:GetDistance(player, pet)
-- 	self:Print(string.format("%d : %d", player, pet))
-- end