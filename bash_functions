#!/usr/bin/env bash

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

# rails related shortcuts
alias r="rails"
alias be="bundle exec"

# editor related shortcuts
alias v="mvim"

alias vim="vim -u ~/.vim/vimrc"
alias mvim="mvim -u ~/.vim/vimrc"

# git related shortcuts
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
alias gwc="git whatchanged -p --abbrev-commit --pretty=medium"
alias glog='git log --date-order --pretty="format:%C(yellow)%h%C(magenta)%d%Creset %s %C(white) %an, %ar%Creset"'
alias gl='glog --graph'
alias gla='gl --all'
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

alias lock='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'
alias screensaver='open -a /System/Library/Frameworks/ScreenSaver.framework//Versions/A/Resources/ScreenSaverEngine.app'

# https://gist.github.com/davejamesmiller/1965569
function ask {
  while true; do
    if [ "${2:-}" = "Y" ]; then
        prompt="Y/n"
        default=Y
    elif [ "${2:-}" = "N" ]; then
        prompt="y/N"
        default=N
    else
        prompt="y/n"
        default=
    fi

    # Ask the question
    read -p "$1 [$prompt] " REPLY

    # Default?
    if [ -z "$REPLY" ]; then
        REPLY=$default
    fi

    # Check if the reply is valid
    case "$REPLY" in
      Y*|y*) return 0 ;;
      N*|n*) return 1 ;;
    esac
  done
}

gtag() {
  VERSION=$(git describe --tags --abbrev=0 --match "$1*" `git rev-list --tags --max-count=1`)
  echo "Current version: $(_style_colorize $VERSION 33)"
  if [ -n "${VERSION##*.}" ] && [ "${VERSION##*.}" -eq "${VERSION##*.}" ] 2>/dev/null; then
    NEW_VERSION="${VERSION%.*}.`expr ${VERSION##*.} + 1`"
    if ask "Do you want to use the new tag '$(_style_colorize $NEW_VERSION 32)'?" Y; then
      git tag ${NEW_VERSION} -m ""
      git push --tags
    fi
  fi
}

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

gls() {
  query="$1"
  shift
  glog --pickaxe-regex "-S$query" "$@"
}

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

# locaweb gateways
alias gw1='ssh nibbler0001'
alias gw2='ssh nibbler0002'

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

# mv verbose
mv () { /bin/mv -v $@; }

man2pdf () { man -t $* | open -f -a Preview; }

# taken from http://github.com/bryanl/zshkit/
github-url () { git config remote.origin.url | sed -En 's/git(@|:\/\/)github.com(:|\/)(.+)\/(.+).git/https:\/\/github.com\/\3\/\4/p'; }
github () { open $(github-url); }
git-scoreboard () { git log | grep '^Author' | sort | uniq -ci | sort -r; }

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
colors () { ruby ~/dotfiles/scripts/colors; }

# clear ASL logs
clean_asl_logs () { sudo rm -f /private/var/log/asl/*.asl; }

# pow
pow () {
  case $1 in
    about)
      open "http://pow.cx";;
    app)
      local pow_app=`pwd`;
      case $2 in
        delete)
          if [ -z "$3" ]; then
            rm -i ~/.pow/$3
          else
            rm -i ~/.pow/$pow_app
          fi;;
        list)
          ls -la ~/.pow/;;
        new)
          ln -sf $pow_app ~/.pow/${pow_app##*/}
          ls -lA ~/.pow/ | grep ${pow_app##*/}
        ;;
        restart)
          echo "restarting app..."
          touch tmp/restart.txt;;
        *)
          echo "App info"
          echo $pow_app;;
      esac;;
    powrc)
      case $2 in
        show)
          if [ -f .powrc ]; then
            _style_colorize ".powrc contents" 33
            cat .powrc
          else
            _style_colorize ".powrc not found" 31
          fi
          ;;
        write)
          cp $DOTFILES_PATH/powrc_base .powrc
          _style_colorize ".powrc contents" 32
          cat .powrc
          ;;
      esac
      ;;
    endpoint)
      curl -H host:pow localhost/status.json
      echo;;
    manual)
      open "http://pow.cx/manual.html";;
    portproxy)
      echo $2 > ~/.pow/$3;;
    restart)
      echo "restarting Pow..."
      touch ~/.pow/restart.txt;;
    rvm)
      if [ ! -f .ruby-version ] || [ ! -f .ruby-gemset ]; then
        _style_colorize "Creating rvm files" 33
        rvm use $(cat .rvmrc.example | grep @ | awk -F' ' '{ print $2 }') --ruby-version --create
      else
        _style_colorize ".ruby-version contents" 33
        cat .ruby-version
        _style_colorize ".ruby-gemset contents" 33
        cat .ruby-gemset
      fi
      ;;
    uninstall)
      curl get.pow.cx/uninstall.sh | sh;;
    upgrade)
      curl get.pow.cx | sh;;
    help|*)
      echo "Pow Rack Server:
      about
      endpoint
      help
      manual
      portproxy
        pow portproxy port# appname
      restart
      upgrade
      uninstall";;
  esac
}

