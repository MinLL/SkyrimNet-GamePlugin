
. .\Build_Config_Template.ps1
$spriggitVersion = "0.40.0"
$pluginName = "SkyrimNet"
$plugintype = "esp"

if (Test-Path .\Build_Config_Local.ps1) {
    . .\Build_Config_Local.ps1
}
if (-not (Test-Path $gameDataPath)) {
    Write-Error "Game Data Path $gameDataPath does not exist."
    exit 1
}
Write-Host "Serializing plugin $pluginName.$plugintype from $gameDataPath using Spriggit CLI version $spriggitVersion"
$spriggitExe = ".\external\SpriggitCLI-$spriggitVersion\Spriggit.CLI.exe"
if (-not (Test-Path $spriggitExe)) {
    Write-Error "Spriggit CLI not found at $spriggitExe"
    exit 1
}
& $spriggitExe convert-from-plugin -InputPath "$gameDataPath\$pluginName.$plugintype" -OutputPath "plugins\$pluginName" -GameRelease SkyrimSE -p Spriggit.Json -v $spriggitVersion
if ($LASTEXITCODE -ne 0) {
    Write-Error "Spriggit CLI failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}