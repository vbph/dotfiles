#!/bin/sh

OS=$(uname -s)
DIR=$(pwd)

source $DIR/utils.sh

prettyecho Setup your $OS

# Create directories
prettyecho Create directories
mkdir -p $HOME/Projects/Personal
mkdir -p $HOME/Projects/Keys
mkdir -p $HOME/Dropbox

# Install everything
$DIR/install.sh

# Apply configs
$DIR/config.sh
