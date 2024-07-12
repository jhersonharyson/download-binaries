#!/bin/bash

# Verifica se o nome do projeto foi passado como parâmetro
if [ -z "$1" ]; then
  echo "Use: $0 <host>"
  exit 1
fi

# Parâmetro do script
downloadUrl=$1

# Obtém o hash do commit atual do Git
commitHash=$(git rev-parse HEAD)
if [ -z "$commitHash" ]; then
  echo "Error: Cannot get current commit hash."
  exit 1
fi


# Nome do arquivo para salvar o download
downloadFile="${commitHash}.zip"

# Diretório onde descompactar os arquivos
outputDir="binaries"

# Faz o download do arquivo usando curl
curl --location "$downloadUrl" --output $downloadFile

# # Verifica o status do download
# if [ "$response" -eq 200 ]; then
#   echo "Successful Download"
# else
#   echo "Download Error. Status HTTP: $response"
#   exit 1
# fi

# Cria o diretório de saída se não existir
mkdir -p "$outputDir"

# Descompacta o arquivo no diretório de saída
unzip -o "$downloadFile" -d "$outputDir"

# Verifica se a descompactação foi bem-sucedida
if [ $? -eq 0 ]; then
  echo "File unziped with success in directory: $outputDir."
else
  echo "Error when try to unzip file."
  exit 1
fi

# Remove o arquivo zip após a descompactação
rm -f "$downloadFile"
