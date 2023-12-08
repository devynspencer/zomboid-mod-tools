function Update-ZomboidSourceMap {
    param (
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        $Destination,

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
}
