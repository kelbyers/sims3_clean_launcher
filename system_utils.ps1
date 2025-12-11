# Internal function, not exported.
function Get-PrimaryScreen {
    [CmdletBinding()]
    param()

    Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
    return [System.Windows.Forms.Screen]::PrimaryScreen
}

function Get-DisplayResolution {
    <#
    .SYNOPSIS
        Gets the resolution of the primary display.
    .DESCRIPTION
        This function uses the .NET System.Windows.Forms.Screen class to retrieve the
        width and height of the primary display. It will throw an exception if the
        underlying system calls fail.
    .EXAMPLE
        PS C:\> try { $res = Get-DisplayResolution } catch { "Failed: $_" }

        @{Width=1920; Height=1080}
    .OUTPUTS
        PSCustomObject - An object with 'Width' and 'Height' properties.
    #>
    [CmdletBinding()]
    param()

    $primaryScreen = Get-PrimaryScreen
    $resolution = [PSCustomObject]@{
        Width  = $primaryScreen.Bounds.Width
        Height = $primaryScreen.Bounds.Height
    }
    return $resolution
}