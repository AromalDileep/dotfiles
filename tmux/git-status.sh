#!/usr/bin/env bash

# Use pane_current_path or default to PWD
path="${1:-$(tmux display-message -p '#{pane_current_path}' 2>/dev/null || echo "$PWD")}"

# If not in a git repo, exit silently
status_output="$(git -C "$path" status --porcelain=v2 --branch 2>/dev/null)" || exit 0

# Get absolute git dir and stash hash efficiently in one command.
# If refs/stash doesn't exist, git rev-parse exits with error, 
# but still outputs the absolute-git-dir to stdout.
out="$(git -C "$path" rev-parse --absolute-git-dir --verify refs/stash 2>/dev/null)"
{
    IFS= read -r git_dir
    IFS= read -r stash_hash
} <<< "$out"

branch=""
oid=""
ahead=0
behind=0

is_modified=0
is_staged=0
is_untracked=0
is_renamed=0
is_deleted=0
is_conflicted=0

while IFS= read -r line; do
    # OID for detached head
    if [[ "$line" == "# branch.oid "* ]]; then
        oid="${line#\# branch.oid }"
        continue
    fi
    # Branch and detached head
    if [[ "$line" == "# branch.head "* ]]; then
        branch="${line#\# branch.head }"
        continue
    fi
    # Ahead/Behind
    if [[ "$line" == "# branch.ab "* ]]; then
        ab="${line#\# branch.ab }"
        read -r a b <<< "$ab"
        ahead="${a#+}"
        behind="${b#-}"
        continue
    fi

    # Ignore other headers
    if [[ "$line" == "#"* ]]; then
        continue
    fi

    # Conflicted files
    if [[ "$line" == "u "* ]]; then
        is_conflicted=1
        continue
    fi

    # Untracked files
    if [[ "$line" == "?"* ]]; then
        is_untracked=1
        continue
    fi

    # Ignored files
    if [[ "$line" == "!"* ]]; then
        continue
    fi

    # Tracked changed files: format: 1 <xy> ... or 2 <xy> ...
    xy="${line:2:2}"
    x="${xy:0:1}"
    y="${xy:1:1}"

    # Staged: x is M, A, R, C, D
    if [[ "$x" != "." ]]; then
        is_staged=1
    fi

    # Modified: y is M
    if [[ "$y" == "M" ]]; then
        is_modified=1
    fi

    # Deleted: x is D or y is D
    if [[ "$x" == "D" || "$y" == "D" ]]; then
        is_deleted=1
    fi

    # Renamed: x is R or C
    if [[ "$x" == "R" || "$x" == "C" ]]; then
        is_renamed=1
    fi
done <<< "$status_output"

# Resolve branch name for detached HEAD
if [[ "$branch" == "(detached)" && -n "$oid" && "$oid" != "(initial)" ]]; then
    branch="${oid:0:7}"
fi

# Build status symbols
status=""
[[ $is_conflicted -eq 1 ]] && status+="!"
[[ $is_modified -eq 1 ]] && status+="*"
[[ $is_staged -eq 1 ]] && status+="+"
[[ $is_renamed -eq 1 ]] && status+="»"
[[ $is_deleted -eq 1 ]] && status+="✘"
[[ $is_untracked -eq 1 ]] && status+="?"
[[ -n "$stash_hash" ]] && status+="≡"

# Build ahead/behind/diverged status
ab_status=""
if [[ $ahead -gt 0 && $behind -gt 0 ]]; then
    ab_status="⇕⇡${ahead}⇣${behind}"
elif [[ $ahead -gt 0 ]]; then
    ab_status="⇡${ahead}"
elif [[ $behind -gt 0 ]]; then
    ab_status="⇣${behind}"
fi

# Determine git state
state=""
if [[ -n "$git_dir" ]]; then
    if [[ -d "$git_dir/rebase-merge" ]]; then
        if [[ -f "$git_dir/rebase-merge/interactive" ]]; then
            state="REBASE-i"
        else
            state="REBASE-m"
        fi
    elif [[ -d "$git_dir/rebase-apply" ]]; then
        if [[ -f "$git_dir/rebase-apply/rebasing" ]]; then
            state="REBASE"
        elif [[ -f "$git_dir/rebase-apply/applying" ]]; then
            state="AM"
        else
            state="AM/REBASE"
        fi
    elif [[ -f "$git_dir/MERGE_HEAD" ]]; then
        state="MERGING"
    elif [[ -f "$git_dir/CHERRY_PICK_HEAD" ]]; then
        state="CHERRY-PICKING"
    elif [[ -f "$git_dir/REVERT_HEAD" ]]; then
        state="REVERTING"
    elif [[ -f "$git_dir/BISECT_LOG" ]]; then
        state="BISECTING"
    fi
fi

# Assemble final output
out=" ${branch}"

extras=""
[[ -n "$ab_status" ]] && extras+=" ${ab_status}"
[[ -n "$status" ]] && extras+=" ${status}"
[[ -n "$state" ]] && extras+=" | ${state}"

if [[ -n "$extras" ]]; then
    # Apply cyan (date/time color) to symbols, then reset back to magenta
    out+="#[fg=cyan,bright]${extras}#[fg=magenta,bright]"
fi

printf "%s" "$out"
