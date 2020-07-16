$ErrorActionPreference = 'Stop'

function Enter-DevEnv {
    $vswhere = Join-Path ${env:ProgramFiles(x86)} '\Microsoft Visual Studio\Installer\vswhere.exe'
    $vsInfo = ConvertFrom-Json ((& $vswhere -products * -latest -format json) -join '')
    $devShell = Join-Path $vsInfo.installationPath '\Common7\Tools\Microsoft.VisualStudio.DevShell.dll'
    
    Import-Module $devShell
    Enter-VsDevShell $vsInfo.instanceId -DevCmdArgument '-arch=arm64 -host_arch=x64'
}

& {
    Enter-DevEnv

    $7zExe = Join-Path ${env:ProgramFiles} '\7-zip\7z.exe'

    # Source code to build ARM64 version from
    $7z1900Src = 'https://www.7-zip.org/a/7z1900-src.7z'
    $7z1900Dest = Join-Path ${env:BUILD_TEMP} '\7z1900-src'

    Start-BitsTransfer -Source $7z1900Src -Destination "${7z1900Dest}.7z"

    & $7zExe x -o"$7z1900Dest" "${7z1900Dest}.7z"

    Push-Location (Join-Path $7z1900Dest '\CPP\7zip')
    & nmake.exe /X - PLATFORM=arm64
    
    Pop-Location
}
