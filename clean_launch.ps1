# source cclear.ps1 from $PSScriptRoot
. $PSScriptRoot\cclear.ps1
# source check_game_options.ps1 from $PSScriptRoot
. $PSScriptRoot\check_game_options.ps1

## do the BG first, otherwise the EA window could hide the UA warning
# check to see if fullscreen or windowed is enabled in the game's ini file
# this checks the default Options.ini file
$fullscreen = Get-Fullscreen
Write-Host "Fullscreen is ${fullscreen}..."

if ($fullscreen -eq $false) {
    # if fullscreen is disabled, then we want to launch Borderless Gaming

    # let use know we are going to start Borderless Gaming, so the user knows why
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

Write-Host "Start EA App..."
$eaApp = Get-Process EADesktop -ErrorAction SilentlyContinue
if ($eaApp) {
    Write-Host "EA App is already running"
}
else {
    Start-Sleep -Seconds 2
    # make sure the EA app is running. This takes a while, so start it now
    & "C:\Program Files\Electronic Arts\EA Desktop\EA Desktop\EALauncher.exe"
}

# Write-Host "Stopping after debug..."
# Write-Host -NoNewLine 'Press any key to continue...';
# $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
# exit

try {
    # the user's game settings directory is at "$env:HOME\Documents\Electronic Arts\The Sims 3"
    Push-Location "$env:HOME\Documents\Electronic Arts\The Sims 3"
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

# the launch command is at "C:\Program Files (x86)\Electronic Arts\The Sims 3\Game\Bin\Sims3Launcher.exe"
# launch the game, passing the command line arguments
& "C:\Program Files (x86)\Electronic Arts\The Sims 3\Game\Bin\Sims3Launcher.exe" $args
