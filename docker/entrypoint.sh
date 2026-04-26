#!/bin/sh
set -e

# ===== Docker Entrypoint for Eduvance =====
# Fixes the issue where .env (gitignored) has local dev values
# that override Docker environment variables in Laravel.

WORKDIR="/var/www/html"

echo "[entrypoint] Checking .env configuration..."

# If .env.docker exists, always use it as the base for Docker deployment
if [ -f "$WORKDIR/.env.docker" ]; then
    cp "$WORKDIR/.env.docker" "$WORKDIR/.env"
    echo "[entrypoint] ✓ Copied .env.docker → .env"
fi

# If .env still doesn't exist, fall back to .env.example
if [ ! -f "$WORKDIR/.env" ] && [ -f "$WORKDIR/.env.example" ]; then
    cp "$WORKDIR/.env.example" "$WORKDIR/.env"
    echo "[entrypoint] ✓ Copied .env.example → .env"
fi

# Generate APP_KEY if missing
if grep -q "APP_KEY=$" "$WORKDIR/.env" 2>/dev/null || grep -q "APP_KEY=\s*$" "$WORKDIR/.env" 2>/dev/null; then
    echo "[entrypoint] Generating APP_KEY..."
    php "$WORKDIR/artisan" key:generate --force
    echo "[entrypoint] ✓ APP_KEY generated"
fi

# Create required directories
mkdir -p "$WORKDIR/public/public/Image"
mkdir -p "$WORKDIR/public/public/vedios"
mkdir -p "$WORKDIR/public/public/documents"
mkdir -p "$WORKDIR/storage/framework/sessions"
mkdir -p "$WORKDIR/storage/framework/views"
mkdir -p "$WORKDIR/storage/framework/cache/data"
mkdir -p "$WORKDIR/storage/logs"
mkdir -p "$WORKDIR/bootstrap/cache"

# Set permissions
chown -R www-data:www-data "$WORKDIR/storage" "$WORKDIR/bootstrap/cache" 2>/dev/null || true
chmod -R 755 "$WORKDIR/storage" "$WORKDIR/bootstrap/cache" 2>/dev/null || true

# Wait for MySQL to be ready
echo "[entrypoint] Waiting for MySQL..."
MAX_RETRIES=30
RETRY=0
until php -r "new PDO('mysql:host='.'$DB_HOST'.';port='.'$DB_PORT'.';dbname='.'$DB_DATABASE', '$DB_USERNAME', '$DB_PASSWORD');" 2>/dev/null || [ $RETRY -eq $MAX_RETRIES ]; do
    RETRY=$((RETRY+1))
    echo "[entrypoint]   MySQL not ready, retry $RETRY/$MAX_RETRIES..."
    sleep 2
done

if [ $RETRY -eq $MAX_RETRIES ]; then
    echo "[entrypoint] ⚠ MySQL connection failed after $MAX_RETRIES retries"
else
    echo "[entrypoint] ✓ MySQL is ready"

    # Run migrations if migrations table doesn't exist
    if ! php "$WORKDIR/artisan" migrate:status > /dev/null 2>&1; then
        echo "[entrypoint] Running migrations..."
        php "$WORKDIR/artisan" migrate --force
        echo "[entrypoint] ✓ Migrations complete"

        echo "[entrypoint] Running seeders..."
        php "$WORKDIR/artisan" db:seed --force
        echo "[entrypoint] ✓ Seeders complete"
    fi
fi

echo "[entrypoint] Starting PHP-FPM..."
exec "$@"
