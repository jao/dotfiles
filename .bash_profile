# PATH
export PATH="${HOME}/scripts:${HOME}/projects/timesheet"
export PATH="${PATH}:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11/bin"

# configurations
export EDITOR="/usr/bin/mate -wl1"
export GIT_EDITOR="/usr/bin/mate -wl1"
export SVN_EDITOR="/usr/bin/mate -wl1"

export GREP_OPTIONS="--color=auto"
export GREP_COLOR="0;30;43"

export ANDROID_SDK_ROOT="/usr/local/Cellar/android-sdk/r5"
export LC_ALL="en_US.UTF-8"

# load git awesomeness
source ~/.git_completion.sh

# load rvm stuff
source ~/.rvm/scripts/rvm

# load my functions
source ~/.bash_functions

# useless fun timesheet completion
source ~/projects/timesheet/.work_completion.sh