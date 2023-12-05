. "$PSScriptRoot\Get-ZomboidModLocation.ps1"
. "$PSScriptRoot\Get-ZomboidModInfo.ps1"

function Find-ZomboidMod {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        # Name or (part of the name) of a mod. Should match the name of the mod directory
        [Parameter(Mandatory, ParameterSetName = 'ByModName')]
        [ValidateNotNullOrEmpty()]
        $ModName,

        [Parameter(Mandatory, ParameterSetName = 'ByWorkshopId')]
        [ValidateNotNullOrEmpty()]
        $WorkshopId,

        # Project Zomboid mod directory to resolve. Workshop mods have a different
        # path structure, as they are stored under a Steam Workshop id.
        [ValidateSet('User', 'Local', 'Workshop')]
        $Location = 'User'
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


        # Return output object
        switch ($PSCmdlet.ParameterSetName) {
            # Handle filtering by ModName parameter
            'ByModName' {
                if ($ModInfo.Name -match $ModName) {
                    Write-Verbose "Found mod matching [$ModName]: $($ModInfo.Name)`n"
                    $ModInfo
                }
            }

            # Handle filtering by WorkshopId parameter
            'ByWorkshopId' {
                if ($ModInfo.WorkshopId -eq $WorkshopId) {
                    Write-Verbose "Found mod matching Steam workshop id [$WorkshopId]: $($ModInfo.Name)`n"
                    $ModInfo
                }
            }

            default {
                $ModInfo
            }
        }
    }
}
