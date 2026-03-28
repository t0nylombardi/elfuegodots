alias rbe='bundle exec'

prepare_spec() {
  # Log the start of the process
  echo "Starting CI setup and tests..."

  # Run the command, but ensure it only proceeds if db:prepare is successful
  CI=true bundle exec rails db:prepare spec
  if [ $? -eq 0 ]; then
    echo "Database prepared successfully, running tests..."
    bundle exec rspec
  else
    echo "Error: Database preparation failed. Aborting tests."
    return 1
  fi
}

rtest() {
  CI=true bundle exec rspec
}

rspect() {
  CI=true bundle exec rspec
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
