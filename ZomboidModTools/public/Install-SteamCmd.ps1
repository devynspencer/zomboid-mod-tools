function Install-SteamCmd {
    param (
        # Path to install to
        $Path = "$env:USERPROFILE\bin",

        # Directory to download SteamCMD archive to
        [ValidateScript({ Test-Path $_ })]
        $DownloadPath = "$env:USERPROFILE\Downloads",

        # URI to download SteamCMD archive from
        $DownloadUri = 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip'
    )

    # Download the SteamCMD archive
    $DownloadFilePath = [IO.Path]::Combine($DownloadPath, 'SteamCMD.zip')

    Write-Verbose "Downloading SteamCMD archive to $DownloadFilePath"

    $WebRequestParams = @{
        Uri = $DownloadUri
        OutFile = $DownloadFilePath
    }

    $ArchiveFile = Invoke-WebRequest @WebRequestParams

    # Extract the archive to the installation path
    $DestinationFilePath = [IO.Path]::Combine($Path, 'steamcmd.exe')

    Write-Verbose "Extracting SteamCMD executable to [$DestinationFilePath]"

    if (Test-Path -Path $DestinationFilePath) {
        throw 'SteamCMD already installed'
    }

    Expand-Archive -Path $DownloadFilePath -DestinationPath $Path

    # Show SteamCMD version
    $ProcessParams = @{
        FilePath = $DestinationFilePath
        ArgumentList = @('--help')
        WorkingDirectory = $Path
        NoNewWindow = $true
        Wait = $true
    }

    Start-Process @ProcessParams

    Write-Verbose "Installation complete, use the login command to get started:`n`tsteamcmd.exe login <username>"
    Clear-Host
}
