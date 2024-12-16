#!/bin/bash

# Script para instalar Snort y sus dependencias

set -e  # Detener el script si algún comando falla

echo "Actualizando el sistema..."
sudo apt update && sudo apt upgrade -y

echo "Instalando dependencias necesarias..."
sudo apt install -y build-essential libpcap-dev libpcre3-dev libdumbnet-dev bison flex zlib1g-dev flex

echo "Descargando y compilando DAQ..."
wget https://www.snort.org/downloads/snort/daq-2.0.7.tar.gz
tar xvfz daq-2.0.7.tar.gz
cd daq-2.0.7
./configure
make
sudo make install
cd ..

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
