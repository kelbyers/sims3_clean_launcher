$OD = (Get-Location).Path
if ($PWD -like "*The Sims 3*") {

    # remove the *Cache package files:
    # CASPartCache: cache for CAS Parts (like hair and clothes)
    # compositorCache: cache for compositors, which are used to render Sims
    # scriptCache: cache for scripts, which are used to make Sims do things
    # simCompositorCache: cache for Sim compositors
    # socialCache: cache for social interactions, like Sims talking to each other
    # Thumbnails\CASThumbnails.package: thumbnails for CAS parts
    # Thumbnails\ObjectThumbnails.package: thumbnails for game objects
    @(
        "CASPartCache.package", 
        "compositorCache.package", 
        "scriptCache.package", 
        "simCompositorCache.package", 
        "socialCache.package", 
        "Thumbnails\CASThumbnails.package", 
        "Thumbnails\ObjectThumbnails.package"
    ) | ForEach-Object { Remove-Item "$_\*" }

    # remove temp package files in DCBackup, but do not remove ccmerged.package
    @(Get-ChildItem DCBackup -Filter "0x*.package" `
        | Where-Object { $_.Name -ne "ccmerged.package" }) `
    | Remove-Item

    # clean up script dumps and crash dumps
    @("xcpt*.*", "ScriptError_*.*", "KW*.xml") | ForEach-Object { Remove-Item "$_\*" }

    # clean up FeaturedItems (ads for Store Content)
    @(Get-ChildItem FeaturedItems -Recurse) | Remove-Item

    # make sure FeaturedItems cannot have new content downloaded
    # make sure ACLs are clean before denying
    Set-Acl -Path FeaturedItems -AclObject (Get-Acl -Path FeaturedItems) -Verbose
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $env:UserName, "ReadAndExecute", "None", "None", "Deny"
    $acl = Get-Acl FeaturedItems
    $acl.SetAccessRule($rule)
    Set-Acl FeaturedItems $acl

    # clean up DCCache TMP files
    @(Get-ChildItem DCCache -Filter "*.tmp") | Remove-Item

}
else {
    Write-Host "*\The Sims 3\ not found"
    Read-Host "Press Enter to continue"
}

Set-Location $OD
Read-Host "Press Enter to exit"
