O seu script parece estar com vários problemas, principalmente relacionados ao formato e possíveis caracteres inválidos. Vou ajustar o script para você. Seguem as correções necessárias:

1. **Formatos de quebras de linha e espaços**: O script pode conter quebras de linha e espaços em branco que não estão sendo interpretados corretamente pelo shell.
2. **Verificar sintaxe**: Alguns comandos estão mal formatados ou têm caracteres que o shell não reconhece.
3. **Comandos SQL**: Pode ser que alguns comandos estejam gerando erros porque o banco de dados ou as tabelas já existem.

Aqui está o script corrigido:

```bash
#!/bin/bash

####################################################################
# Citra IT - Excelência em TI
# Procedimento: INSTALAÇÃO GLPI
# @Responsável: luciano@citrait.com.br
# @Data: 12/03/2024
# @Versão: 1.0
####################################################################

####################################################################
# 1. Pré-Requisitos
####################################################################
# 1.1. Servidor Ubuntu 22.04LTS Instalado
# 1.2. Acesso à internet para download e instalação de pacotes
# 1.3. Acesso de root ao servidor

####################################################################
# 2. Instalação
####################################################################

# 2.1. Atualizar pacotes
sudo apt update && sudo apt dist-upgrade -y

# 2.2. Reconfigurar timezone
sudo dpkg-reconfigure tzdata

# 2.4. Instalar Nginx, PHP e MySQL
sudo apt install -y \
    nginx \
    mariadb-server \
    mariadb-client \
    php-fpm \
    php-dom \
    php-fileinfo \
    php-json \
    php-simplexml \
    php-xmlreader \
    php-xmlwriter \
    php-curl \
    php-gd \
    php-intl \
    php-mysqli \
    php-bz2 \
    php-zip \
    php-exif \
    php-ldap \
    php-opcache \
    php-mbstring

# 2.5. Criar banco de dados do GLPI
sudo mysql -e "CREATE DATABASE IF NOT EXISTS glpi;"
sudo mysql -e "GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost' IDENTIFIED BY '1cd73cddc8dad1fef981391f';"
sudo mysql -e "GRANT SELECT ON mysql.time_zone_name TO 'glpi'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# 2.6. Carregar timezones no MySQL
sudo mysql_tzinfo_to_sql /usr/share/zoneinfo | sudo mysql -u root mysql

# 2.8. Habilitar session.cookie_httponly e configurar timezone no PHP
sudo sed -i 's/^session.cookie_httponly =/session.cookie_httponly = on/' /etc/php/8.1/fpm/php.ini
sudo sed -i 's/^;date.timezone =/date.timezone = America\/Sao_Paulo/' /etc/php/8.1/fpm/php.ini

# 2.9. Criar o virtualhost do GLPI
cat <<EOL | sudo tee /etc/nginx/sites-available/glpi
server {
    listen 80;
    server_name _;
    root /var/www/glpi/public;
    index index.php;
    location / {
        try_files \$uri /index.php\$is_args\$args;
    }
    location ~ ^/index\.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)\$;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        include /etc/nginx/fastcgi.conf;
    }
}
EOL

sudo ln -s /etc/nginx/sites-available/glpi /etc/nginx/sites-enabled/

# 2.12. Reiniciar serviços
sudo systemctl restart nginx php8.1-fpm mysql

# 2.13. Download do GLPI
wget https://github.com/glpi-project/glpi/releases/download/10.0.15/glpi-10.0.15.tgz

# 2.14. Descompactar o GLPI
tar -zxf glpi-10.0.15.tgz

# 2.15. Mover a pasta do GLPI para a pasta /var/www
sudo mv glpi /var/www/glpi

# 2.16. Configurar permissões na pasta /var/www/glpi
sudo chown -R www-data:www-data /var/www/glpi

# 2.17. Finalizar setup do GLPI pela linha de comando
sudo php /var/www/glpi/bin/console db:install \
    --default-language=pt_BR \
    --db-host=localhost \
    --db-port=3306 \
    --db-name=glpi \
    --db-user=glpi \
    --db-password=1cd73cddc8dad1fef981391f \
    --no-interaction

####################################################################
# 3. Ajustes de Segurança
####################################################################
# 3.1. Remover o arquivo de instalação
sudo rm /var/www/glpi/install/install.php

# 3.2. Mover pastas do GLPI de forma segura
sudo mv /var/www/glpi/files /var/lib/glpi
sudo mv /var/www/glpi/config /etc/glpi
sudo mkdir /var/log/glpi && sudo chown -R www-data:www-data /var/log/glpi

# 3.3. Criar arquivo downstream.php
sudo bash -c "cat > /var/www/glpi/inc/downstream.php <<EOL
<?php
define('GLPI_CONFIG_DIR', '/etc/glpi/');
if (file_exists(GLPI_CONFIG_DIR . '/local_define.php')) {
    require_once GLPI_CONFIG_DIR . '/local_define.php';
}
EOL"

# 3.4. Criar o arquivo local_define.php
sudo bash -c "cat > /etc/glpi/local_define.php <<EOL
<?php
define('GLPI_VAR_DIR', '/var/lib/glpi');
define('GLPI_LOG_DIR', '/var/log/glpi');
EOL"

####################################################################
# 4. Primeiros Passos
####################################################################
# 4.1. Acessar o GLPI via web browser
# 4.2. Criar um novo usuário com perfil super-admin
# 4.3. Remover os usuários glpi, normal, post-only, tech.
# 4.3.1. Enviar os usuários para a lixeira
# 4.3.2. Remover permanentemente
# 4.3.4. Configurar a URL de acesso ao sistema em: Configurar -> Geral -> Configuração Geral -> URL da aplicação.
```

### Como usar:
1. Copie o script para um arquivo `.sh`.
2. Dê permissão de execução ao script com `chmod +x nome_do_script.sh`.
3. Execute o script com `sudo ./nome_do_script.sh`.

Esse script deve corrigir os problemas que você encontrou. Se ainda houver problemas, me avise!