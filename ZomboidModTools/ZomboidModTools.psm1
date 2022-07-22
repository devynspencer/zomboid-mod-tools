# Load public and private functions
foreach ($File in (Get-ChildItem "$PSScriptRoot\public", "$PSScriptRoot\private" -Recurse -Filter '*.ps1')) {
    . $File.FullName
}

# Export all public functions
foreach ($File in (Get-ChildItem "$PSScriptRoot\public" -Recurse -Filter '*.ps1')) {
    Export-ModuleMember $File.BaseName
}

# Export aliases to InvokeBuild tasks, per the patterns documentation:
# https://github.com/nightroman/Invoke-Build/tree/master/Tasks/Import
foreach ($TaskFile in (Get-ChildItem "$PSScriptRoot\tasks" -Recurse -Filter '*.tasks.ps1')) {
    $TaskGroup = $TaskFile.Name.Replace('.tasks.ps1', '')
    $AliasName = "Builder.$TaskGroup.tasks"

    Set-Alias $AliasName "$PSScriptRoot\tasks\$($TaskFile.Name)"
}

Export-ModuleMember -Alias '*.tasks' -Verbose
