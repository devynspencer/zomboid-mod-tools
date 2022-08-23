function Get-ZomboidModList {
    [CmdletBinding()]
    param (
        # Name of a modlist
        [string[]]
        $Name,

        # Path of modlists file
        $Path = "$env:USERPROFILE\Zomboid\Lua\saved_modlists.txt"
    )

    Write-Verbose "Filtering for mod lists named [$Name]"

    # Parse specified modlists file
    $Content = Get-Content -Path $Path

    # Version info stored on first line
    $Version = $Content[0].Split('=')[-1]

    foreach ($Line in ($Content | select -Skip 1)) {
        # Modlist and loader info is stored in first value of mods line, for some reason
        $Values = $Line.Split(';')

        # Mods make up the remaining n items
        $Mods = $Values[1..($Values.Count - 1)]

        # Build output object
        $ModList = [pscustomobject] @{
            Name = $Values[0].Split(':')[0]
            Version = $Version
            Mods = $Mods | sort
            TotalMods = $Mods.Count
            LoadOrder = $Mods
            Loader = $Values[0].Split(':')[1]
        }


        # Filter for modlists by name
        if ($PSBoundParameters.ContainsKey('Name') -and ($ModList.Name -in $Name)) {
            Write-Verbose "Including matching modlist: [$($ModList.Name)]"
            $ModList
        }

        else {
            $ModList
        }
    }
}
