
FROM quay.io/keycloak/keycloak:latest as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure a database vendor
ENV KC_DB=postgres
ENV KC_DB_URL_PROPERTIES=?sslmode=verify-full

# Download azure root cert
# https://github.com/keycloak/keycloak/issues/17606
RUN curl https://dl.cacerts.digicert.com/DigiCertGlobalRootCA.crt.pem -o /opt/keycloak/.postgresql/root.crt

WORKDIR /opt/keycloak

RUN /opt/keycloak/bin/kc.sh build

# Enabling SHA1 algorithm in SSL validation to fix flawed Azure Postgres Cert
# https://github.com/keycloak/keycloak/issues/17320
USER root
RUN ["sed", "-i", "s/SHA1, //g", "/usr/share/crypto-policies/DEFAULT/java.txt"]



FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/

EXPOSE 8080

# ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start", "--optimized", "--hostname-strict", "false", "--http-enabled", "true"]

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start", "--optimized"]

# CMD ["start-dev"]
