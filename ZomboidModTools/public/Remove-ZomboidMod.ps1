. "$PSScriptRoot\Find-ZomboidMod.ps1"

function Remove-ZomboidMod {
    [CmdletBinding(SupportsShouldProcess)]
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
        $WorkshopModsRoot = 'C:\Program Files (x86)\Steam\steamapps\workshop\content\108600',

        [switch]
        $PassThru
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
        $ModRoot = Split-Path -Path $Mod.Path

        # TODO: Is this necessary? Find-ZomboidMod already parses the mod.info file, so we can assume
        # the directory is a mod directory -- perhaps testing something else would be less redundant?

        # Ensure target directory is a Zomboid mod directory (contains a mod.info file)
        if (!(Test-Path -Path $Mod.Path)) {
            throw "No mod.info file found at expected location: [$($Mod.Path)]. Is this a Zomboid Mod?"
        }

        # Remove mod directory
        if ($PSCmdlet.ShouldProcess($ModRoot)) {
            $RemoveParams = @{
                Path = $ModRoot
                Force = $true
                Recurse = $true
            }

            Remove-Item @RemoveParams
        }

        if ($PassThru) {
            # Return mod info
            $Mod
        }
    }
}
