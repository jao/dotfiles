# rails aliases
alias ss="script/server"
alias sc="script/console"
alias sr="script/runner"
alias irb="irb --readline --prompt-mode simple"

# ls aliases
alias ls="ls -G"
alias ll="ls -Glh"
alias la="ls -GlAh" # list all but hide . and ..

# bash aliases/utilities
alias myip="curl http://www.whatismyip.com/automation/n09230945.asp && echo "
alias showip="ifconfig | grep broadcast | sed 's/.*inet \(.*\) netmask.*/\1/'"
alias top="top -o cpu"
alias psgrep="ps aux | egrep -v egrep | egrep -i "
alias lock="/System/Library/CoreServices/Menu\ Extras/user.menu/Contents/Resources/CGSession -suspend"
alias screensaver="/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine &>/dev/null"
alias mysql="mysql --auto-rehash=TRUE"
alias r="rails"

# changing directory to project
pcd () { cd ~/projects/$1; }

# reload source
reload () { source ~/.bash_profile; }

# list directory after cd | -p parameter will run git pull after ls when it is a git repo
cd () { if [ "$1" == "-p" ]; then builtin cd "${2:-$HOME}" && ls; [ -d ".git" ] && git pull; else builtin cd "${@:-$HOME}" && ls; fi; }

# cd && pull
cdp () { builtin cd "${@:-$HOME}" && ls; if [ -d ".git" ]; then git pull; fi }

# mkdir, cd into it
mkcd () { mkdir -p "$*"; cd "$*"; }

man2pdf () { man -t $* | open -f -a Preview; }

# taken from http://github.com/bryanl/zshkit/
github-url () { git config remote.origin.url | sed -En 's/git(@|:\/\/)github.com(:|\/)(.+)\/(.+).git/https:\/\/github.com\/\3\/\4/p'; }
github () { open $(github-url); }
git-scoreboard () { git log | grep '^Author' | sort | uniq -ci | sort -r; }
 
# get the tinyurl
tinyurl () { curl -G "http://tinyurl.com/api-create.php" --data-urlencode "url=${1}" 2> /dev/null | pbcopy; }

# get the moourl awesomeness
moourl () { curl -G "http://moourl.com/create/" --data-urlencode "source=${1}" --trace-ascii - 2> /dev/null | grep Location: | echo "http://moourl.com/$(egrep -o '\w+$')" | pbcopy; }

# get the goo.gl
googl () {
  echo "shortening url..."
  if [ -f ~/.google_api_key ]; then
    google_api_key=`cat ~/.google_api_key`
    key_param=", 'key': '$google_api_key'"
  else
    key_param=''
  fi
  curl "https://www.googleapis.com/urlshortener/v1/url" -H 'Content-Type: application/json' -d "{'longUrl': '${1}'${key_param}}" 2> /dev/null | grep '"id":' | awk '{ print $2}' | sed -E 's/("|,)//g' | pbcopy;
}

# ascii character table
ascii () { for i in {32..255}; do printf "\e[0;33m$i\e[0m "\\$(($i/64*100+$i%64/8*10+$i%8))"\n"; done | column; }

# clear ASL logs
clean_asl_logs () { sudo rm -f /private/var/log/asl/*.asl; }

# Colors
BLUE="\e[0;34m"
CYAN="\e[0;36m"
GRAY="\e[1;30m"
GREEN="\e[0;32m"
PINK="\e[0;35m"
RED="\e[0;31m"
WHITE="\e[1;37m"
YELLOW="\e[0;33m"
NC="\e[0m" # no color

export GIT_PS1_SHOWDIRTYSTATE=1
my-prompt () {
  # basic variables
  local STATE=''; local RVM=''; local STATUS=''; local ini=''; local end='';
  local BC=$GREEN # base color
  [ -f ~/.rvm/bin/rvm-prompt ] && RVM=" \e[1;30;43m $(~/.rvm/bin/rvm-prompt i v) \e[0m" # rvm rubies
  PS1="\e[1;33m\u\e[0m|\e[1;32m\h\e[0m \e[1;34m\w\e[0m${RVM}" # basic ps1
  
  # GITBRANCH=`git branch 2> /dev/null | grep \* | sed 's/* //'`
  local GITBRANCH=`__git_ps1 "%s"`
  if [ "$GITBRANCH" != "" ]; then
    # delimiters
    ini="("; end=")"
    
    local BEHIND="# Your branch is behind"
    local AHEAD="# Your branch is ahead"
    local UNTRACKED="# Untracked files"
    local DIVERGED="have diverged"
    local CHANGED="# Changed but not updated"
    local TO_BE_COMMITED="# Changes to be committed"
    local CHANGES_NOT_STAGED="# Changes not staged for commit"
    STATUS=`git status 2>/dev/null`
    
    if [[ "$STATUS" =~ "$DIVERGED" ]]; then
      BC=$RED; STATE="${RED}↕${NC}"
    elif [[ "$STATUS" =~ "$BEHIND" ]]; then
      BC=$RED; STATE="${RED}↓${NC}"
    elif [[ "$STATUS" =~ "$AHEAD" ]]; then
      BC=$RED; STATE="${RED}↑${NC}"
    fi
    
    if [[ "$STATUS" =~ "$TO_BE_COMMITED" ]] || [[ "$STATUS" =~ "$CHANGED" ]] || [[ "$STATUS" =~ "$CHANGES_NOT_STAGED" ]]; then
      BC=$YELLOW; STATE="${YELLOW}${NC}"
    fi
    
    [ -z "$STATE" ] && BC=$GREEN
    [[ "$STATUS" =~ "$UNTRACKED" ]] && STATE="${STATE}${YELLOW}*${NC}"
    
    PS1="${PS1} ${ini}${BC}${GITBRANCH}${NC}${STATE}${end}"
  fi
  
  PS1="${PS1} \n\$ "
}
PROMPT_COMMAND=my-prompt
