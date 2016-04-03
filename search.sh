#!/usr/bin/env bash

#
# Alex Cummaudo - 1744070
# Intro to AI - Assignment 1
# Run Script
#

EXECUTABLE="bin/search"
SOURCE_CODE="src/*.swift"
OS=$(uname)

#
# Check that X11 is installed
#
function check_x11() {
  XTERM_INSTALLED=$(which xterm 2>&1 >/dev/null; echo $?)
  echo "Checking for X11..."
  if [ $XTERM_INSTALLED -ne 0 ]; then
    echo "You don't have X11 installed!"
    if [ "$OS" == "Darwin" ]; then
      echo "Please install XQuartz from http://xquartz.org, reboot and try again"
    elif [ "$OS" == "Linux" ]; then
      echo "I will try to install X11 for you now"
      echo "  sudo apt-get install libx11-dev"
      if [ $? -ne 0 ]; then
        echo "Couldn't install X11 :'("
        echo "Please don't fail me - I tried!"
        echo "Can you email me at acummaudo@swin.edu.au and we can work out why?"
      fi
    fi
    exit 1
  fi
  # Check display
  if [ -z $DISPLAY ]; then
    echo "X11 is installed but the \$DISPLAY variable is not set. Please reboot and try again."
    exit 1
  fi
  X11_INCLUDE="/usr/local/include"
  X11_LIB="/usr/local/lib/X11"
  echo "Ensuring required soft links for X11 are set up..."
  if [ ! -d "$X11_INCLUDE" ] || [ ! -d "$X11_LIB" ]; then
    echo "Setting up required soft links for X11..."
    if [ "$OS" == "Darwin" ]; then
      ln -s /usr/X11/include/X11 $X11_INCLUDE
      ln -s /usr/X11/lib $X11_LIB
    elif [ "$OS" == "Linux" ]; then
      echo "Running with sudo:"
      echo "  sudo ln -s /usr/include/X11 $X11_INCLUDE"
      sudo ln -s /usr/include/X11 $X11_INCLUDE
      echo "  sudo ln -s /usr/lib/X11 $X11_LIB"
      sudo ln -s /usr/lib/X11 $X11_LIB
    fi
  fi
  echo "OK - X11 is installed correctly!"
}

#
# Check that swift 2.2 is installed
#
function check_swift_version() {
  SWIFT_INSTALLED=$(which swiftc 2>&1 >/dev/null; echo $?)
  SWIFT_VERSION_22=$(swiftc -v 2>&1 >/dev/null | grep -c 2.2)

  echo "Checking your Swift compiler version..."
  if [ $SWIFT_INSTALLED -ne 0 ] || [ $SWIFT_VERSION_22 -ne 1 ]; then
    echo "You do not have the Swift 2.2 compiler installed on this machine"
    echo "Please download and install Swift 2.2 from http://swift.org/download"
    if [ "$OS" == "Darwin" ]; then
      OS_INSTALL_DOWNLOAD="installation"
    elif [ "$OS" == "Linux" ]; then
      OS_INSTALL_DOWNLOAD="installation-1"
    fi
    echo "and follow installation instructions here https://swift.org/download/#$OS_INSTALL_DOWNLOAD"
    exit 1
  else
    echo "OK - Swift 2.2 is installed!"
  fi
}

#
# Compiles Swift source to exeuctable
#
function compile_src() {
  echo "Compiling Swift source code..."
  mkdir -p $(dirname $EXECUTABLE)
  if [ "$OS" == "Darwin" ]; then
    xcrun -sdk macosx \
      swiftc $SOURCE_CODE -o $EXECUTABLE \
        -lX11 -L/usr/local/lib/X11 \
        -I/usr/local/include/X11 \
        -I$(pwd)/lib/CX11
  elif [ "$OS" == "Linux" ]; then
    swiftc $SOURCE_CODE -o $EXECUTABLE \
      -lX11 -L/usr/local/lib/X11 \
      -I/usr/local/include/X11 \
      -I$(pwd)/lib/CX11
  fi
  if [ $? -ne 0 ]; then
    echo "Couldn't build my code on your machine :'("
    echo "Please don't fail me - I tried!"
    echo "Can you email me at acummaudo@swin.edu.au and we can work out why?"
    exit 1
  fi
}

# Don't even bother if not OS X or Linux
if [ "$OS" != "Darwin" ] && [ "$OS" != "Linux" ]; then
  echo "This OS cannot compile or run the required software. Use Linux (Ubuntu) or OS X."
  exit 1
fi

# Make sure we run wherever the shell script is
cd "$(dirname $0)"

# Build the executable if it is not yet build
if [ ! -x $EXECUTABLE ]; then
  echo "Source not yet compiled!"
  check_swift_version
  check_x11
  compile_src
  echo "Compiled! Running $EXECUTABLE"
fi

# Now run it
$EXECUTABLE "$@"
