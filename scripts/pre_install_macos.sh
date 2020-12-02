#!/bin/bash

echo "$ python --version"
python --version

echo "$ which python"
which python

brew install swig boost

mkdir -pv REmatch/build && cd REmatch/build

cmake -DSWIG=true -DPYTHON_VERSION=$MB_PYTHON_VERSION  ..

cmake --build . --config Release

cd ../..