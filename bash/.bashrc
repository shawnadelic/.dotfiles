# Empty title for empty bash windows (useful in tmux)
#if [[ "$TERM" == "screen-256color" ]] || [[ "$TERM" == "bash" ]]; then
#    echo -ne '\033k   \033\\'
#fi

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
export PS1="\[\e[38;5;154m\]\u@\h\[\e[m\]\[\e[38;5;198m\]\w\[\e[m\]\[\e[0;37m\]\$(parse_git_branch)\[\e[m\]\$ "
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

# Custom command for bashing into docker containers
basher() {
    case $1 in
        "")
            docker ps;
            return;;
        *)
            local server_name=$1
    esac

    if [ -n $server_name ]; then
        local server_id=$(docker ps -qf "name=$server_name" | cut -d ':' -f 2);
    fi

    if [ -n $server_name ] && [ -z $server_id ]; then
        echo "No docker server found with name $server_name.";
        echo;
        docker ps;
        return;
    fi

    if [ -n $server_id ]; then
        # To run as root: docker exec -it --user root bc6b496e64d9 bash
        docker exec -it $server_id bash;
    fi
}

json() {
    if [ ${1##*.} == "gz" ]; then
        echo "Do something different for gzipped files"
    else
        jq '.' --color-output $1 | less -R
    fi
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
alias gd='git diff --color=always ":(exclude)filename" | less'
alias gds='git diff --staged --color=always ":(exclude)filename"| less'
alias gb='git branch'
alias ga='git add -A'
alias gc='git checkout'
alias branch='git branch'
alias checkout='git checkout'

alias g='git branch'

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

# Shortcut for running docker-compose
alias compose='docker-compose'

# Shortcut for opening files
alias open='gnome-open'

# Workspace shortcuts
alias work='cd ~/workspace/'

# Tmux shortcuts
alias ta='tmux attach'

# List files and display chmod numeric value
alias chmod_ls="stat -f '%A %N' *"

# Find and replace
project_rename() {
    if [ "$#" -ne 2 ]; then
        echo "Renaming requires 2 arguments, you maniac!";
        return;
    fi
    # Ignore migrations directory - '-e' required for OSX
    ack -v -g 'migrations' | ack -xl $1 | xargs sed -i '' -e "s/$1/$2/g"
}

vack() {
    vim -p "ag $*"
}