# iso to img using hdiutil
iso2img () {
  if [ "$1" != "" ] && [ "$2" != "" ]; then
    hdiutil convert -format UDRW -o $2 $1;
  else
    echo "Missing arguments, usage:
  iso2img <image_file> <output_file>"
  fi
}

# Colors
BLUE="\[\e[0;34m\]"
CYAN="\[\e[0;36m\]"
GRAY="\[\e[1;30m\]"
GREEN="\[\e[0;32m\]"
PINK="\[\e[0;35m\]"
RED="\[\e[0;31m\]"
WHITE="\[\e[1;37m\]"
YELLOW="\[\e[0;33m\]"
NC="\[\e[0m\]" # no color

_battery_status () {
  local response=$(pmset -g batt | )
}

export GIT_PS1_SHOWDIRTYSTATE=1
_my_prompt () {
  local last_command=$?
  # basic variables
  local STATE=''; local RVM=''; local STATUS=''; local ini=''; local end='';
  local BC=$GREEN # base color
  if [ -f ~/.rvm/bin/rvm-prompt ]; then
    local RVM_STRING=$(~/.rvm/bin/rvm-prompt v g)
    local RVM_RUBY=${RVM_STRING%%@*}
    local RVM_GEMSET=${RVM_STRING##*@}
    [ "$RVM_RUBY" == "$RVM_GEMSET" ] && RVM_GEMSET=""
    RVM="${CYAN}${RVM_RUBY}${NC}" # rvm ruby
    [ "$RVM_GEMSET" != "" ] && RVM="$RVM \[\e[1;30m\]${RVM_GEMSET}${NC}"
  fi

  # battery=$(ioreg -l | awk '$3~/Capacity/{c[$3]=$5}END{OFMT="%.2f%";max=c["\"MaxCapacity\""];print(max>0?100*c["\"CurrentCapacity\""]/max:"?")}')
  # battery=$(pmset -g batt)

  DATERIGHT=$(($COLUMNS - 0))
  HEADLINE=$(printf "%-${DATERIGHT}s %s" "\[\e[1;33m\]\u$NC|\[\e[1;32m\]\h$NC" "$GRAY\D{%d/%m/%Y} \t$NC")
  PS1="$HEADLINE\n\[\e[1;34m\]\w$NC" # basic ps1

  # GITBRANCH=`git branch 2> /dev/null | grep \* | sed 's/* //'`
  local GITBRANCH=`__git_ps1 "%s" | awk '{print $1;}'`
  if [ "$GITBRANCH" != "" ]; then
    # delimiters
    ini=""; end=""; separator=" "

    local BEHIND="Your branch is behind"
    local AHEAD="Your branch is ahead"
    local UNTRACKED="Untracked files"
    local DIVERGED="have diverged"
    local CHANGED="Changed but not updated"
    local TO_BE_COMMITED="Changes to be committed"
    local CHANGES_NOT_STAGED="Changes not staged for commit"
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

    PS1="${PS1} ${ini}${RVM}${separator}${BC}${GITBRANCH}${NC}${STATE}${end}"
  else
    PS1="${PS1} ${ini}${RVM}${end}"
  fi

  if [[ $last_command == 0 ]]; then
    checkornot="$GREEN\342\234\223$NC"
  else
    checkornot="$RED\342\234\227$NC"
  fi


  PS1="\n${PS1}\n${checkornot} \$ "
}
PROMPT_COMMAND=_my_prompt
