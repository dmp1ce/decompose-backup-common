#!/bin/bash

function echo_tmpdir() {
  echo "$BATS_TMPDIR/$BATS_TEST_NAME"
}

function setup_testing_environment() {
  # Setup project in temporary directory.
  local tmpdir=$(echo_tmpdir)
  
  # Directory for setting up tests
  local tmpdir=$(echo_tmpdir)
  mkdir -p "$tmpdir/build-test-environment"
 
  # Setup build test environment
  cp -r "$BATS_TEST_DIRNAME/../../." "$tmpdir/build-test-environment"
  mv "$tmpdir/build-test-environment/.git" "$BATS_TMPDIR/$(uuidgen)"
  local git_url=$(realpath $tmpdir/build-test-environment)
  git -C "$git_url" init
  git -C "$git_url" config user.email "tester@example.com"
  git -C "$git_url" config user.name "tester"
  git -C "$git_url" add .
  git -C "$git_url" commit -m "Initial commit"

  # Make and set home directory
  mkdir -p "$tmpdir/user-home"
  export HOME=$(realpath "$(echo_tmpdir)/user-home")

  # Set current working directory
  export WORKING="$tmpdir/build-test"
  mkdir -p "$tmpdir/build-test"

  # Init build and initialize environment
  local error_output=$(export HOME=$HOME && cd $WORKING && \
    decompose --init "$git_url" 2>&1 1>/dev/null)
  if [ -n "$error_output" ]; then
    echo "'decompose --init' had errors"
    echo "$error_output"
    return 1
  fi

  # Reference elements and processes files in WORKING directory
  cp "$BATS_TEST_DIRNAME/fixtures/elements" "$tmpdir/build-test/.decompose"
  cp "$BATS_TEST_DIRNAME/fixtures/processes" "$tmpdir/build-test/.decompose"
  cp -r "$BATS_TEST_DIRNAME/fixtures/dockerfiles" "$tmpdir/build-test"
  cp -r "$BATS_TEST_DIRNAME/fixtures/client_files" "$tmpdir/build-test"
}

function teardown_testing_environment() {
  # Directory for setting up tests
  local tmpdir=$(echo_tmpdir)

  # Move generated test files to random temporary
  # directory where it will eventually be cleaned up
  mv "$tmpdir" "$tmpdir-$(uuidgen)"
}

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
