#!/bin/sh
# ===== Docker Entrypoint for Eduvance =====
# Copies .env.docker → .env, waits for MySQL, runs migrations, then starts PHP-FPM.

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

# Source the .env file so we have DB_HOST etc. as shell variables
# (these also come from env_file in docker-compose, but source for safety)
if [ -f "$WORKDIR/.env" ]; then
    # Export only DB_ and REDIS_ vars from .env
    while IFS='=' read -r key value; do
        case "$key" in
            DB_*|REDIS_*|APP_*) export "$key=$value" ;;
        esac
    done < "$WORKDIR/.env"
fi

# Generate APP_KEY if missing
if [ -f "$WORKDIR/.env" ] && grep -q "^APP_KEY=$" "$WORKDIR/.env" 2>/dev/null; then
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
echo "[entrypoint] Waiting for MySQL at ${DB_HOST}:${DB_PORT}..."
MAX_RETRIES=30
RETRY=0
while [ $RETRY -lt $MAX_RETRIES ]; do
    if php -r "
        try {
            new PDO('mysql:host=\${DB_HOST};port=\${DB_PORT};dbname=\${DB_DATABASE}', '\${DB_USERNAME}', '\${DB_PASSWORD}');
            exit(0);
        } catch (Exception \$e) {
            exit(1);
        }
    " 2>/dev/null; then
        echo "[entrypoint] ✓ MySQL is ready"
        break
    fi
    RETRY=$((RETRY+1))
    echo "[entrypoint]   MySQL not ready, retry $RETRY/$MAX_RETRIES..."
    sleep 2
done

if [ $RETRY -eq $MAX_RETRIES ]; then
    echo "[entrypoint] ⚠ MySQL connection failed after $MAX_RETRIES retries, starting anyway..."
else
    # Run migrations
    echo "[entrypoint] Running migrations..."
    php "$WORKDIR/artisan" migrate --force 2>&1 || echo "[entrypoint] ⚠ Migration had errors (may already be migrated)"

    # Run seeders
    echo "[entrypoint] Running seeders..."
    php "$WORKDIR/artisan" db:seed --force 2>&1 || echo "[entrypoint] ⚠ Seeder had errors (may already be seeded)"

    # Create storage link
    php "$WORKDIR/artisan" storage:link 2>/dev/null || true
fi

echo "[entrypoint] Starting PHP-FPM..."
exec "$@"
