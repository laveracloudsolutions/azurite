FROM mcr.microsoft.com/azure-storage/azurite:3.35.0

# Passer en root pour installer les dépendances
USER root

# Installer openssl sur Alpine
RUN apk add --no-cache openssl

# Créer un répertoire de travail
WORKDIR /workspace

# Générer un certificat auto-signé
RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout key.pem \
    -out cert.pem \
    -subj "/C=FR/ST=France/L=Paris/O=LocalDev/CN=azurite"

# Exposer le port HTTPS pour le Blob service
EXPOSE 10000

# Commande de démarrage : Azurite avec OAuth Basic et HTTPS
ENTRYPOINT ["azurite", "--oauth", "basic", "--cert", "/workspace/cert.pem", "--key", "/workspace/key.pem", "--blobHost", "0.0.0.0", "--blobPort", "10000", "--debug", "/dev/stdout"]