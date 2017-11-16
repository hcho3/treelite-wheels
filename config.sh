# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function repair_wheelhouse {
  :
}

function pre_build {
  # Any stuff that you need to do before you start building the wheels
  # Runs in the root directory of this repository.
  
  # 0. Build protobuf
  ROOTDIR=$PWD
  if [ ! -d "../protobuf" ]    # build protobuf only once
  then
    cd ..
    git clone --recursive https://github.com/google/protobuf.git
    cd protobuf
    if [ -n "$IS_OSX" ]
    then
      # install essential build tools
      brew update 1>&2
      brew install autoconf libtool curl gcc@7 1>&2
      ./autogen.sh
      CXXFLAGS=-fPIC CFLAGS=-fPIC CXX=g++-7 CC=gcc-7 ./configure --disable-shared
      make -j2
      sudo make install 1>&2
    else
      # install essential build tools
      yum install autoconf automake unzip gcc-c++ git -y 1>&2
      # compile libtool from source, as libtool package for CentOS 5 is very outdated
      wget -nv -nc http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.gz
      tar xvf libtool-2.4.6.tar.gz
      cd libtool-2.4.6
      ./configure
      make -j2
      make install 1>&2
      cd ..
      # now build protobuf
      ./autogen.sh 1>&2
      CXXFLAGS=-fPIC CFLAGS=-fPIC ./configure --disable-shared
      make -j2
      make install 1>&2
    fi
    cd $ROOTDIR
  fi

  # 1. Build treelite
  git submodule update --init --recursive   # fetch all submodules
  mkdir -p treelite/build
  cd treelite/build
  if [ -n "$IS_OSX" ]
  then
    cmake .. -DCMAKE_CXX_COMPILER=g++-7 -DCMAKE_C_COMPILER=gcc-7 1>&2
  else
    # install CMake 3.1
    if [ "$(uname -m)" == "i686" ]
    then
      wget -nv -nc https://cmake.org/files/v3.1/cmake-3.1.0-Linux-i386.sh --no-check-certificate
      bash cmake-3.1.0-Linux-i386.sh --skip-license --prefix=/usr
    else
      wget -nv -nc https://cmake.org/files/v3.1/cmake-3.1.0-Linux-x86_64.sh --no-check-certificate
      bash cmake-3.1.0-Linux-x86_64.sh --skip-license --prefix=/usr
    fi
    cmake .. 1>&2
  fi
  make -j2 1>&2
  cd $ROOTDIR
}

function run_tests {
  # Runs tests on installed distribution from an empty directory
  python --version
  python -c 'import sys; import treelite'
}
