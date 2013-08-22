#!/usr/bin/env bash

DOTFILES=`pwd`
DOTFILES_DIR=`echo $DOTFILES | sed "s|$HOME/||"`

# reading the profile
source ~/.bash_profile

# Files to link
# .bash_profile
# .bash_functions
# .gemrc
# .gitconfig
# .gitignore_global
# .aprc
# .rvmrc
# .ackrc
# .gvimrc
# .vim
# .vimrc
# .fonts

cd $HOME

for FILE in "bash_profile" "bash_functions" "gemrc" "gitconfig" "gitignore_global" "aprc" "rvmrc" "ackrc" "vim/gvimrc" "vim" "vim/vimrc" "vim/fonts"
do
  # linking project file, if exists
  if [ -f $DOTFILES_DIR/$FILE ]; then
    ln -sfn $DOTFILES_DIR/$FILE .${FILE##*/}
  fi
  ls -laG .${FILE##*/}
done

# Vim
mkdir -p ~/.vim/tmp ~/.vim/swap;
git submodule update --init;

vim +BundleInstall +qall

# reading the profile
source ~/.bash_profile

