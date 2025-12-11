# source cclear.ps1 from $PSScriptRoot
. $PSScriptRoot\cclear.ps1
# source check_game_options.ps1 from $PSScriptRoot
. $PSScriptRoot\check_game_options.ps1

## do the BG first, otherwise the EA window could hide the UA warning
try {
    $gameOptions = Get-GameOptions
    Write-Host "Fullscreen is $($gameOptions.fullscreen -eq '1') (from game options)..." # Update message
    Write-Host "Resolution is $($gameOptions.resolution)"

    if (Should-Start-BorderlessGaming -GameOptions $gameOptions) {
        # let user know we are going to start Borderless Gaming, so the user knows why
        # they are getting a UA popup
        Write-Host "Checking Borderless Gaming..."

        # check if Borderless Gaming is running
        $borderlessGaming = Get-Process BorderlessGaming -ErrorAction SilentlyContinue
        if ($borderlessGaming) {
            Write-Host "Borderless Gaming is already running"
        }
        else {
            # start Borderless Gaming
            Write-Host "Starting Borderless Gaming..."
            Start-Sleep -Seconds 2
            & "C:\Program Files (x86)\Borderless Gaming\BorderlessGaming.exe"
        }
    }
}
catch {
    Write-Warning "Could not check for Borderless Gaming due to an error: $($_.Exception.Message). Borderless Gaming will not be launched automatically."
}

# Write-Host "Start EA App..."
# $eaApp = Get-Process EADesktop -ErrorAction SilentlyContinue
# if ($eaApp) {
#     Write-Host "EA App is already running"
# }
# else {
#     Start-Sleep -Seconds 2
#     # make sure the EA app is running. This takes a while, so start it now
#     & "C:\Program Files\Electronic Arts\EA Desktop\EA Desktop\EALauncher.exe"
# }

# Write-Host "Stopping after debug..."
# Write-Host -NoNewLine 'Press any key to continue...';
# $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
# exit

try {
    # the user's game settings directory is at "$env:HOME\Documents\Electronic Arts\The Sims 3"
    Push-Location "$home\Documents\Electronic Arts\The Sims 3"
    # clear the game's cache
    Clear-Sims3Cache
}
finally {
    #### This doesn't seem to work, so let's not try it for now
    #     # make sure this window is on top, so the user can see it, we do this because
    #     # EA Desktop can hide the window
    #     Add-Type @"
    # using System;
    # using System.Runtime.InteropServices;
    # public class SFW {
    #  [DllImport("user32.dll")]
    #  [return: MarshalAs(UnmanagedType.Bool)]
    #  public static extern bool SetForegroundWindow(IntPtr hWnd);
    # }
    # "@

    #     $fw =  (get-process -Id $PID).MainWindowHandle
    #     [SFW]::SetForegroundWindow($fw)

    Pop-Location
    Write-Host -NoNewLine 'Press any key to continue...';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
}

# The game exe is at
# "C:\Program Files (x86)\Steam\steamapps\common\The Sims 3\Game\Bin\TS3.exe"
# Change directories to that location before loaunching the game, because the
# dxvk (DirectX to Vulkan) driver will create its log file in the working
# directory
$binDir = "C:\Program Files (x86)\Steam\steamapps\common\The Sims 3\Game\Bin"
$exe = "TS3.exe"

Push-Location "${binDir}"
& ".\${exe}"
