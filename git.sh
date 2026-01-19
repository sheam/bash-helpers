function rebase()
{
    if [ $# -eq 0 ]; then
        echo "Usage: rebase <branch-name>"
        echo ""
        echo "Fetches the latest changes from origin/<branch-name> and rebases"
        echo "the current branch onto it."
        echo ""
        echo "Example: rebase main"
        return 1
    fi

    local BRANCH=$1

    echo "Fetching latest changes from origin/$BRANCH..."
    if ! git fetch origin "$BRANCH"; then
        echo "Error: Failed to fetch origin/$BRANCH"
        return 1
    fi

    echo "Rebasing current branch onto origin/$BRANCH..."
    if ! git rebase "origin/$BRANCH"; then
        echo "Error: Rebase failed. You may need to resolve conflicts."
        echo "Use 'git rebase --continue' after resolving conflicts, or 'git rebase --abort' to cancel."
        return 1
    fi

    echo "Successfully rebased onto origin/$BRANCH"
    return 0
}

# Tab completion for rebase command
function _rebase_completions()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"

    # Complete with branch names from git
    if [ $COMP_CWORD -eq 1 ]; then
        local branches=$(git branch -a 2>/dev/null | sed 's/^[* ] //' | sed 's|remotes/origin/||' | sort -u)
        COMPREPLY=($(compgen -W "$branches" -- "$cur"))
        return 0
    fi
}

complete -F _rebase_completions rebase
