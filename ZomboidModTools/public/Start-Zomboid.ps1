. "$PSScriptRoot\..\private\Resolve-ZomboidModLocation.ps1"

function Start-Zomboid {
    [CmdletBinding()]
    param (
        $ZomboidExecPath = 'C:\Program Files (x86)\Steam\steamapps\common\ProjectZomboid\ProjectZomboid64.exe',

        $StartupPath = 'C:\Program Files (x86)\Steam\steamapps\common\ProjectZomboid',

        # Project Zomboid mod directory to load mods from. Defaults to all locations, but less can
        # be specified to start Project Zomboid with a more restricted list of
        # mods (useful for debugging). Passes values to the -modfolders startup parameter,
        # see https://pzwiki.net/wiki/Startup_parameters.
        [ValidateSet('User', 'Local', 'Workshop')]
        $Location,

        # Disable game audio
        [switch]
        $NoSound,

        # Launch game in debug mode
        [switch]
        $DebugMode
    )

    Write-Verbose "Starting Project Zomboid from [$ZomboidExecPath]"

    # Check for other instances of Project Zomboid
    if (Get-Process -Name 'ProjectZomboid64' -EA 0) {
        throw 'Project Zomboid already running!'
    }

    # Build the argument list
    $ArgumentList = @()

    if ($PSBoundParameters.ContainsKey('Location')) {
        # Load mods from specific location(s)
        $Locations = Resolve-ZomboidModLocation -Location $Location
        $ArgumentList += "-modfolders $($Location -join ',')"

        Write-Verbose "Loading mods from [$($Locations.Count)] locations: $($Locations -join ', ')"
    }

    if ($DebugMode) {
        # Start in debug mode
        $ArgumentList += '-debug'

        Write-Verbose 'Starting Zomboid in debug mode'
    }

    if ($NoSound) {
        # Disable game audio
        $ArgumentList += '-nosound'
    }

    Write-Verbose "Including [$($ArgumentList.Count)] startup parameters:`n`n$($ArgumentList.foreach({ "`t$_" }))"

    # Start the process
    Write-Verbose "Starting Project Zomboid with [$($ArgumentList.Count)] startup parameters"

    $StartParams = @{
        FilePath = $ZomboidExecPath
        WorkingDirectory = $StartupPath
        ArgumentList = $ArgumentList
    }

    Start-Process @StartParams
}
