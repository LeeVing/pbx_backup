#!/usr/bin/env bash

function get_git_branch() {
  # On branches, this will return the branch name
  # On non-branches, (no branch)
  ref="$(git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///')"
  if [[ $ref != "" ]]; then
    echo $ref
  else
    echo "(no branch)"
  fi
}

function get_git_progress() {
  # Detect in-progress actions (e.g. merge, rebase)
  # https://github.com/git/git/blob/v1.9-rc2/wt-status.c#L1199-L1241
  git_dir="$(git rev-parse --git-dir)"
  if [[ -f "$git_dir/MERGE_HEAD" ]]; then
    echo " [merge]"
  fi
}

is_branch1_behind_branch2 () {
  # $ git log origin/master..master -1
  # commit 4a633f715caf26f6e9495198f89bba20f3402a32
  # Author: Todd Wolfson <todd@twolfson.com>
  # Date:   Sun Jul 7 22:12:17 2013 -0700
  #
  #     Unsynced commit

  # Find the first log (if any) that is in branch1 but not branch2
  first_log="$(git log $1..$2 -1 2> /dev/null)"

  # Exit with 0 if there is a first log, 1 if there is not
  [[ -n "$first_log" ]]
}

branch_exists () {
  # List remote branches           | # Find our branch and exit with 0 or 1 if found/not found
  git branch --remote 2> /dev/null | grep --quiet "$1"
}

parse_git_ahead () {
  # Grab the local and remote branch
  branch="$(get_git_branch)"
  remote_branch=origin/"$branch"

  # $ git log origin/master..master
  # commit 4a633f715caf26f6e9495198f89bba20f3402a32
  # Author: Todd Wolfson <todd@twolfson.com>
  # Date:   Sun Jul 7 22:12:17 2013 -0700
  #
  #     Unsynced commit

  # If the remote branch is behind the local branch
  # or it has not been merged into origin (remote branch doesn't exist)
  if (is_branch1_behind_branch2 "$remote_branch" "$branch" ||
      ! branch_exists "$remote_branch"); then
    # echo our character
    echo 1
  fi
}

parse_git_behind () {
  # Grab the branch
  branch="$(get_git_branch)"
  remote_branch=origin/"$branch"

  # $ git log master..origin/master
  # commit 4a633f715caf26f6e9495198f89bba20f3402a32
  # Author: Todd Wolfson <todd@twolfson.com>
  # Date:   Sun Jul 7 22:12:17 2013 -0700
  #
  #     Unsynced commit

  # If the local branch is behind the remote branch
  if is_branch1_behind_branch2 "$branch" "$remote_branch"; then
    # echo our character
    echo 1
  fi
}

function parse_git_dirty() {
  # If the git status has *any* changes (e.g. dirty), echo our character
  if [[ -n "$(git status --porcelain 2> /dev/null)" ]]; then
    echo 1
  fi
}

function is_on_git() {
  git rev-parse 2> /dev/null
}

function get_git_status() {
  # Grab the git dirty and git behind
  dirty_branch="$(parse_git_dirty)"
  branch_ahead="$(parse_git_ahead)"
  branch_behind="$(parse_git_behind)"

  # Iterate through all the cases and if it matches, then echo
  if [[ $dirty_branch == 1 && $branch_ahead == 1 && $branch_behind == 1 ]]; then
    echo "⬢"
  elif [[ $dirty_branch == 1 && $branch_ahead == 1 ]]; then
    echo "▲"
  elif [[ $dirty_branch == 1 && $branch_behind == 1 ]]; then
    echo "▼"
  elif [[ $branch_ahead == 1 && $branch_behind == 1 ]]; then
    echo "⬡"
  elif [[ $branch_ahead == 1 ]]; then
    echo "△"
  elif [[ $branch_behind == 1 ]]; then
    echo "▽"
  elif [[ $dirty_branch == 1 ]]; then
    echo "*"
  fi
}

get_git_info () {
  # Grab the branch
  branch="$(get_git_branch)"

  # If there are any branches
  if [[ "$branch" != "" ]]; then
    # Echo the branch
    output="$branch"

    # Add on the git status
    output="$output$(get_git_status)"

    # Echo our output
    echo "$output"
  fi
}

# Symbol displayed at the line of every prompt
function get_prompt_symbol() {
  # If we are root, display `#`. Otherwise, `$`
  if [[ $UID == 0 ]]; then
    echo "$RED#$NC"
  else
    echo "\$"
  fi
}
