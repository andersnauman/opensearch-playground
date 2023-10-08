FROM opensearchproject/opensearch:2.10.0
ADD --chown=opensearch https://github.com/Aiven-Open/prometheus-exporter-plugin-for-opensearch/releases/download/2.10.0.0/prometheus-exporter-2.10.0.0.zip /
RUN ./bin/opensearch-plugin install file:/prometheus-exporter-2.10.0.0.zip
