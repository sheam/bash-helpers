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

function git_rebase_all_master()
{
    local DRY_RUN=false
    if [ "$1" = "--dry-run" ] || [ "$1" = "-n" ]; then
        DRY_RUN=true
    fi

    local PARENT_BRANCH
    PARENT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [ -z "$PARENT_BRANCH" ]; then
        echo "Error: Parent repo is on a detached HEAD. Please checkout a branch first."
        return 1
    fi

    local rebased=()
    local detached=()
    local pulled=()
    local skipped=()
    local failed=()

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] No changes will be made."
        echo ""
    fi

    echo "Parent repo branch: $PARENT_BRANCH"
    echo ""

    while read -r sm_path; do
        echo "=== Submodule: $sm_path ==="

        local SUB_BRANCH
        SUB_BRANCH=$(git -C "$sm_path" symbolic-ref --short HEAD 2>/dev/null)

        if [ -z "$SUB_BRANCH" ]; then
            # Detached HEAD — checkout latest master
            if [ "$DRY_RUN" = true ]; then
                echo "  Detached HEAD detected. Would checkout latest master."
            else
                echo "  Detached HEAD detected. Checking out latest master..."
                git -C "$sm_path" fetch origin master
                git -C "$sm_path" checkout master
                git -C "$sm_path" pull origin master
            fi
            detached+=("$sm_path")
        elif [ "$SUB_BRANCH" = "master" ]; then
            # On master — pull latest
            if [ "$DRY_RUN" = true ]; then
                echo "  On master. Would pull latest."
            else
                echo "  On master. Pulling latest..."
                git -C "$sm_path" pull origin master
            fi
            pulled+=("$sm_path")
        elif [ "$SUB_BRANCH" = "$PARENT_BRANCH" ]; then
            # Branch matches parent — rebase onto latest master
            if [ "$DRY_RUN" = true ]; then
                echo "  On branch '$SUB_BRANCH' (matches parent). Would rebase onto origin/master."
            else
                echo "  On branch '$SUB_BRANCH' (matches parent). Rebasing onto origin/master..."
                git -C "$sm_path" fetch origin master
                if ! git -C "$sm_path" rebase origin/master; then
                    echo "  Error: Rebase failed in $sm_path. Aborting rebase."
                    git -C "$sm_path" rebase --abort
                    echo "  Resolve conflicts manually and retry."
                    failed+=("$sm_path")
                    echo ""
                    continue
                else
                    echo "  Successfully rebased '$SUB_BRANCH' onto origin/master."
                fi
            fi
            rebased+=("$sm_path")
        else
            echo "  On branch '$SUB_BRANCH' (does not match parent '$PARENT_BRANCH'). Skipping."
            skipped+=("$sm_path")
        fi

        echo ""
    done < <(git submodule foreach --quiet 'echo $sm_path')

    # Report
    echo "==============================="
    if [ "$DRY_RUN" = true ]; then
        echo "  DRY RUN REPORT"
    else
        echo "  SUMMARY REPORT"
    fi
    echo "==============================="

    if [ ${#rebased[@]} -gt 0 ]; then
        echo ""
        echo "Rebased onto master (${#rebased[@]}):"
        for r in "${rebased[@]}"; do echo "  - $r"; done
    fi

    if [ ${#detached[@]} -gt 0 ]; then
        echo ""
        echo "Detached HEAD → checked out master (${#detached[@]}):"
        for r in "${detached[@]}"; do echo "  - $r"; done
    fi

    if [ ${#pulled[@]} -gt 0 ]; then
        echo ""
        echo "On master → pulled latest (${#pulled[@]}):"
        for r in "${pulled[@]}"; do echo "  - $r"; done
    fi

    if [ ${#failed[@]} -gt 0 ]; then
        echo ""
        echo "Rebase FAILED (${#failed[@]}):"
        for r in "${failed[@]}"; do echo "  - $r"; done
    fi

    if [ ${#skipped[@]} -gt 0 ]; then
        echo ""
        echo "Skipped (${#skipped[@]}):"
        for r in "${skipped[@]}"; do echo "  - $r"; done
    fi

    echo ""
}
