# 7-zip MSI installer for Windows on ARM64

This project contains build scripts to build the latest stable version of [7-zip](https://www.7-zip.org/) for Windows 10 on ARM.

The project aims to be easily auditable, so it only provides build scripts and patches for the original 7-zip source code.

## Building

Builds are run by GitHub Actions. Please go to the [Releases](https://github.com/Alovchin91/7z-arm64-msi/releases/latest) to find the latest available release.

If you would like to build an installer on your local machine, assuming that you are cross-compiling from an x64 machine, you will need the following prerequisites:

* 7-zip. It is used to extract the source code and other files from the existing installer.

* Microsoft Visual Studio / C++ Build Tools 2017 / 2019. The installation must include MSVC compiler for ARM64.

* Git for Windows. The build scripts use it to apply patches (`git apply`).

#### Running the scripts

The build process consists of 3 steps:

1. Building 7-zip source.

   To build 7-zip source code for ARM64, run `build_7z.ps1` script from PowerShell.
   The build script will use `vswhere.exe` to find your Visual Studio / Visual C++ Build Tools installation and enter the dev environment.
   It will then download 7-zip source code from the official website and compile it using `nmake.exe`.
   
2. Preparing files for the installer.

   The next step is to prepare the files that will be packed into the MSI installer (`prepare_msi.ps1`).
   The build script will collect the artifacts from step 1 and place them into a single directory.
   It will also download the existing 7-zip installer and extract some other files required by MSI installer into the same directory.
   
3. Building the MSI installer.

   This step (`build_msi.ps1`) uses [WiX Toolset](https://wixtoolset.org/) to compile the MSI installer.
   At the time of writing a prerelease version is required to compile an MSI for ARM64 platform.
   The build script will download WiX 3.14 from the official website, apply the patch to add ARM64 platform to the installer script
   (_DOC/7zip.wxs_ file) and compile the resulting MSI.
   
The result of this process would be an installer file `7z1900-arm64.msi` which can be used to install 7-zip on a Windows for ARM64 machine.

## Contributing

When contributing to this project, please keep in mind that its only goal is to provide a minimal pipeline to build an ARM64 installer
for the latest stable 7-zip version.

If you would like to see an official build, or something in 7-zip doesn't work as intended, please ask for help on the
[7-zip's Forum at SourceForge](https://sourceforge.net/p/sevenzip/discussion/45797/).

If something doesn't work as intended with the MSI installer, please ask for help on [WiX Toolset's GitHub](https://github.com/wixtoolset/issues/issues).

If you're confident that the issue is with this project specifically, please don't hesitate to file an issue or open a PR! :)
