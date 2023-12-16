# !/bin/bash

# Get the latest exporter version
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/prometheus/node_exporter/releases/latest")
LATEST_VERSION=$(echo "$LATEST_RELEASE" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')

# Set the exporter port
EXPORTER_VERSION=${EXPORTER_VERSION:-$LATEST_VERSION}
EXPORTER_PORT=${EXPORTER_PORT:-9100}

# Download node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v$EXPORTER_VERSION/node_exporter-$EXPORTER_VERSION.linux-amd64.tar.gz
tar xzf node_exporter-$EXPORTER_VERSION.linux-amd64.tar.gz
sudo mv node_exporter-$EXPORTER_VERSION.linux-amd64/node_exporter /usr/local/bin
rm -rf node_exporter-$EXPORTER_VERSION.linux-amd64.tar.gz node_exporter-$EXPORTER_VERSION.linux-amd64

USER=node_exporter
GROUP=node_exporter

# Create node_exporter systemd service
cat > /etc/systemd/system/node_exporter.service << EOF
[Unit]
Description=node_exporter
After=network.target

[Service]
User=$USER
Group=$GROUP
Type=simple
ExecStart=/usr/local/bin/node_exporter --web.listen-address=:$EXPORTER_PORT

[Install]
WantedBy=multi-user.target
EOF
echo "node_exporter.service created"

# Create node_exporter user and group
sudo useradd --no-create-home --shell /bin/false $USER
sudo groupadd $GROUP

# Reload systemd daemon and start node_exporter
sudo systemctl daemon-reload
sudo systemctl enable node_exporter --now
sudo systemctl status node_exporter --no-pager