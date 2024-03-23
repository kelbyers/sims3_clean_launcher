# source setup_nvidia.ps1 from $PSScriptRoot
. $PSScriptRoot\setup_nvidia.ps1
# source cclear.ps1 from $PSScriptRoot
. $PSScriptRoot\cclear.ps1

# the user's game settings directory is at "C:\Users\kel\Documents\Electronic Arts\The Sims 3"

try {
    Push-Location "C:\Users\kel\Documents\Electronic Arts\The Sims 3"
    # clear the game's cache
    Clear-Sims3Cache
    
    # update The Sims 3's options.ini file
    SetupNvidia Options.ini
    
    # the launch command is at "C:\Program Files (x86)\Electronic Arts\The Sims 3\Game\Bin\Sims3Launcher.exe"
    # launch the game, passing the command line arguments
}
finally {
    Pop-Location
}
& "C:\Program Files (x86)\Electronic Arts\The Sims 3\Game\Bin\Sims3Launcher.exe" $args