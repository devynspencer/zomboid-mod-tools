using module '..\classes\ZomboidUserFile.enum.psm1'

. "$PSScriptRoot\..\private\Resolve-ZomboidUserFile.ps1"
function Backup-ZomboidProfile {
    param (
        [Parameter(Mandatory)]
        $Name,

        [ZomboidUserFile[]]
        $Item,

        [switch]
        $Force,

        [switch]
        $PassThru
    )

    # Backup everything by default
    if ($PSBoundParameters.ContainsKey('Item')) {
        $Files = Resolve-ZomboidUserFile -Name $Item
    }

    else {
        $Files = Resolve-ZomboidUserFile
    }

    $DestinationPath = [IO.Path]::Combine("$env:USERPROFILE", 'Zomboid', 'backups', 'ZomboidModTools', $Name)

    if (!(Test-Path -Path $DestinationPath)) {
        Write-Verbose "Backup directory [$DestinationPath] not found, creating..."
        New-Item -Path $DestinationPath -ItemType Directory | Out-Null
    }

    elseif ($Force) {
        Write-Verbose "Backup directory [$DestinationPath] exists, removing..."
        Remove-Item -Path $DestinationPath -Force -Recurse | Out-Null
    }

    Write-Verbose "Creating backup directory for backup [$Name] with [$($Files.Count)] files"
    foreach ($File in $Files) {
        Copy-Item -Path $File -Destination "$DestinationPath\"
    }

    if ($PassThru) {
        Get-ChildItem -Path $DestinationPath
    }
}
