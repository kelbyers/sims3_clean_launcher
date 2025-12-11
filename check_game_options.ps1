# helpers to check Sims 3 game options
. "$PSScriptRoot\system_utils.ps1"
#
# All this is used for at the moment is to check if the game is running in
# fullscreen or windowed mode
#
# Get-Fullscreen returns true if the game is running in fullscreen mode
#                returns false if the game is running in windowed mode
#     Since the game defaults to full screen if there is no Options.ini file
#     Get-Fullscreen will return true if the Options.ini file is not found

Function Get-IniFile {
    param (
        [string]$Path
    )
    $ini = @{}

    # Create a default section if none exist in the file. Like a java prop file.
    $section = "NO_SECTION"
    $ini[$section] = @{}

    try {
        switch -regex -file $Path {
            "^\[(.+)\]$" {
                $section = $matches[1].Trim()
                $ini[$section] = @{}
            }
            "^\s*([^#].+?)\s*=\s*(.*)" {
                $name, $value = $matches[1..2]
                # skip comments that start with semicolon:
                if (!($name.StartsWith(";"))) {
                    $ini[$section][$name] = $value.Trim()
                }
            }
        }
    }
    Catch [System.Management.Automation.ItemNotFoundException] {
        Write-Warning "File $Path not found!"
    }
    $ini
}

function Get-GameOptions {
    param (
        [string]$OptionsIniPath = "C:\Users\kel\Documents\Electronic Arts\The Sims 3\Options.ini"
    )
    $options = Get-IniFile -Path $OptionsIniPath
    return $options['options']
}

function Get-BooleanOption {
    param (
        [string]$key,
        [switch]$defaultTrue
    )
    $options = Get-GameOptions @args
    if (($options) -and ($options.ContainsKey($key))) {
        return $options[$key] -eq 1
    }
    $defaultTrue
}

function Get-Fullscreen {
    Get-BooleanOption -key fullscreen -defaultTrue @args
}

function Should-Start-BorderlessGaming {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$GameOptions
    )

    # Check fullscreen status. Defaults to true if not set.
    $isFullscreen = $true
    if ($GameOptions.ContainsKey('fullscreen')) {
        $isFullscreen = ($GameOptions.fullscreen -eq '1')
    }

    # If fullscreen is on, we don't need Borderless Gaming.
    if ($isFullscreen) {
        return $false
    }

    # Get system resolution. Let this throw if it fails.
    $systemResolution = Get-DisplayResolution

    # Get and parse game resolution.
    $gameResolutionString = $GameOptions.resolution
    if (-not $gameResolutionString) {
        # Not an error, just means we can't match, so don't run.
        return $false
    }

    $gameResolutionParts = $gameResolutionString.Split(' ')
    # Let this throw if parsing fails.
    $gameWidth = [int]$gameResolutionParts[0]
    $gameHeight = [int]$gameResolutionParts[1]

    # Compare resolutions
    return (($gameWidth -eq $systemResolution.Width) -and ($gameHeight -eq $systemResolution.Height))
}
