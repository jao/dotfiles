# PATH
export PATH="${HOME}/scripts"
export PATH="${PATH}:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11/bin"
export PATH="${PATH}:/opt/local/bin:/opt/local/sbin"
export PATH="${PATH}:/sdks/android"
# export PATH="${PATH}:/Library/Frameworks/Python.framework/Versions/2.6/bin"

export ANDROID_SWT="/sdks/android/tools/lib/x86/"
export LC_MESSAGES="en"
# export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home

export EDITOR="/usr/bin/mate -wl1"
export GIT_EDITOR="/usr/bin/mate -wl1"
export SVN_EDITOR="/usr/bin/mate -wl1"
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="0;30;43"

# load git awesomeness
source ~/.git_completion.sh

source ~/.bash_functions

# Colors
BLUE="\e[0;34m"
CYAN="\e[0;36m"
GRAY="\e[1;30m"
GREEN="\e[0;32m"
RED="\e[0;31m"
WHITE="\e[1;37m"
YELLOW="\e[0;33m"
NC="\e[0m" # no color

my-prompt () {
  local GITBRANCH=`git branch 2> /dev/null | grep \* | sed 's/* //'`
  local SVNBRANCH=`svn info 2> /dev/null | grep '^URL:' | egrep -o '(tags|branches)/[^/]+|trunk|[^/]+$' | egrep -o -m 1 '[^/]+$'`
  local BC=$GREEN # base color
  local STATE=""
  local RUBY=`~/.rvm/bin/rvm-prompt i v`
  local RVM="|\e[33m${RUBY}\e[0m|"
  
  # basic ps1
  PS1="\e[1;33m\u\e[0m|\e[1;32m\h\e[0m \e[1;34m\w\e[0m ${RVM}"
  
  if [ "$GITBRANCH" != "" ]; then
    # delimiters
    local GIT="("
    local GITEND=")"
    
    local STATUS=`git status 2>/dev/null`
    local BEHIND="# Your branch is behind"
    local AHEAD="# Your branch is ahead"
    local UNTRACKED="# Untracked files"
    local DIVERGED="have diverged"
    local CHANGED="# Changed but not updated"
    local TO_BE_COMMITED="# Changes to be committed"
    
    if [[ "$STATUS" =~ "$DIVERGED" ]]; then
      BC=$RED
      STATE="${STATE}${RED}↕${NC}"
    elif [[ "$STATUS" =~ "$BEHIND" ]]; then
      BC=$RED
      STATE="${STATE}${RED}↓${NC}"
    elif [[ "$STATUS" =~ "$AHEAD" ]]; then
      BC=$RED
      STATE="${STATE}${RED}↑${NC}"
    elif [[ "$STATUS" =~ "$CHANGED" ]]; then
      BC=$RED
      STATE=""
    elif [[ "$STATUS" =~ "$TO_BE_COMMITED" ]]; then
      BC=$RED
      STATE=""
    else
      BC=$GREEN
      STATE=""
    fi
    
    if [[ "$STATUS" =~ "$UNTRACKED" ]]; then
      STATE="${STATE}${YELLOW}*${NC}"
    fi
    
    PS1="${PS1} ${GIT}${BC}${GITBRANCH}${NC}${STATE}${GITEND}"
  fi
  
  if [[ "$SVNBRANCH" != "" ]]; then
    # delimiters
    local SVN="["
    local SVNEND="]"
    local SVNDEL="|"
        
    local SVNREV=`svn info 2>/dev/null | awk '/Revision:/ {print $2; }'`
    local UNTRACKED=`svn st | egrep -o '^\?'`
    local CHANGED=`svn st | egrep -o '^[ADM]'`
    
    BC=$GREEN
    STATE="${SVNDEL}${SVNREV}"
    
    if [ "$CHANGED" != "" ]; then
      BC=$RED
      STATE="${STATE}${RED}↑${NC}"
    fi  
    
    if [ "$UNTRACKED" != "" ]; then
      BC=$YELLOW
      STATE="${STATE}${YELLOW}*${NC}"
    fi
    
    PS1="${PS1} ${SVN}${BC}${SVNBRANCH}${NC}${STATE}${SVNEND}"
  fi
  PS1="${PS1} \n\$ "
}
PROMPT_COMMAND=my-prompt

# load rvm stuff
source ~/.rvm/scripts/rvm
