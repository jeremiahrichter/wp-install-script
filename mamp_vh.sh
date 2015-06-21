#!/bin/bash -e

RED="\033[0;31m"
YELLOW="\033[33m"
REDBG="\033[0;41m"
WHITE="\033[1;37m"
NC="\033[0m"

mkdir -p /Applications/MAMP/Library/vhosts;
mkdir -p /Applications/MAMP/Library/vhosts/domains;

if [ "$1" = "create" ] || [ "$1" = "add" ]; then
 # Ask for document root
  echo -e "${RED}Enter the document root (relative to 'htdocs'):${NC}";
  read documentRoot;

  # Ask for domain name
  echo -e "${RED}Enter local domain: (eg. local.com):${NC}";
  read domain;

   # Ask for port number
  echo -e "${RED}Enter MAMP Port Nubmer:${NC}";
  read port;

  # Add vhost
  touch /Applications/MAMP/Library/vhosts/domains/$domain;

  echo "<VirtualHost *:$port>
    DocumentRoot "/Applications/MAMP/htdocs/$documentRoot"
    ServerName $domain
    <Directory "/Applications/MAMP/htdocs/$documentRoot">
        Options All
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
</VirtualHost>" >> /Applications/MAMP/Library/vhosts/domains/$domain;

  echo "127.0.0.1 $domain" >> /etc/hosts;

  # Restart MAMP
  /Applications/MAMP/bin/apache2/bin/apachectl restart;

  # echo out the domain name and copy domain to clipboard
  echo -e "Finished. ${REDBG}${WHITE}$domain:$port${NC} has been copied to your clipboard.";
  echo "$domain:$port" | pbcopy;
fi

if [ "$1" = "remove" ] || [ "$1" = "delete" ]; then
    echo -e "${RED}Here are the current custom local domains:${NC}"
    for file in /Applications/MAMP/Library/vhosts/domains/*
    do
      if [ -f "$file" ];then
       echo -e "${YELLOW}${file##/*/}${NC}"
      fi
    done
    echo -e "${RED}Enter the site name you wish to remove:${NC}"
    read siteName;

    sed -i.bak "/$siteName/d" /etc/hosts;
    rm /Applications/MAMP/Library/vhosts/domains/$siteName;

    echo -e "${YELLOW}$siteName removed."
fi