alias git\?='git status'
alias git\?\?='git status -s'
alias gpu='git pull upstream $(git_current_branch)'
alias gpp='git push --set-upstream origin $(git_current_branch)'

gclone() {
  repo=$1
  git clone $repo
  cd $(basename $repo .git)
}

gcyt() {
  repo=$1
  git clone $repo
  cd $(basename $repo .git)
  yarn
  yarn test
}

gcpp() {
  if [ -z "$1" ]; then
    echo "Please provide a commit message."
    return 1
  fi

  git add .
  git commit -m "$1"

  current_branch=$(git rev-parse --abbrev-ref HEAD)
  git push --set-upstream origin "$current_branch"
}

ggab() {
  git branch -r \
  | grep -v '\->' \
  | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" \
  | while read remote; do \
      git branch --track "${remote#origin/}" "$remote"; \
    done
  git fetch --all
  git pull --all
}

# Function to delete local branches without a remote counterpart
# and without the keyword in their name
delete_local_branches() {
  # Define the keyword you want to look for in the branch name
  local keyword="STRAT"

  # List all local branches
  for branch in $(git branch --format '%(refname:short)'); do
    # Skip branches that do not contain the keyword "STRAT"
    if [[ "$branch" != *"$keyword"* ]]; then
      echo "Skipping branch: $branch (Does not contain the keyword $keyword)"
      continue
    fi

    # Check if the branch exists in remote
    if ! git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
      echo "Deleting local branch: $branch (No remote branch found)"
      git branch -d "$branch"
    fi
  done
}

nuke_gems() {
  # Step 1: Uninstall all gems (in parallel)
  echo "Uninstalling all gems..."
  gem list | cut -d ' ' -f 1 | parallel -j 4 gem uninstall -aIx

  # Step 2: Perform a gem cleanup to remove any unused gem versions
  echo "Cleaning up unused gem versions..."
  parallel -j 4 gem cleanup

  # Step 3: Reinstall gems from Gemfile
  echo "Reinstalling gems from Gemfile..."
  bundle install

  echo "Gem uninstallation and cleanup complete!"
}

# Function to checkout a branch by a partial name
gcobk() {
  if [ -z "$1" ]; then
    echo "Please provide a keyword to search for."
    return 1
  fi

  local keyword="$1"
  local branches=$(git branch --list "*$keyword*")

  if [ -z "$branches" ]; then
    echo "No branch found with the keyword: $keyword"
    return 1
  fi

  if [ "$(echo "$branches" | wc -l)" -gt 1 ]; then
    echo "Multiple branches found. Please choose one:"
    select branch in $branches; do
      if [ -n "$branch" ]; then
        echo "Checking out branch: $branch"
        git switch "$branch"
        break
      else
        echo "Invalid selection. Try again."
      fi
    done
  else
    echo "Checking out branch: $branches"
    git switch "$branches"
  fi
}

merge-dev() {
  git switch develop
  git pull --rebase
  git switch -
  git merge develop
}

create-branch() {
  if [ -z "$1" ]; then
    echo "Please provide a branch name."
    return 1
  fi

  git switch -c "$1"
}
alias gcbr=create-branch
