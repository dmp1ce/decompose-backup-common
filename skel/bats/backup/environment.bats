#!/usr/bin/env bats

# Test current environment

@test "'realpath' exists" {
  run realpath --version
  
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "'wc' exists" {
  run wc --version
  
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "'uuidgen' exists" {
  run uuidgen
  
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "'chmod --reference' works" {
  mkdir -p "$BATS_TMPDIR/$BATS_TEST_NAME"
  cd "$BATS_TMPDIR/$BATS_TEST_NAME"
  touch test-reference
  touch test2
  
  run chmod --reference test-reference test2
  
  # Cleanup a bit after running test
  rm test-reference
  rm test2
  cd "$BATS_TMPDIR"
  rmdir "$BATS_TMPDIR/$BATS_TEST_NAME"

  # Verify that the test passed
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "'docker-compose' exists" {
  run docker-compose version
  
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "'decompose' exists" {
  run decompose

  echo "$output"
  [ "$status" -eq 0 ]
}

@test "'git' exists" {
  run git --version

  echo "$output"
  [ "$status" -eq 0 ]
}

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
