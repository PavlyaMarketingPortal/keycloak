# Use the official Keycloak image as the base
FROM quay.io/keycloak/keycloak:latest

# Set the working directory
# WORKDIR /opt/keycloak

# Copy custom themes into the Keycloak themes directory
# Assuming you have a 'themes' directory in your repository
# COPY themes /opt/keycloak/themes

# Expose the default Keycloak port
EXPOSE 8080

# Start Keycloak in production mode
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start"]