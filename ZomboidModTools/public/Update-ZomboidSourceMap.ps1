function Update-ZomboidSourceMap {
    param (
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        $Destination,

        [switch]
        $SkipConfig,

        # Path to config file template for VSCode EmmyLua extension
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        $ConfigFilePath = "$PSScriptRoot\..\templates\emmy.config.json",

        # The URI of the repository to clone
        $Uri = 'https://github.com/asledgehammer/Umbrella'
    )

    # Clone typings repository
    $GitParams = @{
        FilePath = 'git.exe'
        Wait = $true
        NoNewWindow = $true
    }

    # Note the directory argument is specified to ensure that the repository is cloned into the correct directory
    Start-Process @GitParams -WorkingDirectory $Destination -ArgumentList 'clone', $Uri, 'emmy'

    # Update submodules
    $SourceMapRoot = Join-Path -Path $Destination -ChildPath 'emmy'
    Start-Process @GitParams -WorkingDirectory $SourceMapRoot -ArgumentList 'submodule', 'update', '--init', '--remote'

    if (!$SkipConfig) {
        Write-Verbose "Copying EmmyLua configuration from template to $SourceMapRoot"

        # Copy EmmyLua configuration from template
        $CopyParams = @{
            Path = $ConfigFilePath
            Destination = $SourceMapRoot
            Force = $true
        }

        Copy-Item @CopyParams
    }
}
