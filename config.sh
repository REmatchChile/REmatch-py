# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function pre_build {
  echo "\$ which python"
  export PYTHON_ROOT=$(dirname $(dirname $(which python)))
  echo $PYTHON_ROOT
  echo "\$ python --version"
  python --version
  if [ -n "$IS_OSX" ]; then
    # brew update
    brew install swig cmake boost tree
    # tree $PYTHON_ROOT
  else
    # SWIG depends on pcre and boost
    yum install -y pcre-devel boost-devel python-devel
    # Install SWIG
    # tree $PYTHON_ROOT
    curl -O -L http://downloads.sourceforge.net/swig/swig-4.0.2.tar.gz
    tar xzf swig-4.0.2.tar.gz
    (cd swig-4.0.2 \
    && ./configure --prefix=$BUILD_PREFIX \
    && make \
    && make install) > /dev/null

    # Install CMake
    pip install cmake

    cmake --version
	fi
}

# function build_wheel {
#   ls

#   mkdir -pv REmatch/build && cd REmatch/build

#   # -DPython3_EXECUTABLE=$PYTHON_ROOT/bin/python -DPython3_LIBRARY=$PYTHON_ROOT/lib -DPython3_INCLUDE_DIR=$PYTHON_ROOT/include ..
#   cmake -DSWIG=true -DPYTHON_VERSION=$MB_PYTHON_VERSION ..
#   cmake --build . --config Release

#   cd ../..


#   # Set default building method to pip
#   build_bdist_wheel $@
# }

function run_tests {
  # Runs tests on installed distribution from an empty directory
  python --version
  python -c 'import sys; import pyrematch; sys.exit(0)'
}