#!/bin/bash

# A simple Homebrew installation wrapper, to install any platform-specific prerequisites, before
# installing Homebrew.
# macOS: https://brew.sh/
# Linux: https://docs.brew.sh/Homebrew-on-Linux#install

set -eu

abort_install() {
  echo "Aborting install! $1" >&2
  exit $2
}

install_homebrew() {
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
}

# On macOS, the Homebrew executable (brew) is installed to /usr/local/bin, which is in the PATH
# by default on macOS (https://scriptingosx.com/2017/05/where-paths-come-from/). This means that on
# macOS, as long as Homebrew is installed, no further setup is necessary in order to use it.
# On Linux, Homebrew is installed to /home/linuxbrew/.linuxbrew using sudo if possible, and to
# ~/.linuxbrew otherwise (ie if sudo is not available). For this reason, the recommended approach
# (https://docs.brew.sh/Homebrew-on-Linux#install) is to check both possible install locations and
# call the `brew shellenv` command if found, to export the required env vars into the shell. This
# includes adding the right installation directory to the PATH so brew can be invoked.
initialise_homebrew_on_linux() {
  test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
  test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
}

# Note: if $USER is not set, a normal `-z "$USER"` check would error as we have
# enabled -u for unset variables. Instead we do a parameter expansion to safely
# default the variable to an ignored value if not set.
if [ -z ${USER+ignored} ]; then
  # Note: The Homebrew installation scripts both expect the USER environment
  # variable to be set, so just check upfront
  # https://github.com/Linuxbrew/install/issues/48
  # https://github.com/Linuxbrew/install/pull/49
  abort_install "No USER environment variable set" 3
fi

if [ $(id -u) = 0 ]; then
  abort_install "Must not be run as root" 4
fi

initialise_homebrew_on_linux || true

if command -v brew >/dev/null 2>&1; then
  echo "Homebrew already installed 👍"
  exit
fi

case $(uname) in
  Linux)
    if ! command -v apt-get >/dev/null 2>&1; then
      abort_install "Unsupported Linux package manager (no apt-get found)" 6
    fi
    echo "Installing prerequisites for $(uname)"
    sudo apt-get update -y && sudo apt-get install -y build-essential curl file git
    install_homebrew
    initialise_homebrew_on_linux || true
    # As per the Homebrew post installation message:
    # - We recommend that you install GCC by running:
    #     brew install gcc
    brew install gcc
    ;;
  Darwin)
    install_homebrew
    ;;
  *)
    abort_install "Unsupported platform '$(uname)'" 7
    ;;
esac

# Install ruby as it's required to run bamstrap, which bootstraps Bambrew
brew install ruby
