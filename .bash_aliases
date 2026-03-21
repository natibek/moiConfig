# custom aliases
alias sai='sudo apt install'
alias clrx='clear -x'
alias fsa='wmctrl -r :ACTIVE: -b toggle,maximized_horz,maximized_vert'
alias fsf='wmctrl -r :ACTIVE: -b toggle,fullscreen'
alias cdir='cd "${_%/*}"'
alias py="ipython --InteractiveShellApp.extensions 'autoreload' --InteractiveShellApp.exec_lines '%autoreload 2'"
alias bat="batcat"
alias la="ls -a"
alias ll="ls -l"
alias kn="pkill keynav && keynav daemonize"

export gitpre='git@github.com:natibek'

alias gs='git status'
alias glog='git log --oneline --graph'

# emacs aliases
# alias enwb='wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz; emacs -nw' # maximize the screen
# alias enwf='wmctrl -r :ACTIVE: -b add,fullscreen; emacs -nw' # fullscreen
# alias enw='emacs -nw' # in the terminal

alias enwb='f() { args=""; for a in "$@"; do args="$a $args"; done; wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz; emacs -nw $args; unset -f f;}; f'
alias enwf='f() { args=""; for a in "$@"; do args="$a $args"; done; wmctrl -r :ACTIVE: -b add,fullscreen; emacs -nw $args; unset -f f;}; f'
alias enw='f() { args=""; for a in "$@"; do args="$a $args"; done; emacs -nw $args; unset -f f;}; f'

RED='\033[0;31m'
IRED='\033[0;91m'
GREEN='\033[0;32m'
NC='\033[0m'
num_re='^[0-9]+$'

function lg() {
  ls -A | grep -i $@
}

function mkcd() {
   if [ $# -eq 1 ]; then
      mkdir $@
      cd $@
   fi
}

function cdb() {
   count=0
   if [ $# -eq 0 ]; then
      cd ..
   else
      while [ $count -lt "$@" ]; do
         cd ..
         ((count++))
      done
   fi
}

function cdr() {
   count=0
   address=$(pwd)
   if [[ -d "$1" ]]; then
      cd "$1"
      echo -e "${GREEN}$PWD${NC}\n"
      echo -e "${GREEN}------${NC}"
      eval "$2"
      echo -e "${GREEN}------${NC}"
      cd "$address"
   elif [[ "$1" =~ $num_re ]]; then
      while [ $count -lt "$1" ]; do
         cd ..
         ((count++))
      done
      echo -e "${GREEN}$PWD${NC}\n"
      echo -e "${GREEN}------${NC}"
      eval "$2"
      echo -e "${GREEN}------${NC}"
      cd "$address"
   else
      echo -e "${IRED}<$1> is not a directory or integer.${NC}"
   fi
}

function virt() {
   if [ $# -eq 1 ] && [ -d $@ ] && [ -f $@/bin/activate ]; then
      . "$@"/bin/activate
   elif [ $# -eq 0 ] && [ -d .venv ] && [ -f .venv/bin/activate ]; then
      . .venv/bin/activate
   else
      echo -e "${IRED}\tvirt: No arg or invalid virtual environment path.${NC}"
   fi
}

function serve() {
   port=8000
   if [ $# -eq 1 ] && [ $@ -gt 0 ]; then
      port=$@
   fi
   python3 -m http.server $port
}

function code-lines() {
   grep_pattern=""

   if [ $# -eq 0 ]; then
      echo "No extensions provided"
      return 1
   fi

   for arg in $*; do
      grep_pattern+="\.$arg$\|"
   done

   # git ls-files | grep ${grep_pattern:0:-2} #| xargs wc -l
   ls -R | awk '/:$/ {dir=substr($0, 1, length($0)-1); next} NF {print dir "/" $0}' | grep ${grep_pattern:0:-2} | xargs wc -l

}

