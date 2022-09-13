using module '..\classes\ZomboidUserFile.enum.psm1'

function Resolve-ZomboidUserFile {
    param (
        [ZomboidUserFile[]]
        $Name = @(
            [ZomboidUserFile]::DebugOptions
            [ZomboidUserFile]::DebugLogOptions
            [ZomboidUserFile]::Options
            [ZomboidUserFile]::Keybinds
            [ZomboidUserFile]::LatestSave
            [ZomboidUserFile]::Emotes
            [ZomboidUserFile]::ModOptions
            [ZomboidUserFile]::ServerHost
            [ZomboidUserFile]::Layout
            [ZomboidUserFile]::Resolution
        )
    )

    switch ($Name) {
        'DebugOptions' {
            'C:\Users\devyn\Zomboid\debug-options.ini'
        }

        'DebugLogOptions' {
            'C:\Users\devyn\Zomboid\debuglog.ini'
        }

        'Options' {
            'C:\Users\devyn\Zomboid\debuglog.ini'
        }

        'Keybinds' {
            'C:\Users\devyn\Zomboid\Lua\keys.ini'
        }

        'LatestSave' {
            'C:\Users\devyn\Zomboid\latestSave.ini'
        }

        'Emotes' {
            'C:\Users\devyn\Zomboid\Lua\emote.ini'
        }

        'ModOptions' {
            'C:\Users\devyn\Zomboid\Lua\mods_options.ini'
        }

        'ServerHost' {
            'C:\Users\devyn\Zomboid\Lua\host.ini'
        }

        'Layout' {
            'C:\Users\devyn\Zomboid\Lua\layout.ini'
        }

        'Resolution' {
            'C:\Users\devyn\Zomboid\Lua\screenresolution.ini'
        }
    }
}
