# simple script/function to check the working directory, for debugging
# shortcuts in Windows Explorer
function Checker {

    Write-Host "Current working directory: " -NoNewline
    Write-Host $PWD -ForegroundColor Green

    Write-Host -NoNewLine 'Press any key to continue...';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
}

# run if invoked from the command line
if ($MyInvocation.InvocationName -ne '.') {
    Checker
}
