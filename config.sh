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
    brew install swig boost tree
    tree $PYTHON_ROOT
  else
    # SWIG depends on pcre and boost
    yum install -y pcre-devel python-devel tree
    yum update -y gcc

    gcc --version

    # Install SWIG
    tree $PYTHON_ROOT/include
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

  fi

  mkdir -pv REmatch/build && cd REmatch/build

  # -DPython3_EXECUTABLE=$PYTHON_ROOT/bin/python -DPython3_LIBRARY=$PYTHON_ROOT/lib -DPython3_INCLUDE_DIR=$PYTHON_ROOT/include ..
  if [ -n "$IS_OSX" ]; then
    cmake -DSWIG=true -DPYTHON_VERSION=$MB_PYTHON_VERSION  ..
  else
    cmake -DSWIG=true -DPython3_INCLUDE_DIRS=$PYTHON_ROOT/include ..
  fi
  cmake --build . --config Release

  cd ../..
}

function run_tests {
  # Runs tests on installed distribution from an empty directory
  python --version
  python -m pyrematch.test_basic_operation
}