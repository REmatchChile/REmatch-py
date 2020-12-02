#!/bin/bash

function abspath {
    # Can work with any Python; need not be our installed Python.
    python -c "import os.path; print(os.path.abspath('$1'))"
}

echo "$ python --version"
python --version
export PYTHON_VERSION=$(python --version | sed -En 's/Python ([[:digit:]]\.[[:digit:]]).*/\1/p')

echo "$ echo PYTHON_VERSION"
echo $PYTHON_VERSION

echo "$ which python"
which python

export PYTHON_ROOT=$(dirname $(dirname $(which python)))
echo "$ echo PYTHON_ROOT"
echo $PYTHON_ROOT

yum install -y pcre-devel python-devel tree
yum update -y gcc

gcc --version

export PYTHON_INCLUDE_DIR=$(abspath $(find $PYTHON_ROOT/include -type d -name "python*"))

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
export BOOST_ROOT=$(abspath boost_1_74_0)

# Install CMake
pip install cmake
cmake --version


mkdir -pv REmatch/build && cd REmatch/build

cmake -DSWIG=true -DPython3_INCLUDE_DIRS=$PYTHON_INCLUDE_DIR ..

cmake --build . --config Release

cd ../..