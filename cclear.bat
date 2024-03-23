:: @echo off
set OD=%CD%
IF "%CD:The Sims 3=%"=="%CD%" GOTO BadPath
:LoopStart
if "%CD:~-10%"=="The Sims 3" GOTO LoopEnd
cd ..
:LoopEnd

:: @cd "C:\Users\kel\Documents\Electronic Arts\The Sims 3"

:: remove the *Cache package files
for %%C in (CASPartCache.package,compositorCache.package,scriptCache.package,simCompositorCache.package,socialCache.package,Thumbnails\CASThumbnails.package,Thumbnails\ObjectThumbnails.package) DO (del %%C)

:: remove temp package files in DCBackup, but do not remove ccmerged.package
for %%C in (DCBackup\0x*.package) DO (del %%C)

:: clean up script dumps and crash dumps
for %%C in (xcpt*.*,ScriptError_*.*,KW*.xml) DO (del "%%C")

:: clean up FeaturedItems (ads for Store Content)
for %%C in (FeaturedItems\*.*) DO (del "%%C")

:: make sure FeaturedItems cannot have new content downloaded
:: make sure ACLs are clean before denying: WD - write data/add file
icacls FeaturedItems /reset
icacls FeaturedItems /deny %username%:(OI)(CI)(WD)

:: clean up DCCache TMP files
for %%C in (DCCache\*.tmp) DO (del "%%C")

GOTO End

:BadPath
echo "*\The Sims 3\" not found
pause

:End
cd %OD%
pause