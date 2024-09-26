#!/bin/bash

LATEST_RELEASE=$(curl -s "https://api.github.com/repos/prometheus-community/postgres_exporter/releases/latest")
LATEST_VERSION=$(echo "$LATEST_RELEASE" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
EXPORTER_VERSION=${EXPORTER_VERSION:-$LATEST_VERSION}
EXPORTER_PORT=${EXPORTER_PORT:-9187}
EXPORTER_PASSWORD=$(openssl rand -base64 32 | tr -d 'iI1lLoO0' | tr -d -c '[:alnum:]' | cut -c1-32)
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}

echo "Downloading Postgres Exporter v${EXPORTER_VERSION}..."
curl -LO "https://github.com/prometheus-community/postgres_exporter/releases/download/v${EXPORTER_VERSION}/postgres_exporter-${EXPORTER_VERSION}.linux-amd64.tar.gz"
tar -xzf postgres_exporter-${EXPORTER_VERSION}.linux-amd64.tar.gz
sudo mv postgres_exporter-${EXPORTER_VERSION}.linux-amd64/postgres_exporter /usr/local/bin/
rm postgres_exporter-${EXPORTER_VERSION}.linux-amd64.tar.gz
rm -rf postgres_exporter-${EXPORTER_VERSION}.linux-amd64

echo "Creating postgres_exporter user and directory..."
sudo useradd --no-create-home --shell /bin/false postgres_exporter
sudo mkdir -p /etc/postgres_exporter
sudo chown -R postgres_exporter:postgres_exporter /etc/postgres_exporter

echo "Creating postgres_exporter systemd service..."
sudo tee /etc/systemd/system/postgres_exporter.service > /dev/null << EOF
[Unit]
Description=Prometheus Postgres Exporter
After=network.target

[Service]
User=postgres_exporter
Group=postgres_exporter
EnvironmentFile=/etc/postgres_exporter/postgres_exporter.env
ExecStart=/usr/local/bin/postgres_exporter --collector.stat_statements --web.listen-address=:$EXPORTER_PORT

[Install]
WantedBy=multi-user.target
EOF

sudo tee /etc/postgres_exporter/postgres_exporter.env > /dev/null << EOF
DATA_SOURCE_URI=$DB_HOST:$DB_PORT/postgres?sslmode=disable
DATA_SOURCE_USER=postgres_exporter
DATA_SOURCE_PASS=$EXPORTER_PASSWORD
PG_EXPORTER_AUTO_DISCOVER_DATABASES=true
EOF

echo "Enabling and starting postgres_exporter service..."
sudo systemctl daemon-reload
sudo systemctl enable postgres_exporter.service --now

echo "Postgres Exporter installed successfully!!!"
echo ""
echo "Run the following queries to create and grant access to the postgres exporter user:"
echo ""
echo "CREATE USER postgres_exporter WITH PASSWORD '$EXPORTER_PASSWORD';"
echo "GRANT pg_monitor to postgres_exporter;"
echo "CREATE EXTENSION IF NOT EXISTS pg_stat_statements;"
echo ""
echo "You can now access the metrics at http://localhost:$EXPORTER_PORT/metrics"
