. "$PSScriptRoot\Get-ZomboidModLocation.ps1"
. "$PSScriptRoot\Get-ZomboidModInfo.ps1"

function Find-ZomboidMod {
    param (
        # Name or (part of the name) of a mod. Should match the name of the mod directory
        [ValidateNotNullOrEmpty()]
        $ModName,

        # Project Zomboid mod directory to resolve. Workshop mods have a different
        # path structure, as they are stored under a Steam Workshop id.
        [ValidateSet('User', 'Local', 'Workshop')]
        $Location = 'User',
    )

    $ChildParams = @{
        Path = (Get-ZomboidModLocation -Location $Location).Path
        Filter = 'mod.info'
        File = $true
        Recurse = $true
        Depth = 3
    }

    $ModInfoFiles = Get-ChildItem @ChildParams

    foreach ($File in $ModInfoFiles) {
        $ModInfo = Get-ZomboidModInfo -Path $File.FullName
        $ModDirectory = Split-Path -Path $File.FullName -Parent

        if ($PSBoundParameters.ContainsKey('ModName') -and ($ModInfo.Name -match $ModName)) {
            Write-Verbose "Found mod matching [$ModName]: $($ModInfo.Name)`n"
            Write-Verbose "[$ModName] info file: $($File.FullName)"
            Write-Verbose "[$ModName] directory: $ModDirectory"
            Write-Verbose "`n$($ModInfo | ConvertTo-Json)"

            $ModInfo
        }

        else {
            $ModInfo
        }
    }
}
