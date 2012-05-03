# Larger bash history (default is 500)
export HISTFILESIZE=10000
export HISTSIZE=10000

# Easier navigation: .., ..., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# Shortcuts
alias d="cd ~/Documents/Dropbox"
alias p="cd ~/projects"
alias r="rails"
alias v="vim"
alias m="mate ."
alias s="subl ."

alias g="git"
alias ga='git add -A'
alias gap='ga -p'
alias gau='git add -u'
alias gbr='git branch -v'
gc() {
  git diff --cached | grep '\btap[ph]\b' >/dev/null &&
    echo "\e[0;31;29mOops, there's a #tapp or similar in that diff.\e[0m" ||
    git commit -v "$@"
}
alias gc!='git commit -v'
alias gca='git commit -v -a'
alias gcam='gca --amend'
alias gch='git cherry-pick'
alias gcm='git commit -v --amend'
alias gco='git checkout'
alias gcop='gco -p'
alias gd='git diff -M'
alias gd.='git diff -M --color-words="."'
alias gdc='git diff --cached -M'
alias gdc.='git diff --cached -M --color-words="."'
alias gm='git merge --no-ff'
alias gmf='git merge --ff-only'
alias gf="git fetch"
alias gp="git push"
git-new() {
  [ -d "$1" ] || mkdir "$1" &&
  cd "$1" &&
  git init &&
  touch .gitignore &&
  git add .gitignore &&
  git commit -m "Added .gitignore."
}
git_current_branch() {
  cat "$(git rev-parse --git-dir 2>/dev/null)/HEAD" | sed -e 's/^.*refs\/heads\///'
}
alias glog='git log --date-order --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset"'
alias gl='glog --graph'
alias gla='gl --all'
gls() {
  query="$1"
  shift
  glog --pickaxe-regex "-S$query" "$@"
}
alias gm='git merge --no-ff'
alias gmf='git merge --ff-only'
alias gmfthis='gmf origin/$(git_current_branch)'
alias gp='git push'
alias gpthis='gp origin $(git_current_branch)'
alias gr='git reset'
alias grb='git rebase -p'
alias grbthis='grb origin/$(git_current_branch)'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grh='git reset --hard'
alias grp='gr --patch'
alias grsh='git reset --soft HEAD~'
alias grv='git remote -v'
alias gs='git show'
alias gs.='git show --color-words="."'
alias gst='git stash'
alias gstp='git stash pop'


# ls aliases
alias ls="ls -G"
alias ll="ls -Glh"
alias lah="ls -GlAh" # list all but hide . and ..
alias la="ls -Gla" # List all files colorized in long format, including dot files
alias lsd='ls -l | grep "^d"' # List only directories

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en1"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# bash aliases/utilities
alias myip="curl http://www.whatismyip.com/automation/n09230945.asp && echo "
alias showip="ifconfig | grep broadcast | sed 's/.*inet \(.*\) netmask.*/\1/'"
alias top="top -o cpu"
alias psgrep="ps aux | egrep -v egrep | egrep -i "
alias mysql="mysql --auto-rehash=TRUE"

# Enhanced WHOIS lookups
alias whois="whois -h whois-servers.net"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Canonical hex dump; some systems have this symlinked
type -t hd > /dev/null || alias hd="hexdump -C"

# OS X has no `md5sum`, so use `md5` as a fallback
type -t md5sum > /dev/null || alias md5sum="md5"

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# File size
alias fs="stat -f \"%z bytes\""

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.Finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.Finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Disable Spotlight
alias spotoff="sudo mdutil -a -i off"
# Enable Spotlight
alias spoton="sudo mdutil -a -i on"

# ROT13-encode text. Works for decoding, too! ;)
alias rot13='tr a-zA-Z n-za-mN-ZA-M'

# Stuff I never really use but cannot delete either because of http://xkcd.com/530/
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume 10'"
alias hax="growlnotify -a 'Activity Monitor' 'System error' -m 'WTF R U DOIN'"

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
  [ -f ~/.rvm/bin/rvm-prompt ] && RVM=" \e[0;30;43m $(~/.rvm/bin/rvm-prompt v g) \e[0m" # rvm rubies
  PS1="\e[1;33m\u\e[0m|\e[1;32m\h\e[0m \e[1;34m\w\e[0m${RVM}" # basic ps1
  
  # GITBRANCH=`git branch 2> /dev/null | grep \* | sed 's/* //'`
  local GITBRANCH=`__git_ps1 "%s" | awk '{print $1;}'`
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
      BC=$YELLOW; STATE="${STATE}${YELLOW}+${NC}"
    fi
    
    if [[ "$STATUS" =~ "$UNTRACKED" ]]; then
      STATE="${STATE}${CYAN}?${NC}"
    fi
    
    [ -z "$STATE" ] && BC=$GREEN
    
    PS1="${PS1} ${ini}${BC}${GITBRANCH}${NC}${STATE}${end}"
  fi
  
  PS1="${PS1} \n\$ "
}
PROMPT_COMMAND=my-prompt

# tilde_or_pwd() {
#   echo $PWD | sed -e "s/\/Users\/$USER/~/"
# }

# export PROMPT=$'%{\e[0;90m%}%n@\e[0;30;47m%M%{\e[0m%}
# %{\e[0;%(?.32.31)m%}>%{\e[0m%} '
# export RPROMPT=$'%{\e[0;90m%}$(tilde_or_pwd)$(git_cwd_info)%{\e[0m%}'


# @gf3’s Sexy Bash Prompt, inspired by “Extravagant Zsh Prompt”
# Shamelessly copied from https://github.com/gf3/dotfiles
# Screenshot: http://i.imgur.com/s0Blh.png

# if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
#   export TERM=gnome-256color
# elif infocmp xterm-256color >/dev/null 2>&1; then
#   export TERM=xterm-256color
# fi
# 
# if tput setaf 1 &> /dev/null; then
#   tput sgr0
#   if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
#     MAGENTA=$(tput setaf 9)
#     ORANGE=$(tput setaf 172)
#     GREEN=$(tput setaf 190)
#     PURPLE=$(tput setaf 141)
#     WHITE=$(tput setaf 256)
#   else
#     MAGENTA=$(tput setaf 5)
#     ORANGE=$(tput setaf 4)
#     GREEN=$(tput setaf 2)
#     PURPLE=$(tput setaf 1)
#     WHITE=$(tput setaf 7)
#   fi
#   BOLD=$(tput bold)
#   RESET=$(tput sgr0)
# else
#   MAGENTA="\033[1;31m"
#   ORANGE="\033[1;33m"
#   GREEN="\033[1;32m"
#   PURPLE="\033[1;35m"
#   WHITE="\033[1;37m"
#   BOLD=""
#   RESET="\033[m"
# fi
# 
# export MAGENTA
# export ORANGE
# export GREEN
# export PURPLE
# export WHITE
# export BOLD
# export RESET
# 
# function parse_git_dirty() {
#   [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
# }
# 
# function parse_git_branch() {
#   git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
# }
# 
# PS1="\[${BOLD}${MAGENTA}\]\u \[$WHITE\]at \[$ORANGE\]\h \[$WHITE\]in \[$GREEN\]\w\[$WHITE\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$PURPLE\]\$(parse_git_branch)\[$WHITE\]\n\$ \[$RESET\]"
