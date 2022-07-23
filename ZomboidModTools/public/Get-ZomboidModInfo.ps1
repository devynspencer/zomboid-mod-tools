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
            $SelectParams = @{
                LiteralPath = $ModInfoFile
            }

            # Expect some of the mod.info files to not contain all properties
            $Matches = [ordered] @{
                Id = (Select-String @SelectParams -Pattern 'id=(.*)').Matches
                Name = (Select-String @SelectParams -Pattern 'name=(.*)').Matches
                Poster = (Select-String @SelectParams -Pattern 'poster=(.*)').Matches
                MinimumVersion = (Select-String @SelectParams -Pattern 'minVer=(.*)').Matches
                Description = (Select-String @SelectParams -Pattern 'description=(.*)').Matches
                Uri = (Select-String @SelectParams -Pattern 'url=(.*)').Matches
            }

            $ModInfo = @{}

            # Skip null properties to avoid scary errors
            foreach ($Property in $Matches.Keys) {
                if ($Matches."$Property".Groups) {
                    $Value = $Matches.$Property | % { $_.Groups[1].Value }

                    # Join multiple descriptions together
                    switch ($Property) {
                        'Description' {
                            $ModInfo.$Property = $Value -join ''
                        }

                        default {
                            $ModInfo.$Property = $Value
                        }
                    }
                }
            }

            [pscustomobject] $ModInfo
        }
    }
}
