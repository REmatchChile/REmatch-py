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
  else
    # SWIG depends on pcre and boost
    yum install -y pcre-devel boost-devel tree
    # Install SWIG
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

  mkdir -pv REmatch/build && cd REmatch/build

  cmake -DSWIG=true -DPYTHON_VERSION=$MB_PYTHON_VERSION -DPython_ROOT_DIR=$PYTHON_ROOT ..
  cmake --build . --config Release

  cd ../..

}

function build_wheel {
    # Set default building method to pip
    build_bdist_wheel $@
    # setup.py sdist fails with
    # error: [Errno 2] No such file or directory: 'venv/lib/python3.5/_dummy_thread.py'
    # for python less than 3.5
    if [[ `python -c 'import sys; print(sys.version.split()[0] >= "3.6.0")'` == "True" ]]; then
        python setup.py sdist --dist-dir $(abspath ${WHEEL_SDIR:-wheelhouse})
    else
        echo "skip sdist"
    fi
}

function run_tests {
  # Runs tests on installed distribution from an empty directory
  python --version
  # python -c 'import sys; import pyrematch; sys.exit(0)'
}