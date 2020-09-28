#!/bin/ksh

SQL_QRYFILE=${HOME}/sql/get_sessions.sql
OUTPUT_LOG=/tmp/sql_out.log

run_sql() {
  sqlplus <<EOF>/dev/null 2>/dev/null
/ as sysdba
whenever sqlerror exit 1
set echo off
set head off
set feed off
set pages 1000
spool ${OUTPUT_LOG}
@${SQL_QRYFILE}
spool off
exit 0
EOF

  if [ $? -eq 1 ]; then
    echo "CRITICAL: Cannot run SQL query ${SQL_QRYFILE}. Pls chk."
    return 1
  fi
}

# Main Program

# Run the SQL
run_sql

# Extract all the output rows (those that begin with colon)
# and remove the leading colon.
cat ${OUTPUT_LOG} | egrep "^:" | sed 's/^://'

# Remove temporary files.
rm -f ${OUTPUT_LOG}
