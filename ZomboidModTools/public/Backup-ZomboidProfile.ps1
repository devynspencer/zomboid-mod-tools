using module '..\classes\ZomboidUserFile.enum.psm1'

. "$PSScriptRoot\..\private\Resolve-ZomboidUserFile.ps1"
function Backup-ZomboidProfile {
    param (
        [Parameter(Mandatory)]
        $Name,

        [ZomboidUserFile[]]
        $Item
    )
    # Backup everything by default
    if ($PSBoundParameters.ContainsKey('Item')) {
        $Files = Resolve-ZomboidUserFile -Name $Item
    }

    else {
        $Files = Resolve-ZomboidUserFile
    }

    $DestinationPath = [IO.Path]::Combine("$env:USERPROFILE", 'Zomboid', 'backups', 'ZomboidModTools', $Name)
    Write-Verbose "Creating backup directory for backup [$Name] with [$($Files.Count)] files"
    foreach ($File in $Files) {
        Copy-Item -Path $File -Destination "$DestinationPath\"
    }
}
