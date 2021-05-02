#!/usr/bin/env pwsh

$PYTHON_VERSION = python --version | Select-String '^Python (\d\.\d).*' |
                                     ForEach-Object{$_.Matches.Groups[1].Value}

# $BOOST_ROOT = (((Resolve-Path -Path "boost_1_74_0") -replace "\\","/") -replace ":","").ToLower().Trim("/")
# $BOOST_CHOCO_ROOT = C:\Program Files\boost\boost_1_54_0

$BOOST_ROOT = (Resolve-Path -Path "boost_1_74_0")

# Check if 32 bits or 64 bits
python -c "import sys; assert sys.maxsize > 2**32"

# If last command ran succesful then python is 64bts, else 32bits
if ($LASTEXITCODE -eq 0) {
  $PYTHON_ARCH = "x64"
} else {
  $PYTHON_ARCH = "Win32"
}

# Used for repair the wheel in windows
pip install delvewheel

Write-Host "BOOST_ROOT = $BOOST_ROOT"
Write-Host "PYTHON_VERSION = $PYTHON_VERSION"
Write-Host "PYTHON_ARCH = $PYTHON_ARCH"

New-Item -Path "REmatch/build" -ItemType Directory

cd REmatch/build

cmake -A "$PYTHON_ARCH" -DSWIG=true -DPYTHON_VERSION="$PYTHON_VERSION" -DBOOST_ROOT="$BOOST_ROOT" ..
cmake --build . --config Release

cd ..

Write-Host "ls REmatch/python/packages/pyrematch"
Get-ChildItem REmatch/python/packages/pyrematch

Copy-Item "python\packages\pyrematch\Release\_rematch.pyd" -Destination "python\packages\pyrematch"

# Need to remove build dir so next iteration of cibuildwheel doesn't crash
Remove-Item "build" -Recurse

python setup.py bdist_wheel