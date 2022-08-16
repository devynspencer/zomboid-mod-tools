function Show-ZomboidLog {
    param (
        # Type of logs to include
        [ValidateSet('Console', 'Debug', 'Client', 'ZombieSpawn')]
        $LogType = 'Console',

        # Log levels to include
        [ValidateSet(
            'LOG',
            'WARN',
            'ERROR',
            'DEBUG'
        )]
        $Level,

        # Path to the user console log file
        [ValidateScript({ Test-Path $_ })]
        $ConsoleLogPath = "$env:USERPROFILE\Zomboid\console.txt",

        # Local logs directory
        [ValidateScript({ Test-Path $_ })]
        $UserLogsDirectory = "$env:USERPROFILE\Zomboid\Logs",

        # Number of log events to show
        [int]
        $First = 1,

        # Show log file(s) for specified date
        [datetime]
        $Date = (Get-Date)
    )

    # Debug, client, and spawn logs are prefixed with the date
    $DatePrefix = Get-Date $Date -Format 'dd-MM-yy*'

    # Handle each log type
    switch ($LogType) {
        'Console' {
            if (!(Test-Path -Path $ConsoleLogPath)) {
                throw "Console log not found! Expected [$ConsoleLogPath]"
            }

            $LogFiles = Get-Item -Path $ConsoleLogPath
        }

        'Debug' {
            $Filter = "$DatePrefix_*_DebugLog.txt"

            $GetParams = @{
                Path = $UserLogsDirectory
                Filter = $Filter
                File = $true
            }

            $LogFiles = Get-ChildItem @GetParams | sort Name | select -First $First
        }

        'Client' {
            throw 'Not yet implemented'
        }

        'ZombieSpawn' {
            throw 'Not yet implemented'
        }
    }

    Write-Verbose "Found [$($LogFiles.Count)] log files"

    # Get log content, filtering for specified data
    $SelectParams = @{
        Pattern = '^([A-Z]+)\s*:\s*(\w+)\s+(.*)'
        Path = $LogFiles.FullName
    }

    $Content = Select-String @SelectParams
    $LogEvents = @()

    foreach ($Line in $Content) {
        Write-Verbose "Processing $($Line.Filename):$($Line.LineNumber)"

        foreach ($Match in $Line.Matches) {
            $LogEvent = [ordered] @{
                Level = $Match.Groups[1].Value
                Context = $Match.Groups[2].Value
                Message = $Match.Groups[3].Value
            }

            $LogEvents += [pscustomobject] $LogEvent
        }
    }

    if ($PSBoundParameters.ContainsKey('Level')) {
        $LogEvents = $LogEvents.where({ $_.Level -in $Level })
    }

    $LogEvents
}
