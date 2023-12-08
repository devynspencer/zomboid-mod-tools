. "$PSScriptRoot\Get-ZomboidModInfo.ps1"

<#
.SYNOPSIS
    Deploy a Project Zomboid mod to a local mod directory.

.DESCRIPTION
    Deploy a Project Zomboid mod to a local mod directory.

    The Steam release of Project Zomboid loads mods from 3 locations:

        - a user mods directory (a subdirectory under current user profile)
        - the local mods directory (in a subdirectory under Project Zomboid install directory)
        - the Steam Workshop directory for Project Zomboid (in a subdirectory under Steam install directory).

.PARAMETER SourcePath
    Path to the mod directory, should contain a mod.info file.

.PARAMETER DeployLocation
    Project Zomboid mod directory to deploy mod to.

.PARAMETER Force
    Remove mod if it exists

.PARAMETER UserModsRoot
    Path to the Zomboid mods directory within the user profile.

.PARAMETER LocalModsRoot
    Path to the Zomboid mods directory within the install directory.

.PARAMETER WorkshopModsRoot
    Path to Zomboid mods directory for mods installed via Steam Workshop.

.PARAMETER Exclude
    Directories to exclude, relative to the mod directory root.

.EXAMPLE
    Deploy-ZomboidMod -SourcePath ~\Projects\zomboid-craft-pack

    Deploy a mod to the user mods directory.

.EXAMPLE
    Deploy-ZomboidMod -SourcePath ~\Projects\zomboid-craft-pack -DeployLocation Local

    Deploy a mod to the local mods directory.

.EXAMPLE
    Deploy-ZomboidMod -SourcePath ~\Projects\zomboid-craft-pack -Force

    Deploy a mod to the user mods directory, removing any previous version of the mod (from the user
    mods directory only).
#>

function Deploy-ZomboidMod {
    param (
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ })]
        $SourcePath,

        [ValidateSet('User', 'Local', 'Workshop')]
        $DeployLocation = 'User',

        [switch]
        $Force,

        [ValidateScript({ Test-Path $_ })]
        $UserModsRoot = "$env:USERPROFILE\Zomboid\mods",

        [ValidateScript({ Test-Path $_ })]
        $LocalModsRoot = "$env:USERPROFILE\Zomboid\mods",

        [ValidateScript({ Test-Path $_ })]
        $WorkshopModsRoot = 'C:\Program Files (x86)\Steam\steamapps\workshop\content\108600',

        [string[]]
        $Exclude = @(
            '.git',
            '.gitignore',
            '.github',
            'build',
            'docs',
            'LICENSE',
            'test',
            '*.md'
        )
    )

    # Parse mod.info file for mod information
    $ModInfoPath = [IO.Path]::Join($SourcePath, 'mod.info')
    $ModInfo = Get-ZomboidModInfo -Path $ModInfoPath

    # TODO: Move into helper function to validate mod.info files
    if (!$ModInfo.Id -or !$ModInfo.Name) {
        $ModInfoContent = Get-Content -Path $ModInfoPath
        throw "Missing id or name fields in [$ModInfoPath]:`n`n$ModInfoContent"
    }

    # Handle deployments to each mod directory
    Write-Verbose "Deploying [$($ModInfo.Name)] to [$DeployLocation] Project Zomboid mods directory"

    # Determine directory name based on mod id
    switch ($DeployLocation) {
        'User' {
            $DeploymentPath = [IO.Path]::Join($UserModsRoot, ($ModInfo.Id -replace '\W'))
        }

        'Local' {
            $DeploymentPath = [IO.Path]::Join($LocalModsRoot, ($ModInfo.Id -replace '\W'))
        }

        'Workshop' {
            throw 'Deployment location not yet implemented'
        }
    }

    $DeploymentRoot = Split-Path -Path $DeploymentPath

    Write-Verbose "Deployment path: [$DeploymentPath]"
    Write-Verbose "Deploying mod [$($ModInfo.Name)] to [$DeploymentRoot]"

    # Verify deployment location is suitable
    if (!(Test-Path -Path $DeploymentRoot)) {
        throw "The deployment location [$DeploymentRoot] doesn't exist!"
    }

    # Remove existing mod, if specified
    if ($Force -and (Test-Path -Path $DeploymentPath)) {
        Write-Verbose "Existing mod found at [$DeploymentPath], removing ...`n"
        Remove-Item -Path $DeploymentPath -Force -Recurse
    }

    $CopyParams = @{
        FilePath = 'robocopy.exe'
        ArgumentList = @("$SourcePath", "$DeploymentPath", '/xd', "$Exclude", '/e')
        WorkingDirectory = $SourcePath
        NoNewWindow = $true
        Wait = $true
    }

    Start-Process @CopyParams

    Write-Verbose "Mod files deployed to [$DeploymentRoot]"
    Write-Verbose "Deployment complete!`n`n"

    # Return path to deployed mod directory
    $DeploymentPath
}
