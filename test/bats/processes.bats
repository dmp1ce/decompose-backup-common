#!/usr/bin/env bats

load "$BATS_TEST_DIRNAME/bats_functions.bash"

@test "Processes are loaded" {
  cd "$WORKING"
  local matched_lines=$(decompose --help | grep backup_config | wc -l)

  [ "$matched_lines" -gt 0 ]
}

function setup() {
  setup_testing_environment
} 

function teardown() {
  teardown_testing_environment
}

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
