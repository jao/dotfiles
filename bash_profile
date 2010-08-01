# configurations
export EDITOR="/usr/bin/mate -wl1"
export GIT_EDITOR="/usr/bin/mate -wl1"
export SVN_EDITOR="/usr/bin/mate -wl1"

export GREP_OPTIONS="--color=auto"
export GREP_COLOR="1;33;40"

export ANDROID_SDK_ROOT="/usr/local/Cellar/android-sdk/r6"
export LC_ALL="en_US.UTF-8"

# PATH
export PATH="${HOME}/scripts:${HOME}/projects/termite:/usr/local/bin:${PATH}"
export PATH="${PATH}:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11/bin"
export PATH="${PATH}:${ANDROID_SDK_ROOT}/tools"

# load git awesomeness
source ~/.git_completion

# load rvm stuff
source ~/.rvm/scripts/rvm
source ~/.rvm/scripts/completion

# load my functions
source ~/.bash_functions

# Homebrew
source `brew --prefix`/Library/Contributions/brew_bash_completion.sh

# Prep - Prime content tool completion
source ~/projects/prime/content-prep/_prep_completion

# useless fun timesheet completion
complete -C ~/projects/termite/_termite_completion -o default termite

# rake completion
complete -C ~/projects/dotfiles/rake_completion -o default rake

# projects completion
complete -C ~/projects/dotfiles/project_completion -o default pcd
