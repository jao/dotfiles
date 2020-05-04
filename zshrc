[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
[ -d "${DOTFILES_PATH}/scripts" ] && export PATH=$PATH:${DOTFILES_PATH}/scripts
export PATH=`echo $PATH | tr ':' '\n' | uniq | tr '\n' ':'`

export GOROOT=

# load my style functions
[ -f $DOTFILES_PATH/style_functions ] && source $DOTFILES_PATH/style_functions

# load my aliases
[ -f $DOTFILES_PATH/bash_aliases ] && source $DOTFILES_PATH/bash_aliases

# load petlove config
[ -f ~/Dropbox/petlove/env/aws ] && source ~/Dropbox/petlove/env/aws

# Do something under Mac OS X platform
[ "$(uname)" == "Darwin" ] && [ -f $DOTFILES_PATH/bash_macosx ] && source $DOTFILES_PATH/bash_macosx

# load my functions
[ -f $DOTFILES_PATH/bash_functions ] && source $DOTFILES_PATH/bash_functions

# load ruby completion
[ -f $DOTFILES_PATH/completion-ruby/completion-ruby-all ] && source $DOTFILES_PATH/completion-ruby/completion-ruby-all

# load asdf stuff
[ -d $HOME/.asdf ] && source $HOME/.asdf/asdf.sh

# load petlove related tools
[ -f $HOME/.petlove_vars ] && source $HOME/.petlove_vars
[ -f $DOTFILES_PATH/petlove_functions ] && source $DOTFILES_PATH/petlove_functions

# load codefresh completion
[ -f $DOTFILES_PATH/codefresh_completion ] && source $DOTFILES_PATH/codefresh_completion
