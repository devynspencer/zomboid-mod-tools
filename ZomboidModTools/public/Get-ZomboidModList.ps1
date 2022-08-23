function Get-ZomboidModList {
    [CmdletBinding()]
    param (
        # Name of a modlist; wildcards supported
        [string[]]
        $Name,

        # Match part of a modlist name
        [switch]
        $MatchAnyKeyword,

        # Path of modlists file
        $Path = "$env:USERPROFILE\Zomboid\Lua\saved_modlists.txt"
    )

    Write-Verbose "Filtering for mod lists matching [$Name]"

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
        if ($PSBoundParameters.ContainsKey('Name')) {
            $Matched = $false

            # Handle exact and partial matches. Note order of operators when using -like and -match
            $Name | foreach {
                if ($MatchAnyKeyword -and ($ModList.Name -match $_)) {
                    Write-Verbose "[$($ModList.Name)] matched regex [$_]"
                    $Matched = $true
                }

                elseif ($ModList.Name -like $_) {
                    Write-Verbose "[$($ModList.Name)] matched wildcard [$_]"
                    $Matched = $true
                }

                elseif ($ModList.Name -eq $_) {
                    Write-Verbose "[$($ModList.Name)] matched [$_]"
                    $Matched = $true
                }
            }

            # Output matching mod lists
            if ($Matched) {
                Write-Verbose "[$($ModList.Name)] included in output"
                $ModList
            }
        }

        else {
            $ModList
        }
    }
}
