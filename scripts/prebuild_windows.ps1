#!/usr/bin/env pwsh

# Retrive Python version
$PYTHON_VERSION = python --version | Select-String '^Python (\d\.\d).*' |
                                     ForEach-Object{$_.Matches.Groups[1].Value}

# Retrive Boost path to give to CMake later
$BOOST_ROOT = (Resolve-Path -Path "boost_1_74_0")

# Check if 32-bit or 64-bit Python
python -c "import sys; assert sys.maxsize > 2**32"

# If last command ran succesful then Python is 64bts, else 32bits
if ($LASTEXITCODE -eq 0) {
  $PYTHON_ARCH = "x64"
} else {
  $PYTHON_ARCH = "Win32"
}

# Used for repair the wheel in windows
pip install delvewheel

# Print env variables to give to CMake
Write-Host "BOOST_ROOT = $BOOST_ROOT"
Write-Host "PYTHON_VERSION = $PYTHON_VERSION"
Write-Host "PYTHON_ARCH = $PYTHON_ARCH"

# Run CMake and build

cmake -B build -A "$PYTHON_ARCH" -DSWIG=true -DPYTHON_VERSION="$PYTHON_VERSION" -DBOOST_ROOT="$BOOST_ROOT"

cmake --build build --config Release

# Check the contents of the package before building
Write-Host "ls python/packages/pyrematch"
Get-ChildItem python/packages/pyrematch

# No idea why the .pyd file ends up inside a Release folder in windows
# (mac and linux don't seem to do this). So manually copy the
# file to its correct location
Copy-Item "python\packages\pyrematch\Release\_rematchpy.pyd" -Destination "python\packages\pyrematch"

# Need to remove build dir so cibuildwheel doesn't crash in the next iteration
Remove-Item "build" -Recurse

# Finally build
# python setup.py bdist_wheel