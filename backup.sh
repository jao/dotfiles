#!/usr/bin/env bash

# backup environment files

BACKUP_DIR=~/Dropbox/backup/macosx_dev_env
[ -d $BACKUP_DIR ] || mkdir -p $BACKUP_DIR
[ -d $BACKUP_DIR ] && ln -nfs $BACKUP_DIR ~/.backup


# Homebrew
printf "%s\n" `brew list` > ~/.backup/brew
printf "%s\n" `brew cask list` > ~/.backup/brew_cas
printf "%s\n" `asdf list` > ~/.backup/asdf
