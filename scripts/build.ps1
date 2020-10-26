param (
	[Alias("MsBuild")]
	[Parameter(Position = 0)]
	[ValidateScript( { Test-Path -LiteralPath $_ -PathType Leaf })]
	[string]
	$MsBuildPath = "",

	[Alias("CMake")]
	[string] $CMakePath,

	# Configurations
	[switch] $NDebug,
	[switch] $NRelease
)

$ErrorActionPreference = "Stop"

$local:RootFolder = Split-Path $PSScriptRoot -Parent
$local:ModulesFolder = "$RootFolder\scripts\modules"
$local:BinaryDirectory = "$RootFolder\bin"
$local:DependenciesRoot = "$RootFolder\deps"

$local:FreeAlutFolder = Join-Path -Path $DependenciesRoot -ChildPath "freealut"
$local:OpenAlSoftFolder = Join-Path -Path $DependenciesRoot -ChildPath "openal-soft"

Import-Module -Name (Join-Path -Path $ModulesFolder -ChildPath "MsBuild")
Import-Module -Name (Join-Path -Path $ModulesFolder -ChildPath "CMake")
Import-Module -Name (Join-Path -Path $ModulesFolder -ChildPath "Shared")

# Find and assert MSBuild and CMake
$local:MsBuild = Find-MsBuild -MsBuildPath $MsBuildPath
$local:CMake = Find-CMake -CMakePath $CMakePath

Try {
	# Build OpenAL
	Step-CMake $CMake $OpenAlSoftFolder @()
	Step-VisualStudio -MsBuild $MsBuild -Path "$OpenAlSoftFolder\build\OpenAL.sln" -Configuration "Release"

	Write-Host "Done! Library file written at "               -ForegroundColor Green -NoNewLine
	Write-Host "$OpenAlSoftFolder\build\Release\OpenAL32.lib" -ForegroundColor Blue  -NoNewLine
	Write-Host "!"                                            -ForegroundColor Green

	# Build FreeALUT
	Step-CMake $CMake $FreeAlutFolder @(
		"-DOPENAL_INCLUDE_DIR:PATH=$OpenAlSoftFolder\include\AL",
		"-DOPENAL_LIBRARY:PATH=$OpenAlSoftFolder\build\Release\OpenAL32.lib"
	)
	Step-VisualStudio -MsBuild $MsBuild -Path "$FreeAlutFolder\build\Alut.sln" -Configuration "Release"

	Write-Host "Done! Library file written at "             -ForegroundColor Green -NoNewLine
	Write-Host "$FreeAlutFolder\build\src\Release\alut.lib" -ForegroundColor Blue  -NoNewLine
	Write-Host "!"                                          -ForegroundColor Green

	New-Directory -Path $BinaryDirectory
	Copy-Item -Path "$FreeAlutFolder\build\src\Release\alut.dll" -Destination "$BinaryDirectory\alut.dll"

	Write-Host ""
	Write-Host "Also copied"                                -ForegroundColor Green
	Write-Host "<- "                                        -ForegroundColor Green -NoNewLine
	Write-Host "$FreeAlutFolder\build\src\Release\alut.dll" -ForegroundColor Blue
	Write-Host "-> "                                        -ForegroundColor Green -NoNewLine
	Write-Host "$BinaryDirectory\alut.dll"                  -ForegroundColor Blue  -NoNewLine
	Write-Host "."                                          -ForegroundColor Green
	Write-Host ""
	Write-Host "🚀 Your project is ready to go!"            -ForegroundColor Green -NoNewLine

	Exit 0
}
Catch {
	# Write the exception
	Write-Host -Object $_
	Write-Host -Object $_.Exception
	Write-Host -Object $_.ScriptStackTrace

	Exit 1
}
Finally {
	# Unregister modules
	Remove-Module MsBuild
	Remove-Module CMake
	Remove-Module Shared
}
