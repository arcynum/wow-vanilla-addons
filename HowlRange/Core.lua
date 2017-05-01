function HowlRange:OnInitialize()
	self:Print("HowlRange OnInitialize")
end

function HowlRange:OnEnable()
	self:Print("HowlRange OnEnable")
	self:ScheduleRepeatingEvent('HowlRange_Scan', self.CheckPetDistance, 5, self)
end

function HowlRange:OnDisable()
	self:Print("HowlRange OnDisable")
end

function HowlRange:CheckPetDistance()
	local playerLocation = GetPlayerMapPosition("player")
	local petLocation = GetPlayerMapPosition("pet")
	self:GetDistance(playerLocation, petLocation)
end

function HowlRange:GetDistance(player, pet)
	self:Print(string.format("%d : %d", player, pet))
end