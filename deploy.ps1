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

Write-Host "Copying new addons.";
Copy-Item -Path "${REPO_PATH}\\*" -Destination $ADDONS_PATH -Recurse;

Write-Host "Removing the addons which require manually unpackaging."
Remove-Item "${ADDONS_PATH}\\deploy.ps1" -Force;
Remove-Item "${ADDONS_PATH}\\.gitignore" -Force;
Remove-Item "${ADDONS_PATH}\\.gitmodules" -Force;
Remove-Item "${ADDONS_PATH}\\.git" -Recurse -Force;
Remove-Item "${ADDONS_PATH}\\SW_Stats-Vanilla" -Recurse -Force;
Remove-Item "${ADDONS_PATH}\\EQL3" -Recurse -Force;
Remove-Item "${ADDONS_PATH}\\QuestieDev" -Recurse -Force;
Remove-Item "${ADDONS_PATH}\\_LP" -Recurse -Force;
Remove-Item "${ADDONS_PATH}\\DPSMate" -Recurse -Force;

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