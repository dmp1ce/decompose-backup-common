#!/usr/bin/env bats

# Test current environment

@test "'realpath' exists" {
  run realpath --version
  
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "'wc' exists" {
  run which wc
  
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "'uuidgen' exists" {
  run uuidgen
  
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
