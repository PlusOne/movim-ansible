#!/bin/bash
# Usage: ./purge_db.sh <mysql_root_user> <mysql_root_password> <db_name>
MYSQL_USER="$1"
MYSQL_PASS="$2"
DB_NAME="$3"

mysql -u "$MYSQL_USER" -p"$MYSQL_PASS" <<EOF
DROP DATABASE IF EXISTS \`$DB_NAME\`;
CREATE DATABASE \`$DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
EOF
