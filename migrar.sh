#!/bin/bash

# Validamos que pasen el nombre del proyecto
repo=$1
if [ "$repo" = "" ]
then
  echo "migrar: falta ingresar el nombre del repo"
  exit 1
fi

# Validamos que pasen el nombre del proyecto
proyecto=$2
if [ "$proyecto" = "" ]
then
  echo "migrar: falta ingresar el nombre del proyecto"
  exit 1
fi

# Descargamos el proyecto si no lo descargamos anteriormente y lo renombramos a old
if [ ! -d "$proyecto" ]
then
  git clone git@github.com:$repo/$proyecto.git
fi

mv ./$proyecto ./$proyecto-old

# Creo el proyecto con el formato nuevo
wollok init -p $proyecto --noTest

# Borramos el wlk
rm $proyecto/example.wlk

# Copiamos los archivos Wollok del proyecto
cp -R ./$proyecto-old/src/. ./$proyecto

cp -R ./$proyecto-old/assets ./$proyecto      2> /dev/null
cp -R ./$proyecto-old/im*    ./$proyecto      2> /dev/null
cp -R ./$proyecto-old/video* ./$proyecto      2> /dev/null

# Eliminamos log4j.properties
find . -type f -name '*.properties' -delete

# Copiamos README si hay
cp -R ./$proyecto-old/README.md ./$proyecto   2> /dev/null

# Reemplazamos el status badge si apunta a Travis
travis_badge="(https://travis-ci.org/$repo/$proyecto.svg?branch=master)](https://travis-ci.org/$repo/$proyecto)"
gh_badge="(https://github.com/$repo/$proyecto/actions/workflows/ci.yml/badge.svg)](https://github.com/$repo/$proyecto/actions/workflows/ci.yml)"
sed -i "s,$travis_badge,$gh_badge,g" ./$proyecto/README.md

# Renombrar los archivos de test para que no colisionen
shopt -s globstar
for pathname in **/*.wtest; do
    basename=${pathname##*/}
    dirname=${pathname%"$basename"}
    if [[ ! $basename == "test"* ]];
    then
      mv -- "$pathname" "${dirname}test${basename^}"
    fi
done

# Renombrar los programas como pgmXXXX.wpgm
shopt -s globstar
for pathname in **/*.wpgm; do
    basename=${pathname##*/}
    dirname=${pathname%"$basename"}
    if [[ ! $basename == "pgm"* ]];
    then
      mv -- "$pathname" "${dirname}pgm${basename^}"
    fi
done

# Generamos un tag en el repo remoto que diga "Ultima versión Wollok Xtext"
cd $proyecto-old
git tag -a -m "Ultima versión Wollok Xtext"
cd ..
mv ./$proyecto-old/.git ./$proyecto

# Commiteamos el proyecto
cd $proyecto
git add .
git commit -m "Migración a Wollok TS"
git push

cd ..
echo "Proyecto $proyecto migrado correctamente"
