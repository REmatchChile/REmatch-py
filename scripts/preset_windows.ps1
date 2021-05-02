#!/usr/bin/env pwsh

# Use chocolatey to install cmake and swig
choco install swig cmake --no-progress

# Download Boost from main source. No need to compile as we use header-only
# modules for now (spirit, phoenix, etc.).
$url = "https://dl.bintray.com/boostorg/release/1.74.0/source/boost_1_74_0.7z"
$output = "boost_1_74_0.7z"

(New-Object System.Net.WebClient).DownloadFile($url, $output)

7z x boost_1_74_0.7z

Write-Host "Downloaded boost 1.74.0"