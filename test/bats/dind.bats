#!/usr/bin/env bats

TESTER_IMAGE="docker run --rm --link decompose-docker-backup-testing:docker docker run --rm tester"

@test "backup_config process - no Docker Compose" {
  $TESTER_IMAGE sh -c "cd /app && \
git init
git config --global user.email 'user@example.com' && \
git config --global user.name 'The User' && \
git add .
git commit -m 'Initial commit' && \
touch something_here && decompose backup_config && \
ls /app/config_backup"
}

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
