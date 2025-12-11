BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
    $sims3OptionsIniPath = 'TestDrive:\Options.ini'
    $sims3DefaultOptionsPath = "C:\Users\kel\Documents\Electronic Arts\The Sims 3\Options.ini"
}



Describe 'CheckGameOptions' {
    BeforeEach {
        Set-Content -Path $sims3OptionsIniPath -Value '[options]'
    }

    Describe 'Get-GameOptions' {
        It 'loads the game options' {
            # add some options to the file
            Add-Content -Path $sims3OptionsIniPath -Value 'option1 = three'
            Add-Content -Path $sims3OptionsIniPath -Value 'option2 = four'
            $options = Get-GameOptions -OptionsIniPath $sims3OptionsIniPath
            $options['option1'] | Should -Be 'three'
            $options['option2'] | Should -Be 'four'
        }
        It 'informs the user if the file cannot be found' {
            Get-GameOptions -OptionsIniPath 'TestDrive:\does_not_exist.ini' | Should -BeNullOrEmpty
        }

        It 'loads from a default file if none provided' {
            Mock Get-IniFile {
                return @{options = @{path = 'default'}}
            } -ParameterFilter { $Path -and $Path -eq $sims3DefaultOptionsPath }

            $loadedOptions = Get-GameOptions
            $loadedOptions['path'] | Should -Be 'default'
        }
    }

    Describe 'Get-BooleanOption' {
        It 'detects when an option is enabled' {
            Add-Content -Path $sims3OptionsIniPath -Value 'option1 = 1'
            Get-BooleanOption -OptionsIniPath $sims3OptionsIniPath -key option1 | Should -Be $true
        }

        It 'detects when an option is disabled' {
            Add-Content -Path $sims3OptionsIniPath -Value 'option1 = 0'
            Get-BooleanOption -OptionsIniPath $sims3OptionsIniPath -key option1 | Should -Be $false
        }

        It 'defaults to false when the option is not set' {
            Get-BooleanOption -OptionsIniPath $sims3OptionsIniPath -key option1 | Should -Be $false
        }

        It 'can use a provided default when the option is not set' {
            Get-BooleanOption -OptionsIniPath $sims3OptionsIniPath -key option1 -defaultTrue | Should -Be $true
        }

        It 'uses a default options file if none is provided' {
            Mock Get-IniFile {
                return @{options = @{path = 'default'}}
            } -ParameterFilter { $Path -and $Path -eq $sims3DefaultOptionsPath }
            Get-BooleanOption
            Should -Invoke Get-IniFile
        }
    }

    Describe 'Get-Fullscreen' {
        It 'detects when fullscreen is enabled' {
            Add-Content -Path $sims3OptionsIniPath -Value 'fullscreen = 1'
            Get-Fullscreen -OptionsIniPath $sims3OptionsIniPath | Should -Be $true
        }

        It 'detects when fullscreen is disabled' {
            Add-Content -Path $sims3OptionsIniPath -Value 'fullscreen = 0'
            Get-Fullscreen -OptionsIniPath $sims3OptionsIniPath | Should -Be $false
        }

        It 'shows fullscreen is enabled when the file cannot be found' {
            Get-Fullscreen -OptionsIniPath 'TestDrive:\does_not_exist.ini' | Should -Be $true
        }

        It 'defaults to fullscreen when the option is not set' {
            Get-Fullscreen -OptionsIniPath $sims3OptionsIniPath | Should -Be $true
        }

        It 'uses a default options file if none is provided' {
            Mock Get-IniFile {
                return @{options = @{path = 'default'; fullscreen = 0}}
            } -ParameterFilter { $Path -and $Path -eq $sims3DefaultOptionsPath }
            Get-Fullscreen | Should -Be $false
            Should -Invoke Get-IniFile
        }

    }

    Describe 'Should-Start-BorderlessGaming' {
        It 'returns false when fullscreen is enabled' {
            $options = @{ fullscreen = '1'; resolution = '1920 1080 0' }
            Should-Start-BorderlessGaming -GameOptions $options | Should -Be $false
        }

        It 'returns false when fullscreen is not set (defaults to true)' {
            $options = @{ resolution = '1920 1080 0' }
            Should-Start-BorderlessGaming -GameOptions $options | Should -Be $false
        }

        It 'returns true when windowed and resolution matches' {
            Mock Get-DisplayResolution { return [PSCustomObject]@{ Width = 1920; Height = 1080 } }
            $options = @{ fullscreen = '0'; resolution = '1920 1080 0' }
            Should-Start-BorderlessGaming -GameOptions $options | Should -Be $true
        }

        It 'returns false when windowed and resolution does not match' {
            Mock Get-DisplayResolution { return [PSCustomObject]@{ Width = 1920; Height = 1080 } }
            $options = @{ fullscreen = '0'; resolution = '1600 900 0' }
            Should-Start-BorderlessGaming -GameOptions $options | Should -Be $false
        }

        It 'returns false when windowed and horizontal resolution does not match' {
            Mock Get-DisplayResolution { return [PSCustomObject]@{ Width = 1920; Height = 1080 } }
            $options = @{ fullscreen = '0'; resolution = '1921 1080 0' }
            Should-Start-BorderlessGaming -GameOptions $options | Should -Be $false
        }

        It 'returns false when windowed and vertical resolution does not match' {
            Mock Get-DisplayResolution { return [PSCustomObject]@{ Width = 1920; Height = 1080 } }
            $options = @{ fullscreen = '0'; resolution = '1920 1081 0' }
            Should-Start-BorderlessGaming -GameOptions $options | Should -Be $false
        }

        It 'returns false when resolution key is missing' {
            Mock Get-DisplayResolution { return [PSCustomObject]@{ Width = 1920; Height = 1080 } }
            $options = @{ fullscreen = '0' }
            Should-Start-BorderlessGaming -GameOptions $options | Should -Be $false
        }

        It 'throws when Get-DisplayResolution throws' {
            Mock Get-DisplayResolution { throw 'Display Error' }
            $options = @{ fullscreen = '0'; resolution = '1920 1080 0' }
            { Should-Start-BorderlessGaming -GameOptions $options } | Should -Throw 'Display Error'
        }

        It 'throws when game resolution string is malformed' {
            Mock Get-DisplayResolution { return [PSCustomObject]@{ Width = 1920; Height = 1080 } }
            $options = @{ fullscreen = '0'; resolution = '1920_bad_string' }
            { Should-Start-BorderlessGaming -GameOptions $options } | Should -Throw
        }
    }
}
