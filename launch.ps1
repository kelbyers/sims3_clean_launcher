# source setup_nvidia.ps1 from $PSScriptRoot
. $PSScriptRoot\setup_nvidia.ps1
# # source cclear.ps1 from $PSScriptRoot
# . $PSScriptRoot\cclear.ps1


try {
    # the user's game settings directory is at "$env:HOME\Documents\Electronic Arts\The Sims 3"
    Push-Location "$env:HOME\Documents\Electronic Arts\The Sims 3"
    # # clear the game's cache
    # Clear-Sims3Cache

    # update The Sims 3's options.ini file
    SetupNvidia Options.ini

    # call the script to clean caches and launch the game
    & $PSScriptRoot\clean_launch.ps1 $args
}
catch {
    Write-Error $_
}
finally {
    Pop-Location
}
# finally {
#     Pop-Location
#     Write-Host -NoNewLine 'Press any key to continue...';
#     $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
# }

# # the launch command is at "C:\Program Files (x86)\Electronic Arts\The Sims 3\Game\Bin\Sims3Launcher.exe"
# # launch the game, passing the command line arguments
# & "C:\Program Files (x86)\Electronic Arts\The Sims 3\Game\Bin\Sims3Launcher.exe" $args
