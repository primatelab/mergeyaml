# mergeyaml
Merge two YAML files, producing a new, syntactically valid YAML file. 

Written in bash. Just bash. No python, no extra packages. Nothing but bash.

I know, right?

**Usage:** `mergeyaml.sh file1.yml file2.yml`

**Note**: This script doesn't detect duplicate keys. If two keys have the same value, it keeps one copy, but if they have different values it prints both. It also doesn't handle multi-line values. Yet.

### Examples
`file1.yml`:
```
---
cachemanager:
  host: 127.0.0.1
  max_cache_size: 1GB
  max_item_size: 0
process_recycle_time: 86400
server:
  bind_address: 0.0.0.0
  max_active_connections: 15
  max_queued_connections: 30
  tls:
    cipher_suite: ECDH+AESGCM:ECDH+AES256:ECDH+AES128:!aNULL:!MD5:!DSS
    context_options:
    - NO_SSLv3
    - NO_TLSv1
    - NO_TLSv1_1
  tls_enabled: true
  tls_handshake_timeout: 3
```
`file2.yml`
```
---
server:
  tls:
    cert_file: /etc/app/ssl/app.pem
    key_file: /etc/app/ssl/app.key
    ca_cert: /etc/app/ssl/ca.pem
    check_client_cert: true
  tls_enabled: true
```
Result of `mergeyaml.sh file1.yml file2.yml`:
```
---
cachemanager:
  host: 127.0.0.1
  max_cache_size: 1GB
  max_item_size: 0
process_recycle_time: 86400
server:
  bind_address: 0.0.0.0
  max_active_connections: 15
  max_queued_connections: 30
  tls:
    ca_cert: /etc/app/ssl/ca.pem
    cert_file: /etc/app/ssl/app.pem
    check_client_cert: true
    cipher_suite: ECDH+AESGCM:ECDH+AES256:ECDH+AES128:!aNULL:!MD5:!DSS
    context_options:
    - NO_SSLv3
    - NO_TLSv1
    - NO_TLSv1_1
    key_file: /etc/app/ssl/app.key
  tls_enabled: true
  tls_handshake_timeout: 3
```
