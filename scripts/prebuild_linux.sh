#!/bin/bash

function abspath {
    # Can work with any Python; need not be our installed Python.
    python -c "import os.path; print(os.path.abspath('$1'))"
}

# Install CMake. Do it with pip as yum repos might be too outdated.
pip install cmake
cmake --version

export BOOST_ROOT=$(abspath boost_1_74_0)
echo "$ echo BOOST_ROOT"
echo $BOOST_ROOT

echo "$ python --version"
python --version
export PYTHON_VERSION=$(python --version | sed -En 's/Python ([[:digit:]]\.[[:digit:]]).*/\1/p')

echo "$ echo PYTHON_VERSION"
echo $PYTHON_VERSION

echo "$ which python"
which python

# As of this writing. CMake's FindPython is unable to find the correct Python
# include dirs. It doesn't even take hints. So, we must define the variable
# Python3_INCLUDE_DIRS by hand.

export PYTHON_ROOT=$(dirname $(dirname $(which python)))
echo "$ echo PYTHON_ROOT"
echo $PYTHON_ROOT

export PYTHON_INCLUDE_DIR=$(abspath $(find $PYTHON_ROOT/include -type d -name "python*"))
echo "$ echo PYTHON_INCLUDE_DIR"
echo $PYTHON_INCLUDE_DIR

mkdir -pv REmatch/build && cd REmatch/build

cmake -DSWIG=true -DPython3_INCLUDE_DIRS=$PYTHON_INCLUDE_DIR ..

cmake --build . --config Release

cd ../..

echo "$ ls REmatch/python/packages/pyrematch"
ls REmatch/python/packages/pyrematch