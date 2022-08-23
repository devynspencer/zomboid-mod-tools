function Get-ZomboidModLocation {
    [CmdletBinding()]
    param (
        # Named location(s) where Project Zomboid loads mods from
        [ValidateSet('User', 'Local', 'Workshop')]
        $Location = @('User', 'Local', 'Workshop')
    )

    $BaseLocations = @{
        User = "$env:USERPROFILE\Zomboid\mods"
        Local = 'C:\Program Files (x86)\Steam\steamapps\common\ProjectZomboid\mods'
        Workshop = 'C:\Program Files (x86)\Steam\steamapps\workshop\content\108600'
    }

    foreach ($LocationName in $Location) {
        $Path = $BaseLocations[$LocationName]
        $Exists = Test-Path -Path $Path

        if ($Exists) {
            # Collect directory statistics
            $ModDirectories = Get-ChildItem -Path $Path -Directory
        }

        # Build output object
        [pscustomobject] @{
            Name = $LocationName
            Path = $Path
            ModCount = $ModDirectories.Count
            Exists = $Exists
        }
    }
}
