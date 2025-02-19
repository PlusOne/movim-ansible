#!/bin/bash
# Verify that the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Set Movim directory and .env path
MOVIM_DIR="/var/www/movim"
ENV_FILE="${MOVIM_DIR}/.env"

# Check if the Movim directory exists
if [ ! -d "$MOVIM_DIR" ]; then
    echo "Movim directory $MOVIM_DIR does not exist. Please install Movim first."
    exit 1
fi

# Verify that PostgreSQL service is running
if ! systemctl is-active --quiet postgresql; then
    echo "PostgreSQL service is not running. Please start it before proceeding."
    exit 1
fi

# Check for .env file and load DB settings
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
else
    echo ".env file not found in $MOVIM_DIR. Please configure it before proceeding."
    exit 1
fi

# Verify required environment variables are set
if [ -z "$DB_DRIVER" ] || [ -z "$DB_HOST" ] || [ -z "$DB_DATABASE" ] || [ -z "$DB_USERNAME" ] || [ -z "$DB_PASSWORD" ]; then
    echo "One or more required DB environment variables (DB_DRIVER, DB_HOST, DB_DATABASE, DB_USERNAME, DB_PASSWORD) are not set in .env."
    exit 1
fi

# Change to Movim directory and run migrations
cd "$MOVIM_DIR" || exit 1
echo "Running Movim database migrations..."
/usr/bin/env COMPOSER_ALLOW_SUPERUSER=1 composer movim:migrate
RESULT=$?

if [ $RESULT -ne 0 ]; then
    echo "Database migrations failed with error code $RESULT."
    exit 1
fi

echo "Movim installation and PostgreSQL setup verified successfully."
