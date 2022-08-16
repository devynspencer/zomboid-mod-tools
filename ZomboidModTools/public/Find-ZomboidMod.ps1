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

        # Path to the Zomboid mods directory within the user profile
        [ValidateScript({ Test-Path $_ })]
        $UserModsRoot = "$env:USERPROFILE\Zomboid\mods",

        # Path to the Zomboid mods directory within the install directory
        [ValidateScript({ Test-Path $_ })]
        $LocalModsRoot = 'C:\Program Files (x86)\Steam\steamapps\common\ProjectZomboid\mods',

        # Path to Zomboid mods directory for mods installed via Steam Workshop
        [ValidateScript({ Test-Path $_ })]
        $WorkshopModsRoot = 'C:\Program Files (x86)\Steam\steamapps\workshop\content\108600'
    )

    Write-Verbose "Looking for mods containing name: [$ModName]"

    switch ($Location) {
        'User' {
            $ModRootPath = $UserModsRoot
        }

        'Local' {
            $ModRootPath = $LocalModsRoot
        }

        'Workshop' {
            $ModRootPath = $WorkshopModsRoot
        }
    }

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
