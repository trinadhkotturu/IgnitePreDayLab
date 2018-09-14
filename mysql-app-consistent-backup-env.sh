#!/bin/bash
# 
# (C) 2016, CAPSiDE SL. All rights reserved.
# Total or partial distribution, copy or reproduction in any form, or usage
# without written authorization from CAPSiDE is prohibited and will be
# prosecuted.
# 
# Custom variables for mysql-app-consistent-backup.sh

# Folders and files

BASE_FOLDER="/opt/capside/azure"
DUMPS_FOLDER="${BASE_FOLDER}/dumps"
LOGS_FOLDER="${BASE_FOLDER}/logs"

FILE_INFIX="mysql-app-consistent-backup"

SCRIPT_FILE="${BASE_FOLDER}/${FILE_INFIX}.sh"
LOG_FILE="${LOGS_FOLDER}/${FILE_INFIX}.log"

MYSQL_CNF_BASE_FOLDER="/etc/mysql"
MYSQL_CNF_FILE="${MYSQL_CNF_BASE_FOLDER}/mysql.conf.d/mysqld.cnf"

# Database variables

# TODO create a user only for backups
MYSQL_USER="root"
MYSQL_PASS=""
MYSQL_REPLICATION_DELAY_THRESHOLD=60

# Commands

MYSQL_CMD="/usr/bin/mysql"
MYSQL_CMD_PREFIX="${MYSQL_CMD} --defaults-file=/root/.my.cnf -A -B -N -u ${MYSQL_USER} -h localhost"
MYSQL_SLAVE_CMD_PREFIX="${MYSQL_CMD} --defaults-file=/root/.my.cnf -A -B -u ${MYSQL_USER} -h localhost"

MYSQLDUMP_CMD="/usr/bin/mysqldump"
MYSQLDUMP_CMD_PREFIX="${MYSQLDUMP_CMD} --defaults-file=/root/.my.cnf -u ${MYSQL_USER} -h localhost"
MYSQLDUMP_CMD_MASTER_INFIX="--master-data=2"
MYSQLDUMP_CMD_SLAVE_INFIX="--dump-slave=2 --apply-slave-statements --include-master-host-port"

# Services

MYSQL_SVC="/usr/sbin/service mysql"

# Timestamp format
FILE_TIMESTAMP_FORMAT="%Y%m%d-%H%M"
LOG_TIMESTAMP_FORMAT="%Y/%m/%d %H:%M:%S %Z"
