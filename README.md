# Azurite

Azure Blob Storage Emulator (for dev)

## Information Utiles

* Github: https://github.com/Azure/Azurite
* Docker Tag List: https://mcr.microsoft.com/v2/azure-storage/azurite/tags/list


## Test du service en local

```bash
# Lancement du services
docker compose up

# Token de base
export  AZURE_MOCK_TOKEN_DEV='eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9.eyJhdWQiOiJodHRwczovL3N0b3JhZ2UuYXp1cmUuY29tIiwiaXNzIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvIiwiaWF0IjoxNTExODU5NjAzLCJuYmYiOjE1MTE4NTk2MDMsImV4cCI6MTgyOTk2MzUwM30.KAH5-f_iAipjFk91AiUmi2tFY4AQa5CJbXU-MTgw7h_GIBLUG43b61zud0TrI7OCrAPkj06AeBHbwVT2LIFmp3ijNbR9iYX_hf76gy1R2tQA9iHnQ73ookRhPreAnLa84tr5QXi1FRBqhc4Tmio64aEAY8otUzIR8kkmwSLCWX9hcpaxAjnAr000Cvgiskz1Wva_CHeDQzDCoi1NL-20ILAc0mW-ZqUOuoS3e8NOBHVEiu8FA6YU6o0mD0Av94ixbz9RVMhzO_k_Pc-4eboOMs9KGG2VTAJT6IZ_TykrbmkI-d2Uv0TbBKIp9AdSMMKb0ucq-uaT4DUUFFVbbj3GoQ'

# Vérification du Token
echo "AZURE_MOCK_TOKEN_DEV=${AZURE_MOCK_TOKEN_DEV}"

# List Blob Storage
curl -k -v -X GET  -H "x-ms-version: 2021-12-02" -H "Authorization: Bearer ${AZURE_MOCK_TOKEN_DEV}" https://127.0.0.1:10000/devstoreaccount1?comp=list

# Create Blob Storage
curl -k -I -X PUT https://127.0.0.1:10000/devstoreaccount1/container-name?restype=container -H "x-ms-version: 2021-12-02" -H "Authorization: Bearer ${AZURE_MOCK_TOKEN_DEV}"
```

## Préparation de l'image

```bash

# Tag avec version
docker build -t ghcr.io/laveracloudsolutions/azurite:3.35.0 .
docker push ghcr.io/laveracloudsolutions/azurite:3.35.0

# Tag latest
docker build -t ghcr.io/laveracloudsolutions/azurite:latest .
docker push ghcr.io/laveracloudsolutions/azurite:latest
```


## Docker Image | GHCR.IO | Github Action
___
> [Voir Wiki](https://dev.azure.com/petrolavera/ArchitectureApplicative/_wiki/wikis/Architecture%20applicative/340/Images-Docker-(-GitHub))
___