#!/bin/bash

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

cmake -B build -DSWIG=true -DPYTHON_VERSION=$PYTHON_VERSION

cmake --build build --config Release

echo "$ ls REmatch/python/packages/pyrematch"
ls REmatch/python/packages/pyrematch