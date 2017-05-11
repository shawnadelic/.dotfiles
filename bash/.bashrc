alias time='date +"%r"'

alias xit="exit"

alias less="less -R"
alias list='ls -agh --color --time-style=+"%R"'

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

csv() {
    column -s, -t < $1 | less -#2 -N -S
}

json() {
    # If JPL file, strip leading fingerprint for each line and pipe to jq
    if [[ $1 == *jpl.gz ]]; then
        gzip -cd $1 | sed -r 's/^[a-zA-Z0-9]+:(.*)$/\1/g' | jq '.' -C | less -R
    elif [[ $1 == *jpl ]]; then
        cat $1 | sed -r 's/^[a-zA-Z0-9]+:(.*)$/\1/g' | jq '.' -C | less -R
    elif [[ ! -z $1 ]]; then
        jq '.' -C $1
    fi
}
