#!/bin/bash

# Script para instalar Snort y sus dependencias

set -e  # Detener el script si algún comando falla

echo "Actualizando el sistema..."
sudo apt update && sudo apt upgrade -y

echo "Instalando dependencias necesarias..."
sudo apt install -y build-essential libpcap-dev libpcre3-dev libdumbnet-dev bison flex zlib1g-dev flex

echo "Creando carpeta temporal para los ficheros"
sudo mkdir /usr/src/snort_src
cd /usr/src/snort_src

echo "Descargando y compilando DAQ..."
wget https://www.snort.org/downloads/snort/daq-2.0.7.tar.gz
tar xvfz daq-2.0.7.tar.gz
cd daq-2.0.7
./configure
make
sudo make install
cd /usr/src/snort_src

echo "Descargando y compilando Snort..."
wget https://www.snort.org/downloads/snort/snort-2.9.20.tar.gz
tar xvfz snort-2.9.20.tar.gz
cd snort-2.9.20
./configure --enable-sourcefire --disable-open-appid
make
sudo make install
cd ..

echo "Ejecutando ldconfig para actualizar bibliotecas..."
sudo ldconfig

echo "Verificando instalación de Snort..."
snort --version

echo "Instalación completada."


echo "Creación de grupos y usuarios de snort..."
groupadd snort
useradd snort -r -s /sbin/nologin -c SNORT_IDS -g snort

echo "Creación de carpetas..."
mkdir /etc/snort
mkdir /etc/snort/rules
mkdir /etc/snort/preproc_rules
touch /etc/snort/rules/white_list.rules /etc/snort/rules/black_list.rules /etc/snort/rules/local.rules
mkdir /var/log/snort
mkdir /usr/local/lib/snort_dynamicrules

echo "Configurando los privilegios correspondientes..."
chmod -R 5775 /etc/snort
chmod -R 5775 /var/log/snort
chmod -R 5775 /usr/local/lib/snort_dynamicrules
chown -R snort:snort /etc/snort
chown -R snort:snort /var/log/snort
chown -R snort:snort /usr/local/lib/snort_dynamicrules

echo "Copiando ficheros de configuración"
cp /usr/src/snort_src/snort*/etc/*.conf* /etc/snort
cp /usr/src/snort_src/snort*/etc/*.map /etc/snort