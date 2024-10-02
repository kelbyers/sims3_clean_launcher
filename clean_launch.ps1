# source cclear.ps1 from $PSScriptRoot
. $PSScriptRoot\cclear.ps1


try {
    # the user's game settings directory is at "$env:HOME\Documents\Electronic Arts\The Sims 3"
    Push-Location "$env:HOME\Documents\Electronic Arts\The Sims 3"
    # clear the game's cache
    Clear-Sims3Cache
}
finally {
    Pop-Location
    Write-Host -NoNewLine 'Press any key to continue...';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
}

# the launch command is at "C:\Program Files (x86)\Electronic Arts\The Sims 3\Game\Bin\Sims3Launcher.exe"
# launch the game, passing the command line arguments
& "C:\Program Files (x86)\Electronic Arts\The Sims 3\Game\Bin\Sims3Launcher.exe" $args
