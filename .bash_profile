# PATH
export PATH="~/scripts:${PATH}"
export PATH="/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:${PATH}"
export PATH="/sdks/android:${PATH}"
export PATH="/Library/Frameworks/Python.framework/Versions/2.6/bin:${PATH}"

export ANDROID_SWT="/sdks/android/tools/lib/x86/"

export EDITOR="/usr/bin/mate -wl1"
export SVN_EDITOR="/usr/bin/mate -wl1"
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="1;33"

export LC_MESSAGES="en"

source ~/.git_completion.sh

# regular PS1
# export PS1='\[\e[01;33m\]\u\e[01;32m\]@\h\[\e[00m\] \[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 " (%s)") \$ '

alias install="sudo port install"
alias search="sudo port search"
alias ls="ls -G"
alias ll="ls -Glahs"
alias psgrep="ps aux | egrep -v egrep | egrep"
alias showip="ifconfig | grep broadcast | sed 's/.*inet \(.*\) netmask.*/\1/'"
alias myip="curl http://www.whatismyip.com/automation/n09230945.asp"
alias lock="/System/Library/CoreServices/Menu\ Extras/user.menu/Contents/Resources/CGSession -suspend"
alias top="top -o cpu"
alias irb="irb --readline --prompt-mode simple"
alias mysql="mysql --auto-rehash=TRUE"

# reload source
reload() { source ~/.bash_profile; }

# list directory after cd
cd() { builtin cd "${@:-$HOME}" && ls; }

# taken from http://github.com/bryanl/zshkit/
github-url () { git config remote.origin.url | sed -En 's/git(@|:\/\/)github.com(:|\/)(.+)\/(.+).git/https:\/\/github.com\/\3\/\4/p'; }
github-go () { open $(github-url); }
git-scoreboard () { git log | grep '^Author' | sort | uniq -ci | sort -r; }
manp () { man -t $* | ps2pdf - - | open -f -a Preview; }

# enter a recently created directory
mkdir() { /bin/mkdir $@ && eval cd "\$$#"; }
 
# get the tinyurl
tinyurl () {
    local tmp=/tmp/tinyurl
    rm $tmp 2>1 /dev/null
    wget "http://tinyurl.com/api-create.php?url=${1}" -O $tmp 2>1 /dev/null
    cat $tmp | pbcopy
}

# Colours
BLUE="\[\e[0;34m\]"
GRAY="\[\e[1;30m\]"
GREEN="\[\e[0;32m\]"
LIGHT_GRAY="\[\e[0;37m\]"
LIGHT_GREEN="\[\e[1;32m\]"
LIGHT_RED="\[\e[1;31m\]"
RED="\[\e[0;31m\]"
WHITE="\[\e[1;37m\]"
YELLOW="\[\e[0;33m\]"
NC="\[\e[0m\]" # no color

my-prompt () {
  local GITBRANCH=`git branch 2> /dev/null | grep \* | sed 's/* //'`
  local SVNBRANCH=`svn info 2> /dev/null | grep '^URL:' | egrep -o '(tags|branches)/[^/]+|trunk|\w+$' | egrep -o '[^/]+$'`
  local PC=$GREEN # base color
  local STATE=" "
  
  # basic ps1
  PS1="\[\e[01;33m\]\u\[\e[00m\]|\e[01;32m\]\h\[\e[00m\] \[\033[01;34m\]\w\[\033[00m\]"
  
  if [ "$GITBRANCH" != "" ]; then
    local STATUS=`git status 2>/dev/null`
    local BEHIND="# Your branch is behind"
    local AHEAD="# Your branch is ahead"
    local UNTRACKED="# Untracked files"
    local DIVERGED="have diverged"
    local CHANGED="# Changed but not updated"
    local TO_BE_COMMITED="# Changes to be committed"

    if [[ "$STATUS" =~ "$DIVERGED" ]]; then
      PC=$RED
      STATE="${STATE}${RED}↕${NC}"
    elif [[ "$STATUS" =~ "$BEHIND" ]]; then
      PC=$RED
      STATE="${STATE}${RED}↓${NC}"
    elif [[ "$STATUS" =~ "$AHEAD" ]]; then
      PC=$RED
      STATE="${STATE}${RED}↑${NC}"
    elif [[ "$STATUS" =~ "$CHANGED" ]]; then
      PC=$RED
      STATE=""
    elif [[ "$STATUS" =~ "$TO_BE_COMMITED" ]]; then
      PC=$RED
      STATE=""
    else
      PC=$GREEN
      STATE=""
    fi
    
    if [[ "$STATUS" =~ "$UNTRACKED" ]]; then
        STATE="${STATE}${YELLOW}*${NC}"
    fi
    
    PS1="${PS1} (${PC}${GITBRANCH}${NC}${STATE})"
  fi
  
  if [[ "$SVNBRANCH" != "" ]]; then
    local SVNREV=`svn info 2>/dev/null | awk '/Revision:/ {print $2; }'`
    local UNTRACKED=`svn st | egrep -o '^\?'`
    local CHANGED=`svn st | egrep -o '^[ADM]'`

    STATE=":${SVNREV}"
    
    if [ "$CHANGED" != "" ]; then
      PC=$RED
    fi  
    
    if [ "$UNTRACKED" != "" ]; then
      STATE="${STATE}${YELLOW}*${NC}"
    fi
    
    PS1="${PS1} (${PC}${SVNBRANCH}${NC}${STATE})"
  fi
  PS1="${PS1} \n\$ "
}
PROMPT_COMMAND=my-prompt
