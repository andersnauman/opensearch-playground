#!/bin/sh
# Root CA
openssl genrsa -out root-ca-key.pem 2048
openssl req -new -x509 -sha256 -key root-ca-key.pem -subj "/C=SE/ST=STOCKHOLM/L=STOCKHOLM/O=ORG/OU=UNIT/CN=root-ca" -out root-ca.pem -days 730
# Admin cert
openssl genrsa -out admin-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in admin-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out admin-key.pem
openssl req -new -key admin-key.pem -subj "/C=SE/ST=STOCKHOLM/L=STOCKHOLM/O=ORG/OU=UNIT/CN=Admin" -out admin.csr
openssl x509 -req -in admin.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out admin.pem -days 730
# Node cert 1
openssl genrsa -out node1-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in node1-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out node1-key.pem
openssl req -new -key node1-key.pem -subj "/C=SE/ST=STOCKHOLM/L=STOCKHOLM/O=ORG/OU=UNIT/CN=opensearch-node-1" -out node1.csr
echo 'subjectAltName=DNS:opensearch-node-1' > node1.ext
openssl x509 -req -in node1.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out node1.pem -days 730 -extfile node1.ext
# Dashboard cert 1 (Web/HTTPS)
openssl genrsa -out client-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in client-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out client-key.pem
openssl req -new -key client-key.pem -subj "/C=SE/ST=STOCKHOLM/L=STOCKHOLM/O=ORG/OU=UNIT/CN=opensearch-dashboard-1" -out client.csr
echo 'subjectAltName=DNS:opensearch-dashboard-1' > client.ext
openssl x509 -req -in client.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out client.pem -days 730 -extfile client.ext
# Keycloak (Web/HTTPS)
openssl genrsa -out keycloak-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in keycloak-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out keycloak-key.pem
openssl req -new -key keycloak-key.pem -subj "/C=SE/ST=STOCKHOLM/L=STOCKHOLM/O=ORG/OU=UNIT/CN=opensearch-keycloak" -out keycloak.csr
echo 'subjectAltName=DNS:opensearch-keycloak' > keycloak.ext
openssl x509 -req -in keycloak.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out keycloak.pem -days 730 -extfile keycloak.ext
# Prometheus (Web/HTTPS)
openssl genrsa -out prometheus-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in prometheus-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out prometheus-key.pem
openssl req -new -key prometheus-key.pem -subj "/C=SE/ST=STOCKHOLM/L=STOCKHOLM/O=ORG/OU=UNIT/CN=opensearch-prometheus" -out prometheus.csr
echo 'subjectAltName=DNS:opensearch-prometheus' > prometheus.ext
openssl x509 -req -in prometheus.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out prometheus.pem -days 730 -extfile prometheus.ext

# Cleanup
rm admin-key-temp.pem
rm admin.csr
rm node1-key-temp.pem
rm node1.csr
rm node1.ext
rm client-key-temp.pem
rm client.csr
rm client.ext
rm keycloak-key-temp.pem
rm keycloak.csr
rm keycloak.ext
rm prometheus-key-temp.pem
rm prometheus.csr
rm prometheus.ext

chown 1000:1000 *.pem
chown 65534:65534 prometheus*

chmod 0600 *.pem
chmod 0644 root-ca.pem

