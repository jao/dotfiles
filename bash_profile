#!/usr/bin/env bash

# configurations
export EDITOR=='mvim -f --nomru -c "au VimLeave * !open -a iTerm2"'

export SUBL_EDITOR="subl -w"

export VIM_EDITOR='mvim -f --nomru -c "au VimLeave * !open -a iTerm2"'

export GREP_OPTIONS="--color=auto"
export GREP_COLOR="1;33;40"

# android sdk
export ANDROID_HOME=/usr/local/opt/android-sdk

BREW_PREFIX=$(brew --prefix)

# go root
if [ -d $BREW_PREFIX ]; then
  export GOROOT=$BREW_PREFIX/Cellar/go/1.2
fi
export GOPATH=$HOME/go

# Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"
export LANG="en_US"

# Postgresql
# export PGDATA='/usr/local/var/postgres'

# load ruby completions from dotfiles
export DOTFILES_PATH=~/dotfiles

# PATH
export PATH=${HOME}/scripts:${HOME}/projects/termite:${HOME}/projects/prime/content-prep:/usr/local/bin:${PATH}
export PATH=${PATH}:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:~/bin:/usr/X11/bin
export PATH=${PATH}:${ANDROID_SDK_ROOT}/tools:${DOTFILES_PATH}/scripts
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# Make Tab autocomplete regardless of filename case
set completion-ignore-case on

# Don’t prompt unless there are over 500 possible completions
set completion-query-items 500

# List all matches in case multiple possible completions are possible
set show-all-if-ambiguous on

# Immediately add a trailing slash when autocompleting symlinks to directories
set mark-symlinked-directories on

# Use the text that has already been typed as the prefix for searching through
# commands (i.e. more intelligent Up/Down behavior)
# "\e[B": history-search-forward
# "\e[A": history-search-backward

# Use Alt/Meta + Delete to delete the preceding word
# "\e[3;3~": kill-word

# Do not autocomplete hidden files unless the pattern explicitly begins with a dot
set match-hidden-files off

# Show all autocomplete results at once
set page-completions off

# Immediately show all possible completions
set show-all-if-ambiguous on

# If there are more than 200 possible completions for a word, ask to show them all
set completion-query-items 200

# Show extra file information when completing, like `ls -F` does
set visible-stats on

# Be more intelligent when autocompleting by also looking at the text after
# the cursor. For example, when the current line is "cd ~/src/mozil", and
# the cursor is on the "z", pressing Tab will not autocomplete it to "cd
# ~/src/mozillail", but to "cd ~/src/mozilla". (This is supported by the
# Readline used by Bash 4.)
set skip-completed-text on

# Allow UTF-8 input and output, instead of showing stuff like $'\0123\0456'
set input-meta on
set output-meta on
set convert-meta off

# load rvm stuff
if [ -d ~/.rvm ]; then
  . ~/.rvm/scripts/rvm
  . ~/.rvm/scripts/completion
fi

# load my style functions
. $DOTFILES_PATH/style_functions

# load my functions
. ~/.bash_functions

# completion files

if [ -f $BREW_PREFIX/etc/bash_completion ]; then
  . $BREW_PREFIX/etc/bash_completion
fi
if [ -d $BREW_PREFIX/etc/bash_completion.d ]; then
  # load git awesomeness
  [ -f $BREW_PREFIX/etc/bash_completion.d/git-completion.bash ] && . $BREW_PREFIX/etc/bash_completion.d/git-completion.bash
  [ -f $BREW_PREFIX/etc/bash_completion.d/git-prompt.sh ] && . $BREW_PREFIX/etc/bash_completion.d/git-prompt.sh
  # load android adb
  [ -f $BREW_PREFIX/etc/bash_completion.d/adb-completion.bash ] && . $BREW_PREFIX/etc/bash_completion.d/adb-completion.bash
  # go lang completion
  [ -f $BREW_PREFIX/etc/bash_completion.d/go-completion.bash ] && . $BREW_PREFIX/etc/bash_completion.d/go-completion.bash
fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

[ -f $DOTFILES_PATH/completion-ruby/completion-ruby-all ] && . $DOTFILES_PATH/completion-ruby/completion-ruby-all

# Homebrew
. $BREW_PREFIX/Library/Contributions/brew_bash_completion.sh

# load ack completion
. ~/.ack_completion

# rake completion
complete -C $DOTFILES_PATH/rake_completion -o default rake

# projects completion
complete -C $DOTFILES_PATH/project_completion -o default pcd

# pow completion
complete -C $DOTFILES_PATH/pow_completion -o default pow

# locatools completion
complete -C $DOTFILES_PATH/locatools_completion -o default locatools
