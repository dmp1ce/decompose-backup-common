#!/usr/bin/env bats

# These tests setup containers required for backups to work and test functionality.
# Order of tests matter in this bats.

load "$BATS_TEST_DIRNAME/bats_functions.bash"

@test "Build required containers for backup tests" {
  cd "$WORKING"

  # NOTICE: Due to SSH server IP changing and no support for automatic fingerprint acceptance
  # this test does not use the SSH server, but instead uses a local directory for backup tests.
  #
  #echo "Start backup destination server running ssh"
  #docker build -t "decompose-backup-ssh-server-tester" -f dockerfiles/Dockerfile.ssh-server .
  #docker run --name decompose-backup-ssh-server-tester-instance -d decompose-backup-ssh-server-tester

  echo "Start mysql compatible server"
  docker run --name decompose-backup-mariadb-tester-instance \
    -e MYSQL_ROOT_PASSWORD=my-secret-pw \
    -e MYSQL_DATABASE=test_db \
    -e MYSQL_USER=tester \
    -e MYSQL_PASSWORD=password \
    -d mariadb
  # TODO: Populate test_db database with some data.

  echo "Build backup source container"
  #echo "PROJECT_BACKUP_TARGET=\"ssh://tester@$(echo_ssh_ip)/backup\"" >> "$WORKING/.decompose/elements"
  #echo "PROJECT_BACKUP_CONFIG_TARGET=\"tester@$(echo_ssh_ip):backup_configuration\"" >> "$WORKING/.decompose/elements"
  decompose --build
  cp client_files/gpgkey.* containers/backup/.duply/site_data
  #cp client_files/id_rsa* containers/backup/.ssh
  # TODO: Generate known_hosts file with ssh-keyscan
  #cp client_files/known_hosts containers/backup/.ssh
  docker build -t "decompose-backup-source-tester" containers/backup/.
}

@test "Can ping test services by IP" {
  #ping -c 1 $(echo_ssh_ip)
  docker run --rm --link "decompose-backup-mariadb-tester-instance:db" decompose-backup-source-tester ping -c 1 $(echo_mariadb_ip)
}

@test "Run backup" {
  cd "$WORKING" 

  # TODO: Create volume for backup so backup results can be checked more easily.

  docker run --rm --link "decompose-backup-mariadb-tester-instance:db" decompose-backup-source-tester bash -c "mkdir -p /tmp/{backup_test,config_backup_test} && duply site_data backup && ls -alh /tmp/backup_test && ls -alh /tmp/config_backup_test"
}

@test "Remove docker containers created for tests" {
  #skip "For local debugging of tests"
  #docker rm -fv decompose-backup-ssh-server-tester-instance
  docker rm -fv decompose-backup-mariadb-tester-instance
}

function echo_ssh_ip() {
  echo_container_name_ip decompose-backup-ssh-server-tester-instance
}

function echo_mariadb_ip() {
  echo_container_name_ip decompose-backup-mariadb-tester-instance
}

# Return the IP for a container name.
# PARAM 1: Container name or CID
function echo_container_name_ip() {
  echo $(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $1)
}

function setup() {
  setup_testing_environment
}

function teardown() {
  teardown_testing_environment
}

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
