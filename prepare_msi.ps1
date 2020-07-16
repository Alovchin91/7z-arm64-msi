$ErrorActionPreference = 'Stop'

$msiBuildDir = Join-Path ${env:BUILD_TEMP} '\msi'
$msiFilesDir = Join-Path $msiBuildDir '\Files\7-zip'

$7zSourceDir = Join-Path ${env:BUILD_TEMP} '\7z1900-src'

function Copy-MsiFiles {
    $7zBuildDir = Join-Path $7zSourceDir '\CPP\7zip'

    Copy-Item (Join-Path $7zBuildDir '\UI\Explorer\arm64\7-zip.dll') -Destination $msiFilesDir
    Copy-Item (Join-Path $7zBuildDir '\Bundles\Format7zF\arm64\7z.dll') -Destination $msiFilesDir
    Copy-Item (Join-Path $7zBuildDir '\UI\Console\arm64\7z.exe') -Destination $msiFilesDir
    Copy-Item (Join-Path $7zBuildDir '\Bundles\SFXWin\arm64\7z.sfx') -Destination $msiFilesDir
    Copy-Item (Join-Path $7zBuildDir '\Bundles\SFXCon\arm64\7zCon.sfx') -Destination $msiFilesDir
    Copy-Item (Join-Path $7zBuildDir '\UI\FileManager\arm64\7zFM.exe') -Destination $msiFilesDir
    Copy-Item (Join-Path $7zBuildDir '\UI\GUI\arm64\7zG.exe') -Destination $msiFilesDir

    Copy-Item (Join-Path ${env:WORKSPACE_DIR} '\7z_license.rtf') `
        -Destination (Join-Path $msiBuildDir '\license.rtf')
}

& {
    $7zExe = Join-Path ${env:ProgramFiles} '\7-zip\7z.exe'

    mkdir $msiFilesDir
    Copy-MsiFiles

    # 7z installer to copy some installable files from
    $7z1900exe = 'https://www.7-zip.org/a/7z1900-x64.exe'
    $7z1900dest = Join-Path ${env:BUILD_TEMP} '\7z1900-x64.exe'

    Start-BitsTransfer -Source $7z1900exe -Destination $7z1900dest

    & $7zExe x -o"$msiFilesDir" "$7z1900dest" `
        "7-zip.chm" "descript.ion" "History.txt" "License.txt" "readme.txt" "Lang"
}
