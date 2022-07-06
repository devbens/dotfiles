#!/bin/sh

export DOTFILES=$HOME/.dotfiles

if [ ! -d $DOTFILES ]; then
  echo "Installing Devbens Dotfiles for the first time:"
  git clone https://github.com/devbens/dotfiles.git "$HOME/.dotfiles"
  cd $DOTFILES
else
  echo "The Devbens Dotfiles are already installed. Let's make sure it's up to date."
  cd $DOTFILES
  git pull --rebase --stat origin master
fi

/usr/bin/env sudo bash -c "$DOTFILES/script/bootstrap"
