FROM busybox
MAINTAINER David Parrish <daveparrish@tutanota.com>

# Persistant backup data container

# Mount writable directories so they don't get changed on the host by accident
RUN install -dm777 /home/duply/backup
VOLUME /home/duply/backup
RUN install -dm777 /home/duply/backup_config
VOLUME /home/duply/backup_config
