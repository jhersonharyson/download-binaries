#!/bin/bash

# Verifica se a URL de download foi passada como parâmetro
if [ -z "$1" ]; then
  echo "Use: $0 <url>"
  exit 1
fi

# Parâmetro do script
downloadUrl=$1

# Nome do projeto
projectName="mgrowth-point-cms"

# Obtém o hash do commit atual do Git
commitHash="8d95014ba0e8257d55dbb9c53384e9420b11d562"
if [ -z "$commitHash" ]; then
  echo "Error: Cannot get current commit hash."
  exit 1
fi

# Nome do arquivo para salvar o download
downloadFile="${projectName}-${commitHash}.zip"

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

# Verifica se o arquivo baixado é um arquivo zip válido
if ! file "$downloadFile" | grep -q 'Zip archive data'; then
  echo "Error: Downloaded file is not a valid zip archive."
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
