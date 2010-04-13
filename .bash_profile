# PATH
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin:/usr/X11/bin"
export PATH="/opt/ruby-enterprise-1.8.7-2009.10/bin:${PATH}"
export PATH="${HOME}/scripts:${HOME}/.gem:${HOME}/.gem/ruby/1.8/bin:${PATH}"
export PATH="${PATH}:/usr/local/sbin:/opt/local/bin:/opt/local/sbin"
export PATH="${PATH}:/sdks/android"
export PATH="${PATH}:/Library/Frameworks/Python.framework/Versions/2.6/bin"

export ANDROID_SWT="/sdks/android/tools/lib/x86/"
export LC_MESSAGES="en"
# export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home

export EDITOR="/usr/bin/mate -wl1"
export SVN_EDITOR="/usr/bin/mate -wl1"
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="0;30;43"

alias pinstall="sudo port install"
alias psearch="sudo port search"
alias ss="script/server"
alias sc="script/console"
alias sr="script/runner"
alias ls="ls -G"
alias ll="ls -Glahs"
alias psgrep="ps aux | egrep -v egrep | egrep -i "
alias showip="ifconfig | grep broadcast | sed 's/.*inet \(.*\) netmask.*/\1/'"
alias myip="curl http://www.whatismyip.com/automation/n09230945.asp && echo "
alias lock="/System/Library/CoreServices/Menu\ Extras/user.menu/Contents/Resources/CGSession -suspend"
alias screensaver="/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine &>/dev/null"
alias top="top -o cpu"
alias irb="irb --readline --prompt-mode simple"
alias mysql="mysql --auto-rehash=TRUE"
alias tjtest="ssh -t imp ssh tj@test"

# load git awesomeness
source ~/.git_completion.sh

# show path list
pathlist () { echo $PATH | awk -F ":" '{ for(i=1; i<=NF; i++){print $i;} }' | uniq -i; }
pathclean () { echo $PATH  | tr ':' '\n' | uniq -i | xargs | tr ' ' ':'; }

# reload source
reload () { source ~/.bash_profile; }

# list directory after cd
cd () { builtin cd "${@:-$HOME}" && ls; }

# taken from http://github.com/bryanl/zshkit/
github-url () { git config remote.origin.url | sed -En 's/git(@|:\/\/)github.com(:|\/)(.+)\/(.+).git/https:\/\/github.com\/\3\/\4/p'; }
github () { open $(github-url); }
git-scoreboard () { git log | grep '^Author' | sort | uniq -ci | sort -r; }

man2pdf () { man -t $* | ps2pdf - - | open -f -a Preview; }

# enter a recently created directory
mkdir () { /bin/mkdir $@ && eval cd "\$$#"; }
 
# get the tinyurl
tinyurl () {
  local tmp=/tmp/tinyurl
  rm $tmp 2>1 /dev/null
  wget "http://tinyurl.com/api-create.php?url=${1}" -O $tmp 2>1 /dev/null
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
  local STATE=" "
  
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
