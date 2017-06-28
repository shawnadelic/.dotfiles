# Wip - Create work-in-progress temp commit
alias wip="git add -A && git commit -m 'WIP'"

# Unwip - Uncommit previous wip commit, leaving changes in working branch
unwip() {
    COMMIT_MESSAGE=$(git show -s --format=%s%b HEAD)

    if [[ $COMMIT_MESSAGE == "WIP" ]]; then
        git reset HEAD~
        git status
    else
        echo "Error: Not a WIP commit"
    fi
}

# Basic CSV output
csv() {
    column -s, -t < $1 | less -#2 -N -S
}

# Colorful man pages
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

# Custom prompt
export PS1="\[\e[0;35m\]\u@\h\[\e[m\]\[\e[0;36m\]\w\[\e[m\]\[\e[0;37m\]\$(parse_git_branch)\[\e[m\]\$ "
parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Editor settings
export VISUAL=vim
export EDITOR="$VISUAL"

# Print all colors
all_colors() {
    color_per_row=12
    for i in {0..255}; do
        printf "\x1b[38;5;${i}mcolour${i}\x1b[0m ";
        if [ $(($i % $color_per_row)) = $((color_per_row - 1)) ]; then
            echo
        fi
    done
    echo
}

# Aliases and shortcuts
alias h='history'
alias c='clear'
alias x='exit'
alias r='fc -s' # repeat

alias less="less -R"  # Colorful less
alias list='ls -agh --color --time-style=+"%R"'  # More detailed ls
alias time='date +"%r"'  # Current (readable) datetime

# Git aliases
alias gs='git status'
alias gl='git log'
alias gd='git diff'
alias gb='git branch'
alias ga='git add -A'
alias gc='git checkout'
alias branch='git branch'
alias checkout='git checkout'

# Ctags alias for python directories
alias pytags="ctags -R --fields=+l --languages=python --python-kinds=-iv ."

# By default, pgrep and pkill stupidly only search first 15 characters
# of process names.
alias pgrep='pgrep -f'
alias pkill='pkill -f'

# Common typos
alias xit="exit"
alias eixt="exit"
alias Q="q"
