#!/bin/bash
set -e

echo "Configuring PostgreSQL for external access..."

# Backup original pg_hba.conf
cp "$PGDATA/pg_hba.conf" "$PGDATA/pg_hba.conf.backup"

# Create new pg_hba.conf with proper authentication rules
cat > "$PGDATA/pg_hba.conf" << EOF
# PostgreSQL Client Authentication Configuration File

# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     trust
local   all             postgres                                trust

# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
host    all             all             0.0.0.0/0               md5

# IPv6 local connections:
host    all             all             ::1/128                 md5
host    all             all             ::/0                    md5

# Allow replication connections from localhost
local   replication     all                                     trust
host    replication     all             127.0.0.1/32            md5
host    replication     all             ::1/128                 md5
EOF

echo "pg_hba.conf configured for external access"

# Ensure postgresql.conf allows external connections
echo "listen_addresses = '*'" >> "$PGDATA/postgresql.conf"
echo "port = 5432" >> "$PGDATA/postgresql.conf"

echo "PostgreSQL configuration completed"