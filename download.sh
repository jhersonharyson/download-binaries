#!/bin/bash

# Verifica se o URL de download e o nome do projeto foram passados como parâmetros
if [ $# -ne 2 ]; then
  echo "Use: $0 <url> <project-name>"
  exit 1
fi

# Parâmetros do script
downloadUrl=$1
projectName=$2

# Obtém o hash do commit atual do Git
commitHash=$(git rev-parse HEAD)
if [ -z "$commitHash" ]; then
  echo "Error: Cannot get current commit hash."
  exit 1
fi

# Nome do arquivo para salvar o download
downloadFile="binaries.zip"

# Diretório onde descompactar os arquivos
outputDir="binaries"

# Faz o download do arquivo usando curl
curl --location "$downloadUrl" --output $downloadFile

# Verifica o status do download
if [ $? -eq 0 ]; then
  echo "Successful Download"
else
  echo "Download Error."
  exit 1
fi

# Cria o diretório de saída se não existir
mkdir -p "$outputDir"

# Descompacta o arquivo no diretório de saída
unzip -o "$downloadFile" -d "$outputDir"

# Verifica se a descompactação foi bem-sucedida
if [ $? -eq 0 ]; then
  echo "File unzipped with success in directory: $outputDir."
else
  echo "Error when trying to unzip file."
  exit 1
fi

# Remove o arquivo zip após a descompactação
rm -f "$downloadFile"
