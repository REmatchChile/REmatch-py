#!/usr/bin/env pwsh

$PYTHON_VERSION = python --version | Select-String '^Python (\d\.\d).*' |
                                     ForEach-Object{$_.Matches.Groups[1].Value}

# $BOOST_ROOT = (((Resolve-Path -Path "boost_1_74_0") -replace "\\","/") -replace ":","").ToLower().Trim("/")
# $BOOST_CHOCO_ROOT = C:\Program Files\boost\boost_1_54_0

$BOOST_ROOT = (Resolve-Path -Path "boost_1_74_0")

if ([Environment]::Is64BitOperatingSystem) {
  $PYTHON_ARCH = "x64"
} else {
  $PYTHON_ARCH = "Win32"
}

Write-Host "BOOST_ROOT = $BOOST_ROOT"
Write-Host "PYTHON_VERSION = $PYTHON_VERSION"
Write-Host "PYTHON_ARCH = $PYTHON_VERSION"

New-Item -Path "REmatch/build" -ItemType Directory

cd REmatch/build

cmake -A "$PYTHON_ARCH" -DSWIG=true -DPYTHON_VERSION="$PYTHON_VERSION" -DBOOST_ROOT="$BOOST_ROOT" ..
cmake --build . --config Release

cd ..

Write-Host "ls REmatch/python/packages/pyrematch"
Get-ChildItem REmatch/python/packages/pyrematch

Copy-Item "python\packages\pyrematch\Release\_rematch.pyd" -Destination "python\packages\pyrematch"

python setup.py bdist_wheel