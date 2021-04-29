#!/usr/bin/env pwsh

$PYTHON_VERSION = python --version | Select-String '^Python (\d\.\d).*' |
                                     ForEach-Object{$_.Matches.Groups[1].Value}

$BOOST_ROOT = (((Resolve-Path -Path "boost_1_74_0") -replace "\\","/") -replace ":","").ToLower().Trim("/")
# $BOOST_CHOCO_ROOT = C:\Program Files\boost\boost_1_54_0

Write-Host "BOOST_ROOT = $BOOST_ROOT"
Write-Host "BOOST_ROOT_1_72_0 = $BOOST_ROOT_1_72_0"
Write-Host "PYTHON_VERSION = $PYTHON_VERSION"

New-Item -Path "REmatch/build" -ItemType Directory

cd REmatch/build

cmake -DSWIG=true -DPYTHON_VERSION="$PYTHON_VERSION" ..
cmake --build . --config Release

cd ..

Write-Host "ls REmatch/python/packages/pyrematch"
Get-ChildItem REmatch/python/packages/pyrematch

Copy-Item "python\packages\pyrematch\Release\_rematch.pyd" -Destination "python\packages\pyrematch"

python setup.py bdist_wheel