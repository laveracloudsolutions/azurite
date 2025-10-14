# Azurite

Azure Blob Storage Emulator (for dev)

[Azurite](https://github.com/Azure/Azurite) permet de simuler des interactions avec le service Azure Blob Storage.

À partir de ce projet, Azurite :

* est démarré via "docker compose" ou via "devcontainer", 
* fournit ses services via Https, avec un certificat auto-généré, et une authentification avec des jetons JWT. 
* les APIs Azurite sont disponibles depuis le devcontainer sur `https://127.0.0.1:10000`. 
* un compte de stockage `devstoreaccount1` ainsi qu'un container de stockage `container-name` sont créés au démarrage.

## Information Utiles

### Liens Utiles

* Github: https://github.com/Azure/Azurite
* Docker Tag List: https://mcr.microsoft.com/v2/azure-storage/azurite/tags/list

### Récupération d'un jeton depuis une container apps

La récupération d'un jeton pour appeler les services Rest Azure Blob Storage sera à réaliser à travers le endpoint Identity disponible dans les [container apps](https://learn.microsoft.com/en-us/azure/container-apps/managed-identity?tabs=portal%2Chttp) grâce à l'identité managée associée au container.

Ce service est disponible sur le endpoint défini par la variable d'environnement `IDENTITY_ENDPOINT`, en positionnant le header `x-identity-header` avec la valeur de la variable d'environnement `IDENTITY_HEADER` et le `clientId` correspondant à l'identité managée.

Exemple de récupération d'un token:
```bash
curl -H "x-identity-header: ${IDENTITY_HEADER}" "${IDENTITY_ENDPOINT}?resource=https://storage.azure.com&api-version=2019-08-01&client_id=${MANAGED_IDENTITY_CLIENT_ID}"
```

### Génération d'un jeton en local
La création d'un jeton pour appeler Azurite en local peut être effectué par exemple sur jwt.io.

Les éléments suivants sont obligatoires dans le payload: `aud`, `iss`, `iat`, `nbf`, `exp`.
```json
{
  "aud": "https://storage.azure.com",
  "iss": "https://sts.windows.net/",
  "iat": 1511859603,
  "nbf": 1511859603,
  "exp": 1719963503
}
```

### APIs Azure Blob Storage

```bash
# Positionnement du jeton
AZURE_MOCK_TOKEN_DEV='eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9.eyJhdWQiOiJodHRwczovL3N0b3JhZ2UuYXp1cmUuY29tIiwiaXNzIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvIiwiaWF0IjoxNTExODU5NjAzLCJuYmYiOjE1MTE4NTk2MDMsImV4cCI6MTgyOTk2MzUwM30.KAH5-f_iAipjFk91AiUmi2tFY4AQa5CJbXU-MTgw7h_GIBLUG43b61zud0TrI7OCrAPkj06AeBHbwVT2LIFmp3ijNbR9iYX_hf76gy1R2tQA9iHnQ73ookRhPreAnLa84tr5QXi1FRBqhc4Tmio64aEAY8otUzIR8kkmwSLCWX9hcpaxAjnAr000Cvgiskz1Wva_CHeDQzDCoi1NL-20ILAc0mW-ZqUOuoS3e8NOBHVEiu8FA6YU6o0mD0Av94ixbz9RVMhzO_k_Pc-4eboOMs9KGG2VTAJT6IZ_TykrbmkI-d2Uv0TbBKIp9AdSMMKb0ucq-uaT4DUUFFVbbj3GoQ'

# Ecriture d'un fichier test.txt à partir d'un fichier local data.txt
curl -k -X PUT -H "x-ms-version: 2017-11-09" -H "x-ms-blob-content-type: text/plain" -H "Authorization: Bearer ${AZURE_MOCK_TOKEN_DEV}" -T ./data.txt -H "x-ms-blob-type: BlockBlob"  'https://127.0.0.1:10000/devstoreaccount1/container-name/test.txt'

# Récupération du fichier test.txt
curl -k https://127.0.0.1:10000/devstoreaccount1/container-name/test.txt -O -H "x-ms-version: 2017-11-09" -H "Authorization: Bearer ${AZURE_MOCK_TOKEN_DEV}"
````

### Liens temporaires

Les fichiers mis à disposition des utilisateurs finaux doivent être accessibles uniquemnet à partir de liens temporaires. Le script "[generateSasToken.sh](.scripts/generateSasToken.sh)" indique la procédure à suivre pour générer ce type de lien sur un fichier.

Il s'appuie par une clé de compte qui sera disponible à travers la variable d'environnemnet `STORAGE_ACCOUNT_KEY` depuis les container apps. Avec Azurite, en local, cette clé vaut : `Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==`


## Build & Test, en local, via Docker Compose

Cette étape permet de préparer et valide le bon fonctionnement de l'image finale à partir du Dockerfile présent à la racine du projet

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

## Build & Push (manuel)

Cette étape permet de préparer et de pusher dans Github l'image du service cible

```bash

# Tag avec version
docker build -t ghcr.io/laveracloudsolutions/azurite:3.35.0 .
docker push ghcr.io/laveracloudsolutions/azurite:3.35.0

# Tag latest
docker build -t ghcr.io/laveracloudsolutions/azurite:latest .
docker push ghcr.io/laveracloudsolutions/azurite:latest
```

## DevContainer

La partie [.devcontainer](.devcontainer) permet de lancer, via devcontainer, l'image finale (préparé au préalable) et donne un exemple sur la manière dont on peut l'intégrer dans un projet.

## Docker Image | GHCR.IO | Github Action
___
> [Voir Wiki](https://dev.azure.com/petrolavera/ArchitectureApplicative/_wiki/wikis/Architecture%20applicative/340/Images-Docker-(-GitHub))
___