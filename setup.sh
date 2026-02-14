#!/bin/bash
# FadeCity RP - Professional Web-Stack Installer (PHP 8.4)

# Farben für die Ausgabe
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}==============================================${NC}"
echo -e "${BLUE}   FadeCity RP - Webserver Setup (PHP 8.4)    ${NC}"
echo -e "${BLUE}==============================================${NC}"

echo -e "${GREEN}[1/5] Vorbereitung & Repositories...${NC}"
sudo apt update && sudo apt install -y software-properties-common curl awk
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update

echo -e "${GREEN}[2/5] Installiere Apache & PHP 8.4 (Cutting Edge)...${NC}"
sudo apt install -y apache2 libapache2-mod-php8.4 php8.4 php8.4-mysql php8.4-curl php8.4-gd php8.4-mbstring php8.4-xml php8.4-zip php8.4-intl

echo -e "${GREEN}[3/5] Installiere phpMyAdmin...${NC}"
export DEBIAN_FRONTEND=noninteractive
sudo apt install -y phpmyadmin

echo -e "${GREEN}[4/5] Konfiguriere Dienste & Berechtigungen...${NC}"
sudo systemctl enable apache2
sudo systemctl restart apache2
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

echo -e "${BLUE}==============================================${NC}"
echo -e "${GREEN}   INSTALLATION ERFOLGREICH ABGESCHLOSSEN!    ${NC}"
echo -e "${BLUE}==============================================${NC}"
php -v | head -n 1
echo -e "Webseite:    ${BLUE}http://\$(hostname -I | awk '{print \$1}')${NC}"
echo -e "phpMyAdmin:  ${BLUE}http://\$(hostname -I | awk '{print \$1}')/phpmyadmin${NC}"
echo -e "${BLUE}==============================================${NC}"
