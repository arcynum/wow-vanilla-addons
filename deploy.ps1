param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$wow=$(throw "WoW folder is mandatory, please provide a value.")
)

$WOW_FOLDER=$wow;
$INTERFACE_FOLDER="Interface\AddOns";
$ADDONS_PATH="${WOW_FOLDER}" + "\\" + "${INTERFACE_FOLDER}";
$REPO_PATH = (Get-Item -Path ".\" -Verbose).FullName;

Write-Host "Removing old addons.";
Remove-Item "${ADDONS_PATH}\\*" -Recurse -Force;

Write-Host "Copying updated addons.";
Copy-Item -Path "${REPO_PATH}\\!ImprovedErrorFrame" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\!OmniCC" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\Ace" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\Ace2" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\AdvancedTradeSkillWindow" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\Atlas" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\AtlasLoot" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\AtlasQuest" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\Auctioneer" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\AutoAttack" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\AutoMate" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\AutoProfit" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\AutoRepair" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\AutoSave" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\Aux-Addon" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\Banknon" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\Bartender2" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\BeanCounter" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\BigWigs" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\BonusScanner" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\BuddySync" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\Cartographer" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\CastingBarTime" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\CEPGP" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\CEnemyCastBar" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\ChatLog" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\Clean_Up" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\CritLine" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\Cryolysis" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\CT_MailMod" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\CT_PlayerNotes" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DamageMeters" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\Decursive" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DoTimer" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\Enchantrix" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\EngBank" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\EngInventory" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\EnhancedFlightMap" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\EnhTooltip" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\EquipCompare" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\EzDismount" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\FishingBuddy" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\Gatherer" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\GroupCalendar" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\HealComm" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\Informant" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\LootFilter" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\MapNotes" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\MCP" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\MikScrollingBattleText" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\MikScrollingBattleTextOptions" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\MobHealth" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\MobHealth3_BlizzardFrames" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\MobInfo2" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\ModifiedPowerAuras" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\Necrosis" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\npcscan" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\oCB" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\OneBag" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\OneBank" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\OneRing" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\OneStorage" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\OneView" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\OutfitDisplayFrame" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\Outfitter" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\pfUI" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\Postal" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\Prat" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\ProfessionLevel" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\RecipeRadar" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\RestedBonus" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\RibsHunterSwingTimer" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\SimpleTranqShot" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\ShaguDB" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\ShaguKill" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\ShaguQuest" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\ShaguScore" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\SHunterTimers" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\Stubby" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\TheoryCraft" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\URLCopy" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\VanillaGuide" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\WeaponQuickSwap" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\WIM" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\YaHT" -Destination $ADDONS_PATH -Recurse;

Write-Host "Unpacking the badly packaged addons.";
Copy-Item -Path "${REPO_PATH}\\SW_Stats-Vanilla\\SW_FixLogStrings" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\SW_Stats-Vanilla\\SW_Stats" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\EQL3\\EQL3" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\QuestieDev\\!Questie" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\_LP\\_LazyPig" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_!deDE" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_!frFR" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_!koKR" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_!ruRU" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_!zhCN" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_Absorbs" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_AbsorbsTaken" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_Activity" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_Auras" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_Casts" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_CCBreaker" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_CureDisease" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_CureDiseaseReceived" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_CurePoison" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_CurePoisonReceived" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_DamageTaken" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_Deaths" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_Decurses" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_DecursesReceived" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_Dispels" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_DispelsReceived" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_EDD" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_EDT" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_EHealing" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_EHealingTaken" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_Fails" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_FriendlyFire" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_FriendlyFireTaken" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_Healing" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_HealingAndAbsorbs" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_HealingTaken" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_Interrupts" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_LiftMagic" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_LiftMagicReceived" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_OHealingTaken" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_Overhealing" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_Procs" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\DPSMate\\DPSMate_Threat" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\KLH-Threat-Meter-17.35\\KTM 17.35\\KLHPerformanceMonitor" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\KLH-Threat-Meter-17.35\\KTM 17.35\\KLHThreatMeter" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\TrinketMenu-Fix\\TrinketMenu" -Destination $ADDONS_PATH -Recurse;