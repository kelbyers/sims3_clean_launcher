# can be imported as a module
function SetupNvidia {
    param (
        [string]$OptionsIniPath = "C:\Users\kel\Documents\Electronic Arts\The Sims 3\Options.ini"
    )

    # get the current nvidia driver version, using nvidia-smi
    $driver_version = nvidia-smi --query-gpu=driver_version --format=csv,noheader

    # extract the driver version used by The Sims 3's options.ini file
    # Format: driver_version ABC.EF
    # Extract: BC.EF as BCEF

    $driver_version = $driver_version -replace '\d(\d+)\.(\d+)', '$1$2'

    # set the driver version in The Sims 3's options.ini file
    # change the line for lastdevice in the options.ini file
    # Format: lastdevice = 0;10de;2486;BCEF
    # and leave all the other lines are they currently are

    (Get-Content -Path $OptionsIniPath) `
        -replace 'lastdevice.+', "lastdevice = 0;10de;2486;${driver_version}" `
    | Set-Content -Path $OptionsIniPath
}
