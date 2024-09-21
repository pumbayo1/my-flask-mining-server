#!/bin/bash

# Automatyczna instalacja Flask i skonfigurowanie serwera do serwowania pliku mining_history.csv

# Aktualizacja pakietów i instalacja pip oraz Flask
echo "Aktualizacja pakietów systemowych..."
sudo apt update && sudo apt upgrade -y

echo "Instalacja pip..."
sudo apt install python3-pip -y

echo "Instalacja Flask..."
pip3 install flask

# Tworzenie katalogu na skrypt i plik CSV, jeśli nie istnieje
SCRIPT_DIR="/root/scripts"
CSV_FILE="$SCRIPT_DIR/mining_history.csv"
SERVE_SCRIPT="$SCRIPT_DIR/serve_csv.py"

if [ ! -d "$SCRIPT_DIR" ]; then
  echo "Tworzenie katalogu /root/scripts..."
  mkdir -p $SCRIPT_DIR
fi

# Pobieranie pliku serve_csv.py z GitHub
echo "Pobieranie skryptu serve_csv.py z repozytorium GitHub..."
wget -O $SERVE_SCRIPT https://raw.githubusercontent.com/pumbayo1/my-flask-mining-server/main/serve_csv.py

# Tworzenie przykładowego pliku CSV, jeśli nie istnieje
if [ ! -f "$CSV_FILE" ]; then
  echo "Tworzenie przykładowego pliku mining_history.csv..."
  echo '"21/09/2024 00:00","3619,13"' > $CSV_FILE
fi

# Dodanie serwera Flask do Crontaba, aby uruchamiał się przy starcie systemu
echo "Dodawanie serwera Flask do Crontaba, aby uruchamiał się przy starcie..."
(crontab -l ; echo "@reboot /usr/bin/python3 $SERVE_SCRIPT") | crontab -

# Uruchamianie serwera Flask
echo "Uruchamianie serwera Flask..."
python3 $SERVE_SCRIPT &

echo "Instalacja zakończona. Serwer Flask został uruchomiony i serwuje plik mining_history.csv"
