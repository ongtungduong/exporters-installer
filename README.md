# Node exporter installer for Ubuntu servers

**This project is a bash script that aims to install node exporter on Ubuntu servers, as easily as possible!**

- Default node exporter port is 9100.

## Usage

Run the following command to install the latest version of node exporter on your Ubuntu server:

```bash
curl https://raw.githubusercontent.com/ongtungduong/node-exporter-installer/main/install-node-exporter.sh | bash
```

Run the following command to install the latest version of node exporter with custom port on your Ubuntu server.

Replace <PORT> with your custom port before running the command.

```bash
curl https://raw.githubusercontent.com/ongtungduong/node-exporter-installer/main/install-node-exporter.sh | EXPORTER_PORT=<PORT> bash
```

Run the following command to install specific version of node exporter on your Ubuntu server.

Replace <VERSION> with your custom version before running the command.

```bash
curl https://raw.githubusercontent.com/ongtungduong/node-exporter-installer/main/install-node-exporter.sh | EXPORTER_VERSION=<VERSION> bash
```
