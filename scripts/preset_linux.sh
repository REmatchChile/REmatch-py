#!/bin/bash

function abspath {
    # Can work with any Python; need not be our installed Python.
    python -c "import os.path; print(os.path.abspath('$1'))"
}

yum install -y pcre-devel
yum update -y gcc

# Keep in mind the gcc version. Maybe is too old for c++ newest features
# (c++17 maybe)
gcc --version

# Install Swig 4.0.2
curl -O -L http://downloads.sourceforge.net/swig/swig-4.0.2.tar.gz
tar xzf swig-4.0.2.tar.gz

(cd swig-4.0.2 \
&& ./configure --prefix=$BUILD_PREFIX \
&& make \
&& make install) > /dev/null

# Install boost (will only work if REmatch only uses boost's headers)
curl -O -L https://dl.bintray.com/boostorg/release/1.74.0/source/boost_1_74_0.tar.gz
tar xzf boost_1_74_0.tar.gz
