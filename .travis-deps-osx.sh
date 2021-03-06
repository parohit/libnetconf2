#install dependencies using homebrew
brew update
brew upgrade openssl
brew install pcre

set -e

INSTALL_PREFIX_DIR=$HOME/local
export PKG_CONFIG_PATH=$INSTALL_PREFIX_DIR/lib/pkgconfig:$PKG_CONFIG_PATH

# use cache if present
if [ ! -d "$INSTALL_PREFIX_DIR/lib" ]; then
  echo "Building cache."
  cd ~

  # libssh
  wget https://git.libssh.org/projects/libssh.git/snapshot/libssh-0.7.3.tar.bz2
  tar -xjf libssh-0.7.3.tar.bz2
  mkdir libssh-0.7.3/build && cd libssh-0.7.3/build
  cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr .. && make -j2 && sudo make install
  cd ../..

  # CMocka
  wget https://cmocka.org/files/1.0/cmocka-1.0.1.tar.xz
  tar -xJf cmocka-1.0.1.tar.xz
  mkdir cmocka-1.0.1/build && cd cmocka-1.0.1/build
  cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr .. && make -j2 && sudo make install
  cd ../..

else
  echo "Using cache ($INSTALL_PREFIX_DIR)."
fi
  
git clone -b $TRAVIS_BRANCH https://github.com/CESNET/libyang.git
mkdir libyang/build && cd libyang/build
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr .. && make -j2 && sudo make install
cd ../..

