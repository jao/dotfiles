#!/usb/bin/sh

# backup environment files

BACKUP_DIR=~/Dropbox/backup/macosx_dev_env
[ -d $BACKUP_DIR ] || mkdir -p $BACKUP_DIR
[ -d $BACKUP_DIR ] && ln -nfs ~/.macosx_backup $BACKUP_DIR

# home folder



# Homebrew

printf "%s\n" `brew list` > ~/.backup/brew
printf "%s\n" `brew cask list` > ~/.backup/brew_cask

# Cellar

# rvm

rvm list | grep -Eo "ruby-[a-z0-9.-]+" > ~/.backup/rvm

# Gemsets

rvm list gemsets | grep -Eo "ruby-[a-z0-9.@-]+" > ~/.backup/rvm_gemsets

