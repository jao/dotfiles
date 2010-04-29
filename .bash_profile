# PATH
export PATH="/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11/bin"
# export PATH="/opt/ruby-enterprise-1.8.7-2009.10/bin:${PATH}"
export PATH="${HOME}/scripts:${HOME}/.gem:${HOME}/.gem/ruby/1.8/bin:${PATH}"
export PATH="${PATH}:/opt/local/bin:/opt/local/sbin"
export PATH="${PATH}:/sdks/android"
export PATH="${PATH}:/Library/Frameworks/Python.framework/Versions/2.6/bin"

export ANDROID_SWT="/sdks/android/tools/lib/x86/"
export LC_MESSAGES="en"
# export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home

export EDITOR="/usr/bin/mate -wl1"
export GIT_EDITOR="/usr/bin/mate -wl1"
export SVN_EDITOR="/usr/bin/mate -wl1"
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="0;30;43"

# rails aliases
alias ss="script/server"
alias sc="script/console"
alias sr="script/runner"
alias irb="irb --readline --prompt-mode simple"

# ls aliases
alias ls="ls -G"
alias ll="ls -Glh"
alias la="ls -Glah"

# bash aliases/utilities
alias myip="curl http://www.whatismyip.com/automation/n09230945.asp && echo "
alias showip="ifconfig | grep broadcast | sed 's/.*inet \(.*\) netmask.*/\1/'"
alias top="top -o cpu"
alias psgrep="ps aux | egrep -v egrep | egrep -i "
alias lock="/System/Library/CoreServices/Menu\ Extras/user.menu/Contents/Resources/CGSession -suspend"
alias screensaver="/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine &>/dev/null"
alias mysql="mysql --auto-rehash=TRUE"
# alias tjtest="ssh -t imp ssh tj@test"

# load git awesomeness
source ~/.git_completion.sh

# load rvm stuff
source ~/.rvm/scripts/rvm

# reload source
reload () { source ~/.bash_profile; }

# show path list
pathlist () { echo $PATH | awk -F ":" '{ for(i=1; i<=NF; i++){print $i;} }' | uniq -i; }
pathclean () { echo $PATH  | tr ':' '\n' | uniq -i | xargs | tr ' ' ':'; }

# list directory after cd
cd () { builtin cd "${@:-$HOME}" && ls; }

# enter a recently created directory
mkdir () { /bin/mkdir $@ && eval cd "\$$#"; }

man2pdf () { man -t $* | ps2pdf - - | open -f -a Preview; }

# taken from http://github.com/bryanl/zshkit/
github-url () { git config remote.origin.url | sed -En 's/git(@|:\/\/)github.com(:|\/)(.+)\/(.+).git/https:\/\/github.com\/\3\/\4/p'; }
github () { open $(github-url); }
git-scoreboard () { git log | grep '^Author' | sort | uniq -ci | sort -r; }
 
# get the tinyurl
tinyurl () {
  local tmp=/tmp/tinyurl
  rm $tmp 2>1 /dev/null
  curl "http://tinyurl.com/api-create.php?url=${1}" -O $tmp 2>1 /dev/null
  cat $tmp | pbcopy
}

# get the moourl awesomeness
moourl () {
  local tmp=/tmp/moourl
  rm $tmp 2>1 /dev/null
  curl "http://moourl.com/create/?source=${1}" -O $tmp 2>1 /dev/null
  cat $tmp | pbcopy
}

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
  local RVM="|\e[33m${RUBY}\e[0m| "
  
  # basic ps1
  PS1="\e[1;33m\u\e[0m|\e[1;32m\h\e[0m \e[1;34m\w\e[0m"
  
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
    
    PS1="${PS1} ${RVM}${GIT}${BC}${GITBRANCH}${NC}${STATE}${GITEND}"
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
    
    PS1="${PS1} ${RVM}${SVN}${BC}${SVNBRANCH}${NC}${STATE}${SVNEND}"
  fi
  PS1="${PS1} \n\$ "
}
PROMPT_COMMAND=my-prompt
