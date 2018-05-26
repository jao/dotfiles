#!/usr/bin/env bash

# git related function
gc() {
  git diff --cached | grep '\btap[ph]\b' >/dev/null &&
    echo "\e[0;31;29mOops, there's a #tapp or similar in that diff.\e[0m" ||
    git commit -v "$@"
}

gtag() {
  TAG=$(git rev-list --tags --max-count=1 2> /dev/null)
  [ "$?" == "0" ] || TAG=''
  if [ -n "$TAG" ]; then
    if [ -n "$1" ]; then
      VERSION=$(git describe --tags --abbrev=0 --match "$1*" $TAG)
    else
      VERSION=$(git describe --tags --abbrev=0 $TAG)
    fi
    echo "Current version: $(_style_colorize $VERSION 33)"
    if [ -n "${VERSION##*.}" ] && [ "${VERSION##*.}" -eq "${VERSION##*.}" ] 2>/dev/null; then
      NEW_VERSION="${VERSION%.*}.`expr ${VERSION##*.} + 1`"
      if ask "Do you want to use the new tag '$(_style_colorize $NEW_VERSION 32)'?" Y; then
        git tag ${NEW_VERSION} -m ""
        git push --tags
      fi
    fi
  else
    echo "No tags were found..."
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

# taken from http://github.com/bryanl/zshkit/
github-url () { git config remote.origin.url | sed -En 's/git(@|:\/\/)github.com(:|\/)(.+)\/(.+).git/https:\/\/github.com\/\3\/\4/p'; }
github () { open $(github-url); }
git-scoreboard () { git log | grep '^Author' | sort | uniq -ci | sort -r; }

# finds and kills a proccess by port
killport () { lsof -i TCP:$1 | grep LISTEN | awk '{print $2}' | xargs kill -QUIT; }

# https://gist.github.com/davejamesmiller/1965569
ask() {
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

# reload source
reload-source () { source ~/.bash_profile; }

# list directory after cd
cd () { builtin cd "${@:-$HOME}" && ls; }

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

fill_ebignore_docker () { ls -Ap | sort -u | grep -vE '.ebextensions|Dockerrun.aws.json' > .ebignore; }

# Colors
BLUE="\[\e[0;34m\]"
CYAN="\[\e[0;36m\]"
GRAY="\[\e[1;30m\]"
GREEN="\[\e[0;32m\]"
PINK="\[\e[0;35m\]"
RED="\[\e[0;31m\]"
WHITE="\[\e[1;37m\]"
YELLOW="\[\e[0;33m\]"
YELLOW_BOLD="\[\e[1;33m\]"
BLUE_BOLD="\[\e[1;34m\]"
GRAY_BOLD="\[\e[1;30m\]"
GREEN_BOLD="\[\e[1;32m\]"
NC="\[\e[0m\]" # no color

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
    [ "$RVM_GEMSET" != "" ] && RVM="$RVM ${GRAY_BOLD}${RVM_GEMSET}${NC}"
  fi

  # battery=$(ioreg -l | awk '$3~/Capacity/{c[$3]=$5}END{OFMT="%.2f%";max=c["\"MaxCapacity\""];print(max>0?100*c["\"CurrentCapacity\""]/max:"?")}')
  # battery=$(pmset -g batt)

  DATERIGHT=$(($COLUMNS + 12))
  HEADLINE=$(printf "%-${DATERIGHT}s %s" "${YELLOW_BOLD}\u${NC}|${GREEN_BOLD}\h${NC}" "${GRAY}\D{%d/%m/%Y} \t${NC}")
  PS1="$HEADLINE\n$BLUE_BOLD\w$NC" # basic ps1

  local GITBRANCH=`git branch 2>&1 | grep \* | sed 's/* //'`
  # local GITBRANCH=`__git_ps1 "%s" | awk '{print $1;}'`
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
