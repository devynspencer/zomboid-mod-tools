. "$PSScriptRoot\Get-ZomboidModLocation.ps1"
. "$PSScriptRoot\Get-ZomboidModInfo.ps1"

function Find-ZomboidMod {
    param (
        # Name or (part of the name) of a mod. Should match the name of the mod directory
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        $ModName,

        # Project Zomboid mod directory to resolve. Workshop mods have a different
        # path structure, as they are stored under a Steam Workshop id.
        [ValidateSet('User', 'Local', 'Workshop')]
        $Location = 'User',
    )

    Write-Verbose "Looking for mods containing name: [$ModName]"

    $ModRootPath = (Get-ZomboidModLocation -Location $Location).Path

    $ModInfoFiles = Get-ChildItem -Path $ModRootPath -Recurse -Depth 3 -Filter 'mod.info'

    foreach ($File in $ModInfoFiles) {
        $ModInfo = Get-ZomboidModInfo -Path $File.FullName
        $ModDirectory = Split-Path -Path $File.FullName -Parent

        if ($ModInfo.Name -match $ModName) {
            Write-Verbose "Found mod matching [$ModName]: $($ModInfo.Name)`n"
            Write-Verbose "[$ModName] info file: $($File.FullName)"
            Write-Verbose "[$ModName] directory: $ModDirectory"
            Write-Verbose "`n$($ModInfo | ConvertTo-Json)"

            $ModInfo
        }
    }
}
