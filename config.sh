# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function pre_build {
  # Any stuff that you need to do before you start building the wheels
  # Runs in the root directory of this repository.
  
  # 0. Build protobuf
  ROOTDIR=`pwd`
  if [ ! -d "../protobuf" ]    # build protobuf only once
  then
    cd ..
    git clone --recursive https://github.com/google/protobuf.git
    cd protobuf
    if [ -n "$IS_OSX" ]
    then
      brew install cmake autoconf automake libtool curl gcc@7
      ./autogen.sh
      CXX=g++-7 CC=gcc-7 ./configure
    else
      sudo apt-get update
      sudo apt-get install cmake autoconf automake libtool curl make g++ unzip
      ./autogen.sh
      ./configure
    fi
    make -j2 2>&1
    sudo make install 2>&1
    cd $ROOTDIR
  fi

  # 1. Build treelite
  git submodule update --init --recursive   # fetch all submodules
  mkdir -p treelite/build
  cd treelite/build
  if [ -n "$IS_OSX" ]
  then
    cmake .. -DCMAKE_CXX_COMPILER=g++-7 -DCMAKE_C_COMPILER=gcc-7 2>&1
  else
    cmake .. 2>&1
  fi
  make -j2 2>&1
}

function run_tests {
  # Runs tests on installed distribution from an empty directory
  python --version
  python -c 'import sys; import treelite; sys.exit(yourpackage.test())'
}
