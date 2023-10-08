## Introduction
Development / playground for opensearch + dashboard + keycloak + prometheus + grafana.

## Accounts
- Opensearch
  - admin/admin
- Opensearch Dashboards
  - admin/admin
  - openid (keycloak)
- Keycloak
  - admin/admin
- Grafana
  - admin/grafana
- Prometheus
  - None

## Run
```
chown 1000:1000 opensearch/security/*.yml
chmod 0600 opensearch/security/*.yml
cd certs
chmod +x generate.sh
cd ..
docker-compose up -d

docker exec -it opensearch-node-1 /bin/bash
/usr/share/opensearch/plugins/opensearch-security/tools/securityadmin.sh -cd /usr/share/opensearch/config/opensearch-security -icl -nhnv -cacert /usr/share/opensearch/config/root-ca.pem -cert /usr/share/opensearch/config/admin.pem -key /usr/share/opensearch/config/admin-key.pem
```

## Bugs
### Roles from keycloak
Keycloak (22.0.4) will nest roles by default under resource_access or realm_access.
Create a new mapping (opensearch_roles) for client roles so opensearch/security/config can read the values via "roles_key: opensearch_roles"
```
https://forum.opensearch.org/t/access-nested-fields-in-jwt-token-for-subject-key-roles-key/811/2
```