# Exporters installer for Ubuntu servers

**This project is a bash script that aims to install exporters on Ubuntu servers, as easily as possible!**

## Node Exporter

- Default node exporter port is 9100.

- Run the following command to install node exporter on your Ubuntu server:

```bash
bash <(curl -sSL https://github.com/ongtungduong/exporters-installer/raw/main/node-exporter.sh)
```

- To use different port, for example 17017, run the following command:

```bash
EXPORTER_PORT="17017" bash <(curl -sSL https://github.com/ongtungduong/exporters-installer/raw/main/node-exporter.sh)
```

## Postgres Exporter

- Default postgres exporter port is 9187.

- Run the following command to install postgres exporter on your Ubuntu server:

```bash
bash <(curl -sSL https://github.com/ongtungduong/exporters-installer/raw/main/postgres-exporter.sh)
```

- To use different port, for example 17018, run the following command:

```bash
EXPORTER_PORT="17018" bash <(curl -sSL https://github.com/ongtungduong/exporters-installer/raw/main/postgres-exporter.sh)
```
