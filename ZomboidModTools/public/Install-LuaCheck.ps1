function Install-LuaCheck {
    param (
        # Local path to install the etl2pcapng binary to
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ })]
        $Path,

        # Release version to download
        [ValidatePattern('v?\d+\.\d+\.\d+')]
        $Version,

        [switch]
        $PassThru
    )

    # Build download URI based on version specified
    if (!$PSBoundParameters.ContainsKey('Version')) {
        # Determine the latest version available for download
        $RequestLatest = Invoke-WebRequest -Uri 'https://github.com/mpeterv/luacheck/releases/latest'
        $Version = $RequestLatest.BaseResponse.RequestMessage.RequestUri.ToString().Split('/')[-1]
    }

    if (!$Version) {
        throw 'Unable to determine latest version and none specified'
    }

    $DownloadUri = "https://github.com/mpeterv/luacheck/releases/download/$Version/luacheck.exe"
    $DownloadFilePath = [IO.Path]::Combine($Path, 'luacheck.exe')

    # Download and extract the archive
    Invoke-WebRequest -Uri $DownloadUri -OutFile $DownloadFilePath
    Write-Verbose "luacheck executable installed to [$($File.FullName)]"

    # Output file information
    if ($PassThru) {
        $File
    }
}
