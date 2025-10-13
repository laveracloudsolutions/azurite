# Azurite

Azure Blob Storage Emulator (for dev)

## Information Utiles

* Github: https://github.com/Azure/Azurite
* Docker Tag List: https://mcr.microsoft.com/v2/azure-storage/azurite/tags/list


## Quick Start

```bash

# Préparation de l'image
docker build -t ghcr.io/laveracloudsolutions/azurite:3.35.0 .

# Lancement
docker compose up

# Création d'un container par défaut nommé selon la variable d'environnement, s'il n'existe pas encore
AZURE_MOCK_TOKEN_DEV="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJmYWtlLXVzZXIiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdC8iLCJhdWQiOiJodHRwczovLzEyNy4wLjAuMToxMDAwIiwibmJmIjoxNzM4NzgwMDAwLCJleHAiOjE3Mzg3ODg2MDAsInJvbGUiOiJhZG1pbiJ9.f3KD0SCulLG8NSx0hNor3nK4-sWYKxMo_D0-XsNYqt4"
curl -k -I -X PUT https://127.0.0.1:10000/devstoreaccount1/container-name?restype=container -H "x-ms-version: 2017-11-09" -H "Authorization: Bearer ${AZURE_MOCK_TOKEN_DEV}"


# Push de l'image
docker push ghcr.io/laveracloudsolutions/azurite:latest
```

## Utilisation (Exemple)
```bash
# Créer un PAT Azure DevOps > https://dev.azure.com/petrolavera/_usersSettings/tokens
export AZURE_DEVOPS_EXT_PAT="xxxxxxxxxxxxxxxxxxxxxxxx"

# Lancer une commande de type "az devops"
docker run --rm -e AZURE_DEVOPS_EXT_PAT "ghcr.io/laveracloudsolutions/azure-devops-tools:latest" //bin/bash -c "az devops --help"

```


## Docker Image | GHCR.IO | Github Action
___
> [Voir Wiki](https://dev.azure.com/petrolavera/ArchitectureApplicative/_wiki/wikis/Architecture%20applicative/340/Images-Docker-(-GitHub))
___