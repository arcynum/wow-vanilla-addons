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

Write-Host "Unpacking the badly packaged addons.";
Copy-Item -Path "${REPO_PATH}\\SW_Stats-Vanilla\\SW_FixLogStrings" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\SW_Stats-Vanilla\\SW_Stats" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\EQL3\\EQL3" -Destination $ADDONS_PATH -Recurse;
Copy-Item -Path "${REPO_PATH}\\QuestieDev\\!Questie" -Destination $ADDONS_PATH -Recurse;