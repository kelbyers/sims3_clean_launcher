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
        width and height of the primary display.
    .EXAMPLE
        PS C:\> Get-DisplayResolution

        @{Width=1920; Height=1080}
    .OUTPUTS
        PSCustomObject - An object with 'Width' and 'Height' properties.
    #>
    [CmdletBinding()]
    param()

    try {
        $primaryScreen = Get-PrimaryScreen
        $resolution = [PSCustomObject]@{
            Width  = $primaryScreen.Bounds.Width
            Height = $primaryScreen.Bounds.Height
        }
        return $resolution
    }
    catch {
        Write-Error "Failed to get display resolution. Error: $($_.Exception.Message)"
        return $null
    }
}