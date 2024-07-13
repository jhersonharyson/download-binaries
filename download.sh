#!/bin/bash

# Parâmetros do script
downloadUrl="$1"
projectName="$2"

echo "test url aqui '$downloadUrl'"

# Obtém o hash do commit atual do Git
commitHash=$(git rev-parse HEAD)
if [ -z "$commitHash" ]; then
  echo "Error: Cannot get current commit hash."
  exit 1
fi

# Nome do arquivo para salvar o download
downloadFile="binaries.zip"

# Diretório onde descompactar os arquivos
outputDir="."

# Faz o download do arquivo usando curl com algumas opções adicionais
curl --location --fail --retry 3 --retry-delay 5 "$downloadUrl" --output "$downloadFile"

# Verifica o status do download
if [ $? -eq 0 ]; then
  echo "Successful Download"
else
  echo "Download Error."
  exit 1
fi

# Exibe o conteúdo do arquivo baixado para depuração
echo "Content of the downloaded file:"
head -c 200 "$downloadFile"  # Mostra os primeiros 200 bytes do arquivo para verificação

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
