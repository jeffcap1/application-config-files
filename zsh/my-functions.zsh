# Example function
# myfunc() {
#   local dir="$HOME/{DIR}"

#   if [ "$1" != "" ]
#   then
#     cd "$dir/$1"
#   else
#     cd "$dir"
#   fi
# }

# Lazygit - change directory on exit
# @see https://github.com/jesseduffield/lazygit#changing-directory-on-exit
lg()
{
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}

# git - worktree niceity - create branch from main
# gcbm: Git Create Branch from Main
gcbm() {
  local new_branch="$1"
  local base_branch="$2"

  if [[ -z "$new_branch" ]]; then
    echo "Usage: gcbm <new-branch> [base-branch]"
    return 1
  fi

  # Ensure origin refs are up to date
  git fetch origin --prune >/dev/null 2>&1

  if [[ -z "$base_branch" ]]; then
    # find if the main branch is named main or master or something else
    base_branch=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD)

    if [[ -z "$base_branch" ]]; then
      echo "Could not determine origin default branch"
      return 1
    fi
  fi

  git branch "$new_branch" "$base_branch"
}


