$ErrorActionPreference = 'Stop'

$msiBuildDir = Join-Path ${env:BUILD_TEMP} '\msi'
$7zSourceDir = Join-Path ${env:BUILD_TEMP} '\7z1900-src'
$wix314Path = Join-Path ${env:BUILD_TEMP} '\wix314-binaries'

function Build-Msi {
    $candleExe = Join-Path $wix314Path '\candle.exe'
    $lightExe = Join-Path $wix314Path '\light.exe'

    Push-Location $7zSourceDir

    $gitExe = Join-Path ${env:ProgramFiles} '\Git\bin\git.exe'
    & $gitExe apply (Join-Path ${env:WORKSPACE_DIR} '\7z-arm64-wxs.patch')

    Pop-Location
    
    Push-Location $msiBuildDir
    
    & $candleExe -dMyCPU=arm64 -ext WixUIExtension -dWixUILicenseRtf='license.rtf' -sfdvital `
        (Join-Path $7zSourceDir '\DOC\7zip.wxs')
    
    & $lightExe -dMyCPU=arm64 -ext WixUIExtension -dWixUILicenseRtf='license.rtf' -cultures:en-us `
        -sice:ICE43 -sice:ICE57 -sice:ICE61 -sice:ICE64 -sice:ICE80 `
        -o "7z1900-arm64.msi" "7zip.wixobj"
    
    Pop-Location
}

& {
    $wix314Url = 'http://static.wixtoolset.org/releases/v3.14.0.4118/wix314-binaries.zip'

    Start-BitsTransfer -Source $wix314Url -Destination "${wix314Path}.zip"

    Expand-Archive -Path "${wix314Path}.zip" -Destination $wix314Path

    Build-Msi
}
