function Clear-Sims3Cache {
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
        ) | ForEach-Object {
            Remove-Item "$_" -ErrorAction SilentlyContinue
        }

        # remove temp package files in DCBackup, but do not remove ccmerged.package
        @(Get-ChildItem DCBackup -Filter "0x*.package" `
            | Where-Object { $_.Name -ne "ccmerged.package" }) `
        | Remove-Item -ErrorAction SilentlyContinue

        # clean up script dumps and crash dumps
        @("xcpt*.*", "ScriptError_*.*", "KW*.xml") `
        | ForEach-Object { Get-ChildItem . -Filter "$_" | Remove-Item }

        # clean up FeaturedItems (ads for Store Content)
        @(Get-ChildItem FeaturedItems -Recurse) | Remove-Item -ErrorAction SilentlyContinue

        # make sure FeaturedItems cannot have new content downloaded
        # make sure ACLs are clean before denying: WD - write data/add file
        icacls FeaturedItems /reset
        $username = $env:UserName
        icacls FeaturedItems /deny "${username}:(OI)(CI)(WD)"

        # clean up DCCache TMP files
        @(Get-ChildItem DCCache -Filter "*.tmp") | Remove-Item -ErrorAction SilentlyContinue

    }
    else {
        Write-Host "*\The Sims 3\ not found"
        exit 1
    }    
}

