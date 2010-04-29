# reload source
reload () { source ~/.bash_functions; }

# show path list
# pathlist () { echo $PATH | awk -F ":" '{ for(i=1; i<=NF; i++){print $i;} }' | uniq -i; }
# pathclean () { echo $PATH  | tr ':' '\n' | uniq -i | xargs | tr ' ' ':'; }

# list directory after cd
cd () { builtin cd "${@:-$HOME}" && ls; }

# enter a recently created directory
# mkdir () { mkdir "${@}" && eval cd "\$$#"; }
# this is bugging rvm behavior

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
