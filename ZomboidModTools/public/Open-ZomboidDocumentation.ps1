<#
.SYNOPSIS
    Opens the Project Zomboid modding documentation in a web browser.

.DESCRIPTION
    The Open-ZomboidDocumentation function opens the Project Zomboid modding documentation in a web browser. By default, it opens the 'Overview' page, but you can specify a different page using the -Page parameter.

.PARAMETER Page
    Specifies the page to open in the web browser. The available options are:

    - Overview (default): Opens the overview page.
    - Index: Opens the index page.
    - Tree: Opens the overview tree page.
    - Packages: Opens the all packages index page.
    - Classes: Opens the all classes index page.
    - Interfaces: Opens the all interfaces index page.
    - Constants: Opens the constant values page.
    - Serialized: Opens the serialized form page.
    - Deprecated: Opens the deprecated list page.
    - Help: Opens the help documentation overview page.

.EXAMPLE
    Open-ZomboidDocumentation -Page Index
    Opens the Project Zomboid modding documentation and navigates to the index page.
#>

function Open-ZomboidDocumentation {
    param (
        [ValidateSet(
            'Overview',
            'Index',
            'Tree',
            'Packages',
            'Classes',
            'Interfaces',
            'Constants',
            'Serialized',
            'Deprecated',
            'Help'
        )]
        [string[]]
        $Page = 'Overview'
    )

    $BaseUri = 'https://projectzomboid.com/modding'

    # TODO: Support the following:
    # Forum => https://theindiestone.com/forums/index.php?/forum/45-pz-modding/
    # Steam => https://steamcommunity.com/app/108600/workshop/
    # Wiki => https://pzwiki.net/wiki/Modding
    # CommunityGuide => https://github.com/FWolfe/Zomboid-Modding-Guide
    # DebugMode => https://pzwiki.net/wiki/Debug_mode

    $Subpath = @{
        'Overview' = '/index.html'
        'Index' = '/index-files/index-1.html'
        'Tree' = '/overview-tree.html'
        'Packages' = '/allpackages-index.html'
        'Classes' = '/allclasses-index.html'
        'Interfaces' = '/allclasses-index.html'
        'Constants' = '/constant-values.html'
        'Serialized' = '/serialized-form.html'
        'Deprecated' = '/deprecated-list.html'
        'Help' = '/help-doc.html#overview'
    }

    foreach ($PageName in $Page) {
        $Uri = $BaseUri + $Subpath[$PageName]
        Start-Process $Uri
    }
}
