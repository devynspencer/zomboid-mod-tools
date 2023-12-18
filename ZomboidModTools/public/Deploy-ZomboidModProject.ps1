function Deploy-ZomboidModProject {
    param (
        # Path to the mod project. Examples: "$env:USERPROFILE\Projects\zomboid-balance"
        [Parameter(Mandatory)]
        $Path,

        # Name of the mod. Must match the mod id in mod.info. Examples: 'NoropiaBalance'
        [Parameter(Mandatory)]
        $ModName,

        # Pass the robocopy output to the pipeline.
        [switch]
        $PassThru,

        # Project directories to exclude when deploying. Examples: 'emmy', 'docs', 'assets', 'examples', '.git'
        $ExcludeDirectories = @('emmy', 'docs', 'assets', 'examples', '.git')
    )

    $DestinationPath = "$env:USERPROFILE\Zomboid\mods\$ModName"

    Write-Host -ForegroundColor Magenta "Deploying $ModName to local Zomboid directory...`n"
    Write-Host -ForegroundColor Magenta "  source path: $Path"
    Write-Host -ForegroundColor Magenta "  destination path: $DestinationPath`n"
    Write-Host -ForegroundColor Magenta "Excluding [$($ExcludeDirectories.Count)] directories: $($ExcludeDirectories -join ', ')`n"

    # Build the robocopy arguments
    $StartParams = @{
        WorkingDirectory = $Path
        FilePath = 'robocopy.exe'
        ArgumentList = @(
            $Path,
            $DestinationPath,
            '/e',
            '/xd',
            ($ExcludeDirectories -join ' ')
        )
        Wait = $true
        WindowStyle = 'Hidden'
    }

    # Run the copy command
    Start-Process @StartParams

    # Handle if PassThru parameter specified
    if ($PSBoundParameters.ContainsKey('PassThru')) {
        # Directory info seems more relevant than the robocopy output
        Get-ChildItem $DestinationPath
    }
}
