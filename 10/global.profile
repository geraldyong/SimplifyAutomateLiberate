# Scripts Repository Profile File
#
# Last Updated:
# 23 Oct 2010 - geraldy - Created profile script.

# General
HOSTNAME=`hostname`
USERID=`id | cut -f2 -d'(' | cut -f1 -d')'`
OSTYPE=`uname -s`

# Paths
SCRIPT_BASE_PATH=/opt/repository/scripts
SCRIPT_CFG_PATH=${SCRIPT_BASE_PATH}/cfg
SCRIPT_BIN_PATH=${SCRIPT_BASE_PATH}/bin
SCRIPT_DIST_PATH=${SCRIPT_BASE_PATH}/dist
SCRIPT_JOB_PATH=${SCRIPT_BASE_PATH}/job
SCRIPT_LOG_PATH=${SCRIPT_BASE_PATH}/log
SCRIPT_OUT_PATH=${SCRIPT_BASE_PATH}/out
SCRIPT_TMP_PATH=${SCRIPT_BASE_PATH}/tmp

# Notification
ADMIN_EMAIL=sysadmin@mycompany.com

# Exports
export HOSTNAME USER_HOME USERID OSTYPE
export SCRIPT_BASE_PATH
export SCRIPT_CFG_PATH
export SCRIPT_BIN_PATH
export SCRIPT_DIST_PATH
export SCRIPT_JOB_PATH
export SCRIPT_LOG_PATH
export SCRIPT_OUT_PATH
export SCRIPT_TMP_PATH
export ADMIN_EMAIL
