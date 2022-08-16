function Resolve-ZomboidModLocation {
    param (
        # Project Zomboid mod directory to load mods from. Defaults to all locations, but less can
        # be specified to start Project Zomboid with a more restricted list of
        # mods (useful for debugging). Passes values to the -modfolders startup parameter,
        # see https://pzwiki.net/wiki/Startup_parameters.
        [Parameter(Mandatory)]
        [ValidateSet('User', 'Local', 'Workshop')]
        $Location
    )

    # Translate locations from those used across this module to acceptable values for the -modfolders
    # startup parameter (mods/steam/workshop), see https://pzwiki.net/wiki/Startup_parameters
    $Locations = @()

    switch ($Location) {
        'User' {
            $Locations += 'mods'
        }

        'Local' {
            $Locations += 'steam'
        }

        'Workshop' {
            $Locations += 'workshop'
        }
    }

    Write-Verbose "Resolve-ZomboidModLocation: [$($Locations -join ', ')]"

    $Locations
}
