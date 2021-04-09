#!/usr/bin/env pwsh

choco install swig cmake boost-msvc-14.2 --no-progress

# $url = "https://dl.bintray.com/boostorg/release/1.74.0/source/boost_1_74_0.7z"
# $output = "boost_1_74_0.7z"

# (New-Object System.Net.WebClient).DownloadFile($url, $output)

# 7z x boost_1_74_0.7z