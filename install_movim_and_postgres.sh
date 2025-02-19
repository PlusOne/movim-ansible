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

# Verify that PostgreSQL service is running, attempt to start if not
if ! systemctl is-active --quiet postgresql; then
    echo "PostgreSQL service is not running. Attempting to start it..."
    systemctl start postgresql
    if ! systemctl is-active --quiet postgresql; then
         echo "Failed to start PostgreSQL service. Please start it manually."
         exit 1
    fi
fi

# Check for .env file and generate it if missing
if [ ! -f "$ENV_FILE" ]; then
    echo ".env file not found in $MOVIM_DIR. Generating .env file from template..."
    # Set default values; these can be overridden by exporting before running the script
    export DB_DRIVER=${DB_DRIVER:-pgsql}
    export DB_HOST=${DB_HOST:-localhost}
    export DB_DATABASE=${DB_DATABASE:-movim_db}
    export DB_USERNAME=${DB_USERNAME:-movim}
    export DB_PASSWORD=${DB_PASSWORD:-your_postgres_password}
    envsubst < /home/renz/source/movim-ansible/templates/env_movim_psql.j2 > "$ENV_FILE"
    echo ".env generated as:"
    cat "$ENV_FILE"
fi

# Load DB settings from .env
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
else
    echo "Failed to generate .env file in $MOVIM_DIR."
    exit 1
fi

# Debug: Show loaded DB environment variables
echo "Loaded DB variables:"
echo "DB_DRIVER=${DB_DRIVER}"
echo "DB_HOST=${DB_HOST}"
echo "DB_DATABASE=${DB_DATABASE}"
echo "DB_USERNAME=${DB_USERNAME}"
echo "DB_PASSWORD=${DB_PASSWORD}"

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
