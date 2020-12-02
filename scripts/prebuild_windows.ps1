#!/usr/bin/env pwsh

$PYTHON_VERSION = python --version | Select-String '^Python (\d\.\d).*' |
                                     ForEach-Object{$_.Matches.Groups[1].Value}

$BOOST_ROOT = (((Resolve-Path -Path "boost_1_74_0") -replace "\\","/") -replace ":","").ToLower().Trim("/")

Write-Host "BOOST_ROOT = $BOOST_ROOT"
Write-Host "PYTHON_VERSION = $PYTHON_VERSION"

New-Item -Path "REmatch/build" -ItemType Directory

cd REmatch/build

cmake -DSWIG=true -DPYTHON_VERSION="$PYTHON_VERSION" -DBoost_INCLUDE_DIR="boost_1_74_0" ..
cmake --build . --config Release

cd ../..

Write-Host "ls REmatch/python/packages/pyrematch"
Get-ChildItem REmatch/python/packages/pyrematch