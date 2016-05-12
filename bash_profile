#!/usr/bin/env bash

# configurations
export EDITOR="vim -f --nomru "

export SUBL_EDITOR="subl -w"

export VIM_EDITOR="vim -f --nomru "

export GREP_COLOR="1;33;40"

# Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"
export LANG="en_US"

# Postgresql
# export PGDATA='/usr/local/var/postgres'

# load ruby completions from dotfiles
export DOTFILES_PATH=~/dotfiles

# Larger bash history (default is 500)
export HISTFILESIZE=10000
export HISTSIZE=10000

# PATH
export PATH=/usr/local/bin:$PATH
export PATH=$PATH:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:~/bin:/usr/X11/bin
export PATH=$PATH:${DOTFILES_PATH}/scripts            # dotfiles scripts
export PATH=$PATH:$HOME/.rvm/bin
export PATH=`echo $PATH | tr ':' '\n' | uniq | tr '\n' ':'`

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

# load my style functions
[ -f $DOTFILES_PATH/style_functions ] && source $DOTFILES_PATH/style_functions

# load my aliases
[ -f $DOTFILES_PATH/bash_aliases ] && source $DOTFILES_PATH/bash_aliases

# Do something under Mac OS X platform
[ "$(uname)" == "Darwin" ] && [ -f $DOTFILES_PATH/bash_macosx ] && source $DOTFILES_PATH/bash_macosx

# load my functions
[ -f $DOTFILES_PATH/bash_functions ] && source $DOTFILES_PATH/bash_functions

# load ruby completion
[ -f $DOTFILES_PATH/completion-ruby/completion-ruby-all ] && source $DOTFILES_PATH/completion-ruby/completion-ruby-all

# rake completion
[ -f $DOTFILES_PATH/rake_completion ] && complete -C $DOTFILES_PATH/rake_completion -o default rake

# projects completion
[ -f $DOTFILES_PATH/project_completion ] && complete -C $DOTFILES_PATH/project_completion -o default pcd

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# load rvm stuff
[ -d "$HOME/.rvm" ] && source "$HOME/.rvm/scripts/completion"
