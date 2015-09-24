#!/bin/bash

# Export mysql database
mysqldump -u {{PROJECT_DB_USER}} -p{{PROJECT_DB_PASSWORD}} -h db {{PROJECT_DB_DATABASE}} | gzip > /srv/http/sql_backup/app.sql.gz
