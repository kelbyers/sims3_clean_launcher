BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
    $version = '567.89'
    $sims3OptionsIniPath = 'TestDrive:\Options.ini'
    $expectedFile = 'TestDrive:\Expected.ini'

    $driver_version = "lastdevice = 0;10de;2486;6789"

    $startingOptions = @"
option1 = three

lastdevice = 0;10de;2486;XXXX

option2 = four
"@
    $expectedOptions = @"
option1 = three

lastdevice = 0;10de;2486;6789

option2 = four
"@
    Set-Content -Path $expectedFile -Value $expectedOptions
    Set-Content -Path $sims3OptionsIniPath -Value $startingOptions
}

Describe 'SetupNvidia' {
    BeforeEach {
        Mock nvidia-smi { return $version }
    }

    It 'Updates The Sims 3''s options.ini file' {
        SetupNvidia -OptionsIniPath $sims3OptionsIniPath
        $result = Get-Content -Path $sims3OptionsIniPath
        $expected = Get-Content -Path $expectedFile
        
        $result | Should -Be $expected
    }

    It 'Does not update the options.ini file if the driver version is already correct' {
        $driver_version | Set-Content -Path $sims3OptionsIniPath
        $timestamp = (Get-Item $sims3OptionsIniPath).LastWriteTime
        SetupNvidia -OptionsIniPath $sims3OptionsIniPath

        $timestamp | Should -Be (Get-Item $sims3OptionsIniPath).LastWriteTime
    }
}