#!/bin/bash

# Fonction pour formater la date en ISO 8061
truncatedISO8061Date() {
    local date=$1
    date -u -d "$date" +"%Y-%m-%dT%H:%M:%SZ"
}

# Variables
storageAccount="devstoreaccount1"
accountKey="Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw=="

containerName="container-name"
blobName="data.txt"
start="2024-06-13T00:00:00Z"
expiry="2024-07-14T00:00:00Z"
permissions="r"  # read only
resource="b"  # blob
protocol="https"
apiVersion="2020-12-06"
blobPrefix="blob"

# Construire stringToSign
stringToSign="${permissions}\n"
stringToSign+=$(truncatedISO8061Date "$start")"\n"
stringToSign+=$(truncatedISO8061Date "$expiry")"\n"
stringToSign+="/${blobPrefix}/${storageAccount}/${containerName}/${blobName}\n"
stringToSign+="\n"  # identifier => empty
stringToSign+="\n"  # ip range => empty
stringToSign+="${protocol}\n"
stringToSign+="${apiVersion}\n"
stringToSign+="${resource}\n"
stringToSign+="\n"  # snapshot time => empty
stringToSign+="\n"  # encryption scope => empty
stringToSign+="\n"  # rscc: override Cache-Control => empty
stringToSign+="\n"  # rscd: override Content-Disposition => empty
stringToSign+="\n"  # rsce: override Content-Encoding => empty
stringToSign+="\n"  # rsci: override Content-Language => empty

#echo "stringToSign: $stringToSign"

# Calculer la signature
decodedKey=$(echo -n "$accountKey" | base64 -d)
sig=$(echo -n -e "$stringToSign" | openssl dgst -sha256 -hmac "$decodedKey" -binary | base64)

#echo "sig: $sig"

# Construire le token SAS
sasToken="sv=${apiVersion}&spr=${protocol}&st=$(truncatedISO8061Date "$start")&se=$(truncatedISO8061Date "$expiry")&sr=${resource}&sp=${permissions}&sig=$(echo -n "$sig" | jq -sRr @uri)"

# Afficher l'URI complet
echo "https://127.0.0.1:10000/${storageAccount}/${containerName}/${blobName}?${sasToken}"
