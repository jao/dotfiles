#!/usr/bin/env bash

# ls aliases
alias ls="ls --color"
alias ll="ls -lh"
alias lah="ls -lAh" # list all but hide . and ..
alias la="ls -la" # List all files colorized in long format, including dot files
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

alias lock='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'
alias screensaver='open -a /System/Library/Frameworks/ScreenSaver.framework//Versions/A/Resources/ScreenSaverEngine.app'

# git related shortcuts
alias g="git"
alias ga='git add -A'
alias gap='ga -p'
alias gau='git add -u'
alias gbr='git branch -v'
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