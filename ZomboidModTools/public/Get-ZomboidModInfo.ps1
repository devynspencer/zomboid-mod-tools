<#
.SYNOPSIS
    Parse a mod.info file for a Project Zomboid mod

.PARAMETER Path
    Path to one or more mod.info file(s).

.EXAMPLE
    Get-ZomboidModInfo -Path ~\Zomboid\mods\SomeMod\mod.info
    Display information for a mod.

.EXAMPLE
    $ModInfoFiles = ls "C:\Program Files (x86)\Steam\steamapps\workshop\content\108600" -Recurse -Filter mod.info | select -ExpandProperty FullName
    $ModInfoFiles | Get-ZomboidModInfo | fl

    Get mod information for all Steam Workshop mods.
#>

function Get-ZomboidModInfo {
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [ValidatePattern('.*\\mod\.info')]
        $Path
    )

    process {
        foreach ($ModInfoFile in $Path) {
            # Build the output object with known mod.info properties
            $ModInfo = @{
                Path = $ModInfoFile
                ModDirectory = (Split-Path -LiteralPath $ModInfoFile)
                WorkshopDirectory = $null
                Id = $null
                Name = $null
                Description = $null
                MinimumVersion = $null
                Poster = $null
                Uri = $null

            # Determine root directory for Steam workshop item, if applicable
            if ($ModInfo.ModDirectory -match '\\steamapps\\workshop\\content\\108600\\') {
                $ModInfo.WorkshopDirectory = (Get-Item -Path $ModInfo.ModDirectory).Parent.Parent
            }

            # Parse the mod.info file
            $SelectParams = @{
                LiteralPath = $ModInfoFile
            }

            $Matches = [ordered] @{
                Id = (Select-String @SelectParams -Pattern 'id=(.*)').Matches
                Name = (Select-String @SelectParams -Pattern 'name=(.*)').Matches
                Description = (Select-String @SelectParams -Pattern 'description=(.*)').Matches
                MinimumVersion = (Select-String @SelectParams -Pattern 'versionMin=(.*)').Matches
                Poster = (Select-String @SelectParams -Pattern 'poster=(.*)').Matches
                Uri = (Select-String @SelectParams -Pattern 'url=(.*)').Matches
            }

            # Skip null properties to avoid scary errors
            foreach ($Property in $Matches.Keys) {
                if ($Matches[$Property].Groups) {
                    $Value = $Matches[$Property] | % { $_.Groups[1].Value }

                    # Join multiple descriptions together
                    switch ($Property) {
                        'Description' {
                            $ModInfo[$Property] = $Value -join ''
                        }

                        default {
                            $ModInfo[$Property] = $Value
                        }
                    }
                }
            }

            # Return the output object
            [pscustomobject] $ModInfo
        }
    }
}
