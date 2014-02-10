#!/usr/bin/env bash

DOTFILES=`pwd`
DOTFILES_DIR=`echo $DOTFILES | sed "s|$HOME/||"`

# update the repo
if [ -d ".git" ]; then
  git pull origin master;
  git submodule update --init;
fi

# reading the profile
[ -f '~/.bash_profile' ] && source ~/.bash_profile;

cd $HOME

for FILE in "ack_completion" "bash_profile" "bash_functions" "gemrc" "gitconfig" "gitignore_global" "aprc" "rvmrc" "ackrc" "vim" "vim/gvimrc" "vim/vimrc" "fonts" "rspec"
do
  # linking project file, if exists
  if [ -f $DOTFILES_DIR/$FILE ] || [ -d $DOTFILES_DIR/$FILE ]; then
    ln -snf $DOTFILES_DIR/$FILE .${FILE##*/}
  fi
  ls -laG .${FILE##*/}
done

# Vim
mkdir -p ~/.vim/tmp ~/.vim/swap;

vim +BundleInstall +qall

# reading the profile
source ~/.bash_profile

