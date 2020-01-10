#!/bin/sh

# A simple Homebrew installation wrapper, to hide the platform-specific stanzas:
# macOS: https://brew.sh/
# Linux: https://docs.brew.sh/Homebrew-on-Linux#install

set -eu

abort_install() {
  echo "Aborting install! $1" >&2
  exit $2
}

curl_wrapper() {
  curl --fail --silent --show-error --location $1
}

# Note: if $USER is not set, a normal `-z "$USER"` check would error as we have
# enabled -u for unset variables. Instead we do a parameter expansion to safely
# default the variable to an ignored value if not set.
if [ -z ${USER+ignored} ]; then
  # Note: The Homebrew installation scripts both expect the USER environment
  # variable to be set, so just check upfront
  # https://github.com/Linuxbrew/install/issues/48
  # https://github.com/Linuxbrew/install/pull/49
  abort_install "No USER environment variable set" 1
fi

echo "USER is $USER"

if [ $(id -u) = 0 ]; then
  abort_install "Must not be run as root" 2
fi

if command -v brew >/dev/null 2>&1; then
  echo "Homebrew already installed 👍"
  exit
fi

required_packages="curl git"

for package in $required_packages; do
  if ! command -v $package >/dev/null 2>&1; then
    abort_install "No $package found - install using your package manager of choice" 3
  fi
done

echo "Installing Homebrew"
case $(uname) in
  Linux)
    sh -c "$(curl_wrapper https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    ;;
  Darwin)
    /usr/bin/ruby -e "$(curl_wrapper https://raw.githubusercontent.com/Homebrew/install/master/install)"
    ;;
  *)
    abort_install "Unsupported platform '$(uname)'" 4
    ;;
esac
