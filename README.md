# decompose-backup-common
Common code for backup processes in decompose environments

## Requirements

- [decompose](https://github.com/dmp1ce/decompose)
- [Docker](http://www.docker.com/) (Optional if using Duply backup container)

## Install

Include this library and source `elements` and `processes` files your main decompose environment.

### Example

First add lib as a submodule to your environment:
``` bash
$ cd .decompose/environment
$ git submodule add https://github.com/dmp1ce/decompose-backup-common.git lib/backup
```

Then make your `processes` and `elements` file look like this:
``` bash
$ cat elements
# Include common elements
source $(_decompose-project-root)/.decompose/environment/lib/backup/elements
$ cat processes
# Include common processes
source $(_decompose-project-root)/.decompose/environment/lib/backup/processes
DECOMPOSE_PROCESSES=( "${DECOMPOSE_BACKUP_PROCESSES[@]}" )
```

## Environment configuration backup

Most files should be commited to source control (or git in our case). Some files however, should not. Files such as configuration files containing secrets or files generated from a template should not be checked in. Because these files are not stored in git, they should periodically be backuped up just in case. The `backup_config` process does a backup on everything not checked into git unless an explicit ignore is defined. See [elements](#elements) and [processes](#processes) sections for details.

## Duply

Duply is a frontend to the Duplicity backup script. Duply provides a configuration to automated backups and restores. This decompose environment handles much of the Duply configuration. Elements need to be configured to specify SSH key, GPG key and paths.

## Encryption

By default, Duply backups are not encrypted. Generate a GPG key and save it to `containers/backup/.duply` to enable encrypted Duply backups. Configuration backups will be copied to the duply data container if available and the backup service will attempt to encrypt the configuration backup and send it to configured remote server.

In this way, the backup server cannot read any of the backup data and can be low trust. Backups could be sent to multiple locations if desired without fear of leaking the website's private data.

## Elements

- `PROJECT_BACKUP_CONFIG_NAME` : Base name for decompose configuration files backup. Default is `backup`.
- `PROJECT_BACKUP_INCLUDES` : Explicitly specify which files/directories should be backed up. Use space character (` `) as delimiter. Default is `.decompose`.
- `PROJECT_BACKUP_EXCLUDES` : Specify files to ignore from configuration backup. Use space character (` `) as delimiter. Default is `.gitmodules`.
- `PROJECT_BACKUP_GPG_KEY` : The GPG key ID. This is not set by default. The key ID should be the same name as the file. Example: `9BE46F55`.
- `PROJECT_BACKUP_GPG_PW` : The GPG key encryption password. Default is not set. Example: `MySecretPassword1234`.
- `PROJECT_BACKUP_SOURCE` : The location of the source to backup. Default is `/srv/http/source`.
- `PROJECT_BACKUP_TARGET` : The full Duply path to where the Duply backup should be saved. Default is not set. Example: `ssh://backupuser@backupserver/myproject_path`.
- `PROJECT_BACKUP_CONFIG_TARGET` : The full SSH path to where the backup configuration should be saved. Default is not set. Example: `backupuser@backupserver:myproject_configuration_path`. NOTICE: There is a syntax difference between `PROJECT_BACKUP_TARGET` and `PROJECT_BACKUP_CONFIG_TARGET` in the paths.

### GPG key generation elements

Use these elements for generating a GPG key to encrypt backups

- `PROJECT_BACKUP_GPG_REALNAME` : First and Last name of GPG key. Default is `Firstname Lastname`.
- `PROJECT_BACKUP_GPG_COMMENT` : GPG key comment. Default is `No comment`.
- `PROJECT_BACKUP_GPG_EMAIL` : GPG key email. Default is `backup@example.com`.
- `PROJECT_BACKUP_GPG_KEY_DIR` : Location to copy the GPG key to after generation. Default is empty which will cause GPG key to be copied to decompose root directory.

### SSH key generation elements

Use these elemetns for generating a SSH key to access backup server.

- `PROJECT_BACKUP_SSH_KEY_DIR` : Location to copy generated SSH keys to. Default is empty which means generated keys are copied to decompose root directory.
- `PROJECT_BACKUP_SSH_COMMENT` : Comment of SSH public key. Default is `No comment`.
- `PROJECT_BACKUP_SERVER_IP` : Backup server IP so that the `known_host` file can be generated.

### Special elements

- `PROJECT_DB_PASSWORD`, `PROJECT_DB_USER`, `PROJECT_DB_DATABASE` : These element will be used when attempting to restore a mysql database using the `restore-db` process.


## Processes

- `backup_config` : Create backup of all files not checked in. See [elements](#elements) for configuration.
- `generate_gpg_backup_keys` : Generate GPG key for encrypting backup. See [elements](#elements) for configuration.
- `generate_backup_server_ssh_access_key` : Generate SSH key for accessing backup server. See [elements](#elements) for configuration.
- `list-backups` : List backups created by Duply.
- `restore-db` : Restores database from specified backup. Specify backup with the same time as listed in the `list-backups` process.
