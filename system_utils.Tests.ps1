BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe 'Get-DisplayResolution' {
    It 'returns a custom object with Width and Height properties' {
        $resolution = Get-DisplayResolution
        $resolution | Should -Not -BeNullOrEmpty
        $resolution.PSObject.Properties.Name | Should -Contain 'Width'
        $resolution.PSObject.Properties.Name | Should -Contain 'Height'
    }

    It 'returns integer values for width and height' {
        $resolution = Get-DisplayResolution
        $resolution.Width | Should -BeOfType ([int])
        $resolution.Height | Should -BeOfType ([int])
    }

    It 'returns positive values for width and height' {
        $resolution = Get-DisplayResolution
        $resolution.Width | Should -BeGreaterThan 0
        $resolution.Height | Should -BeGreaterThan 0
    }
}

Describe 'Get-DisplayResolution (with mocking)' {
    It 'correctly uses the Width and Height from the primary screen object' {
        # Create a fake screen object to be returned by the mock.
        # Using a nested PSCustomObject to accurately mimic the real structure.
        $fakeScreen = [PSCustomObject]@{
            Bounds = [PSCustomObject]@{
                Width  = 1234
                Height = 5678
            }
        }

        # Mock the helper function to return our fake object
        Mock Get-PrimaryScreen { return $fakeScreen } -Verifiable

        # Run the function under test
        $resolution = Get-DisplayResolution

        # Verify the results
        $resolution.Width | Should -Be 1234
        $resolution.Height | Should -Be 5678
        Should -Invoke Get-PrimaryScreen -Exactly 1 # Verify the mock was called
    }

    It 'throws an exception when the underlying call throws' {
        # Mock the helper function to throw an exception
        Mock Get-PrimaryScreen { throw 'Forced Exception' } -Verifiable

        # Assert that calling the function results in an exception
        { Get-DisplayResolution } | Should -Throw 'Forced Exception'

        # Verify that the mock was called
        Should -Invoke Get-PrimaryScreen -Exactly 1
    }
}
