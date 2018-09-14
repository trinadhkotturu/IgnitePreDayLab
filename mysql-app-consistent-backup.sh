#!/bin/bash
# 
# (C) 2016, CAPSiDE SL. All rights reserved.
# Total or partial distribution, copy or reproduction in any form, or usage
# without written authorization from CAPSiDE is prohibited and will be
# prosecuted.
# 
# Main script for PRE/POST actions for MySQL consistent Azure Linux VMs backups

# Default PATH
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/capside/azure"

# Only root can execute this script
USER_ID="$(id -u)"
if [[ ${USER_ID} -ne 0 ]]; then
    echo  "Only root can execute this script."
    exit 1
fi

# Load the custom variables and helper functions
for source_file in /opt/capside/azure/mysql-app-consistent-backup-env.sh /opt/capside/azure/mysql-app-consistent-backup-funcs.sh; do

    if [[ -r ${source_file} ]]; then
        source ${source_file}
        if [[ $? -ne 0 ]]; then
            echo "${source_file} could not be loaded."
            exit 1
        fi
    else
        echo "${source_file} not found."
        exit 1
    fi

done

# Folder structure
mkdir -p ${DUMPS_FOLDER} ${LOGS_FOLDER}
touch ${LOG_FILE}
chown -R root:root ${DUMPS_FOLDER} ${LOGS_FOLDER}
chmod -R 700 ${BASE_FOLDER}/*.sh ${DUMPS_FOLDER} ${LOGS_FOLDER}

# From now on the required environment is set up

# Get the server role
server_id="$(egrep "^\s*server-id\s*=\s*[0-9]*\s*$" ${MYSQL_CNF_FILE} | sed -e 's/^.*=\s*\([0-9]*\).*$/\1/')"
role=""

role="master"

#if [[ "${server_id}" -eq 1 ]]; then #MASTER
#    role="master"
#elif [[ "${server_id}" -gt 1 ]]; then #SLAVE
#    role="slave"
#else
#    log_crit "Invalid role."
#fi

# Get the requested action
if [[ $# -lt 1 ]]; then
    log_crit "No action provided."
else
    case $1 in
        pre|Pre|PRE)
            action="PRE"
            log_info "Starting ${action} actions for role ${role}"

            if [[ $(mysql_svc_status) -ne 0 ]]; then
                mysql_svc_start
            fi

            case ${role} in
                master)
                    mysql_set_readonly
                    mysqldump_dump_all_dbs_and_tables
                ;;
                slave)
                    mysql_slave_stop
                    mysql_set_readonly
                    mysqldump_dump_all_dbs_and_tables
                    mysql_svc_stop
                ;;
            esac

        ;;
        post|Post|POST)
            action="POST"
            log_info "Starting ${action} actions for role ${role}"

            if [[ $(mysql_svc_status) -ne 0 ]]; then
                mysql_svc_start
            fi

            case ${role} in
                master)
                        mysql_unset_readonly
			rm -rf ${DUMPS_FOLDER}/*
                ;;
                slave)
                    if [[ $(mysql_svc_status) -ne 0 ]]; then
                        mysql_svc_start
                    fi
                    mysql_unset_readonly
                    mysql_slave_start
                ;;
            esac

        ;;
        *)
            log_crit "Invalid action provided."
        ;;
    esac
fi

log_info "${action} for role ${role} finished"
