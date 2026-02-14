#!/bin/bash
# FadeCity RP - Professional Web-Stack Installer (Ubuntu/Debian 11/12)
# VERSION: Zero-Interaction Automatik

# Farben für die Ausgabe
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Passwort generieren
DB_ROOT_PASS=$(openssl rand -base64 12)

echo -e "${BLUE}==============================================${NC}"
echo -e "${BLUE}   FadeCity RP - Webserver Setup (Zero-Touch) ${NC}"
echo -e "${BLUE}==============================================${NC}"

# Vorbereitung & OS Erkennung
echo -e "${GREEN}[1/5] Vorbereitung & Repositories...${NC}"
sudo apt update && sudo apt install -y curl wget gnupg2 ca-certificates lsb-release apt-transport-https software-properties-common

if [ -f /etc/debian_version ]; then
    OS="debian"
    curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
    echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
else
    OS="ubuntu"
    sudo add-apt-repository ppa:ondrej/php -y
fi
sudo apt update

# phpMyAdmin Automatisierung (Vorschreiben der Antworten)
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $DB_ROOT_PASS" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $DB_ROOT_PASS" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $DB_ROOT_PASS" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | sudo debconf-set-selections

# Installation
echo -e "${GREEN}[2/5] Installiere Apache, MariaDB & PHP 8.4...${NC}"
export DEBIAN_FRONTEND=noninteractive
sudo apt install -y apache2 mariadb-server libapache2-mod-php8.4 php8.4 php8.4-mysql php8.4-curl php8.4-gd php8.4-mbstring php8.4-xml php8.4-zip php8.4-intl phpmyadmin

# MariaDB Absicherung (Automatisch)
echo -e "${GREEN}[3/5] Konfiguriere Datenbank...${NC}"
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Dienste konfigurieren
echo -e "${GREEN}[4/5] Konfiguriere Dienste & Berechtigungen...${NC}"
sudo systemctl enable apache2
sudo systemctl enable mariadb
sudo systemctl restart apache2
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

# Abschlussmeldung
echo -e "${BLUE}==============================================${NC}"
echo -e "${GREEN}   INSTALLATION ERFOLGREICH ABGESCHLOSSEN!    ${NC}"
echo -e "${BLUE}==============================================${NC}"
echo -e "PHP Version:   $(php -v | head -n 1)"
echo -e "Webseite:      ${BLUE}http://$(hostname -I | awk '{print $1}')${NC}"
echo -e "phpMyAdmin:    ${BLUE}http://$(hostname -I | awk '{print $1}')/phpmyadmin${NC}"
echo -e ""
echo -e "${RED}WICHTIGE DATEN FÜR DIE CONFIG.PHP:${NC}"
echo -e "Datenbank-Host: ${GREEN}localhost${NC}"
echo -e "Datenbank-User: ${GREEN}root${NC}"
echo -e "Datenbank-Pass: ${GREEN}$DB_ROOT_PASS${NC}"
echo -e "${BLUE}==============================================${NC}"
echo -e "Kopiere das Passwort sicher weg!"
