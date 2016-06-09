FROM debian:jessie
MAINTAINER David Parrish <daveparrish@tutanota.com>

# Update Debian.
# install requirements (duply, mariadb-client, ssh)
RUN apt-get -y update && \
apt-get install -y -q --no-install-recommends \
  ca-certificates \
  duply \
  mariadb-client \
  openssh-client \
  python-paramiko \
  dateutils \
&& apt-get clean \
&& rm -r /var/lib/apt/lists/*

# Create user to run backups
RUN useradd -m -s /bin/bash duply

# Copy duply profiles
COPY .duply/ {{PROJECT_BACKUP_USER_HOME}}/.duply
RUN chmod -R 700 {{PROJECT_BACKUP_USER_HOME}}/.duply &&\
  chown -R duply:duply {{PROJECT_BACKUP_USER_HOME}}/.duply
# Copy ssh keys
COPY .ssh/ {{PROJECT_BACKUP_USER_HOME}}/.ssh
RUN chmod -R 700 {{PROJECT_BACKUP_USER_HOME}}/.ssh &&\
  chown -R duply:duply {{PROJECT_BACKUP_USER_HOME}}/.ssh

# Create directory for exporting sql
RUN mkdir -p /srv/http/sql_backup && chmod 777 /srv/http/sql_backup

# Add GPG keys for encrypting config tars
COPY public_keys {{PROJECT_BACKUP_USER_HOME}}/public_keys
COPY load_developer_keys {{PROJECT_BACKUP_USER_HOME}}/
RUN chmod a+rx {{PROJECT_BACKUP_USER_HOME}}/load_developer_keys

# Setup volumes for backup
RUN install -dm777 {{PROJECT_BACKUP_USER_HOME}}/backup && \
  install -dm777 {{PROJECT_BACKUP_USER_HOME}}/{{PROJECT_BACKUP_CONFIG_BACKUP_DIRECTORY}} && \
  install -dm777 {{PROJECT_BACKUP_USER_HOME}}/.cache/duplicity && \
  install -dm777 {{PROJECT_BACKUP_SOURCE}}/sql_backup
VOLUME {{PROJECT_BACKUP_USER_HOME}}/backup
VOLUME {{PROJECT_BACKUP_USER_HOME}}/{{PROJECT_BACKUP_CONFIG_BACKUP_DIRECTORY}}
VOLUME {{PROJECT_BACKUP_USER_HOME}}/.cache/duplicity
VOLUME {{PROJECT_BACKUP_SOURCE}}/sql_backup

# Run as user
USER {{PROJECT_BACKUP_USER}}

# Build site
WORKDIR {{PROJECT_BACKUP_USER_HOME}}

# Load the public keys into key chain for encrypting config tars
RUN ./load_developer_keys

# Copy backup service script
COPY backup_service {{PROJECT_BACKUP_USER_HOME}}/backup_service

# Run backup service script by default
CMD {{PROJECT_BACKUP_USER_HOME}}/backup_service
