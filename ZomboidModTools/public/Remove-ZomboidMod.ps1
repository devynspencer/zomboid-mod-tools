. "$PSScriptRoot\Find-ZomboidMod.ps1"

function Remove-ZomboidMod {
    param (
        [Parameter(Mandatory)]
        $ModName,

        [ValidateSet('User', 'Local', 'Workshop')]
        $Location = 'User',

        [ValidateScript({ Test-Path $_ })]
        $UserModsRoot = "$env:USERPROFILE\Zomboid\mods",

        [ValidateScript({ Test-Path $_ })]
        $LocalModsRoot = "$env:USERPROFILE\Zomboid\mods",

        [ValidateScript({ Test-Path $_ })]
        $WorkshopModsRoot = 'C:\Program Files (x86)\Steam\steamapps\workshop\content\108600'
    )

    # Find mods matching specified criteria
    $FindParams = @{
        ModName = $ModName
        Location = $Location
        UserModsRoot = $UserModsRoot
        LocalModsRoot = $LocalModsRoot
        WorkshopModsRoot = $WorkshopModsRoot
    }

    $Mods = Find-ZomboidMod @FindParams

    # Confirm list of mods
    Write-Verbose "Removing [$($Mods.Count)] mods:"

    # Remove mods
    foreach ($Mod in $Mods) {
        # Parse mod.info file for mod information
        $ModRoot = Split-Path -Path $Mod.Path
        $ModInfoPath = [IO.Path]::Join($ModRoot, 'mod.info')

        # Ensure target directory is a Zomboid mod directory (contains a mod.info file)
        if (!(Test-Path -Path $ModInfoPath)) {
            throw "No mod.info file found at expected location: [$ModInfoPath]. Is this a Zomboid Mod?"
        }

        Write-Verbose "Removing mod [$($Mod.Name) ($($Mod.Id))] from [$ModRoot]"

        $RemoveParams = @{
            Path = $ModRoot
            Force = $true
            Recurse = $true
        }

        Remove-Item @RemoveParams

        # Return mod info
        $Mod
    }
}
