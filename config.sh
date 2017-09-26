# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function pre_build {
  # Any stuff that you need to do before you start building the wheels
  # Runs in the root directory of this repository.
  
  # 0. Build protobuf
  git clone --recursive https://github.com/google/protobuf.git
  cd protobuf
  if [ -n "$IS_OSX" ]
  then
    brew install autoconf automake libtool curl gcc@7
    ./autogen.sh
    CXX=g++-7 CC=gcc-7 ./configure
  else
    sudo apt-get install autoconf automake libtool curl make g++ unzip
    ./autogen.sh
    ./configure
  fi
  make -j8
  sudo make install
  cd ..

  # 1. Build treelite
  mkdir -p treelite/build
  cd treelite/build
  if [ -n "$IS_OSX" ]
  then
    brew install gcc@7   # install an OpenMP-compatible compiler
    cmake .. -DCMAKE_CXX_COMPILER=g++-7 -DCMAKE_C_COMPILER=gcc-7
  else
    cmake ..
  fi
  make -j8
}

function run_tests {
  # Runs tests on installed distribution from an empty directory
  python --version
  python -c 'import sys; import treelite; sys.exit(yourpackage.test())'
}
