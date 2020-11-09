# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function pre_build {
  if [ -n "$IS_OSX" ]; then
      brew update
      brew install swig
      brew install cmake
      brew install boost
  else
      # Install SWIG
      curl -O -L http://downloads.sourceforge.net/swig/swig-4.0.2.tar.gz
      tar xzf swig-4.0.2.tar.gz
      (cd swig-4.0.2 \
      && ./configure --prefix=$BUILD_PREFIX \
      && make \
      && make install)

      # Install CMake
      wget https://cmake.org/files/v3.18/cmake-3.18.4.tar.gz
      tar zxvf cmake-3.*
      (cd cmake-3.* \
      && ./bootstrap --prefix=$BUILD_PREFIX \
      && make -j8 \
      && make install)

      cmake --version

      # Install Boost
      yum install boost-devel
	fi
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
    export NOSE_PROCESS_TIMEOUT=600
    export NOSE_PROCESSES=0
    echo "OS X? $IS_OSX"
    rm -f /usr/local/lib/libglpk*
    # Run Pillow tests from within source repo
    cp ../test_swiglpk.py .
    nosetests -v
}