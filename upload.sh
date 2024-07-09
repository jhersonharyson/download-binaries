#!/bin/bash

# Verifica se estamos no diretório correto
if [ ! -d "build/classes" ]; then
  echo "Error: Source build/classes not found. Please run build first."
  exit 1
fi

# Obtém o hash do commit atual do Git
commitHash=$(git rev-parse HEAD)
if [ -z "$commitHash" ]; then
  echo "Error: Cannot get current commit hash."
  exit 1
fi

if [ -z "$1" ]; then
  echo "Use: $0 <projectName>"
  exit 1
fi

# Parâmetro do script
projectName=$1

# Define o nome do arquivo zip
zipFileName="${commitHash}.zip"

# Cria o arquivo zip a partir do diretório build/classes
zip -r "$zipFileName" build/classes

# Verifica se o arquivo zip foi criado com sucesso
if [ ! -f "$zipFileName" ]; then
  echo "Error: Cannot make zip file."
  exit 1
fi

# Faz o upload do arquivo zip usando curl
uploadUrl="https://local.adminml.com:8443/api/metrics/quality/upload?projectName=${projectName}"
response=$(curl -s -w "%{http_code}" -o /dev/null -F "file=@${zipFileName}" -F "projectName=${projectName}" "$uploadUrl")

# Verifica o status do upload
if [ "$response" -eq 200 ]; then
  echo "Success Upload."
else
  echo "Error when try upload. Status HTTP: $response"
fi

# Remove o arquivo zip após o upload
rm -f "$zipFileName"
