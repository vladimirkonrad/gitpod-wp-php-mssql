FROM amd64/wordpress:latest

# Allow devcontainer/Codespace use www-data as the remote user instead of root.
RUN usermod --shell /bin/bash www-data
RUN touch /var/www/.bashrc
RUN chown -R www-data: /var/www/

# Install git, zip, wget, MC, htop, JRE, JDK
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git && \
    apt-get install -y sudo && \
    apt-get install -y zip && \
    apt-get install -y wget && \
    apt-get install -y mc && \
    apt-get install -y htop && \
    apt-get install -y default-jre && \
    apt-get install -y default-jdk


# Allow www-data user to use sudo without password
RUN adduser www-data sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


# Install Xdebug
RUN pecl install "xdebug" || true \
    && docker-php-ext-enable xdebug

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Installing PHP tools - PHP_Codesniffer
RUN curl -sSOL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar && \
    chmod +x phpcs.phar && \
    mv phpcs.phar /usr/local/bin/phpcs
RUN curl -sSOL https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar  && \
    chmod +x phpcbf.phar && \
    mv phpcbf.phar /usr/local/bin/phpcbf

# Install WP CLI
RUN curl -sSO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# install php mssql ext
RUN alias wp='wp --allow-root' 
RUN apt-get update && apt-get install -y gnupg2

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN sudo apt-get update
RUN sudo ACCEPT_EULA=Y apt-get install -y msodbcsql17


RUN sudo apt install -y unixodbc-dev
RUN sudo pecl install sqlsrv
RUN sudo pecl install pdo_sqlsrv
RUN sudo printf 'extension=sqlsrv.so' >  /usr/local/etc/php/conf.d/docker-php-ext-sqlsrv.ini
RUN sudo printf 'extension=pdosqlsrv.so' >  /usr/local/etc/php/conf.d/docker-php-ext-pdo_sqlsrv.ini

# WORKDIR  /var/www/html
# RUN cd /var/www/html \
# RUN wp core install --url=localhost --title=Example --admin_user=admin --admin_password=admin --admin_email=info@konrad.rs --allow-root

# RUN mkdir -p /scripts
# COPY /scripts/script.sh /var/www/html
# WORKDIR  /var/www/html
# RUN chmod +x script.sh
# RUN ./script.sh

# WORKDIR /var/www/html   
# RUN wp plugin install pods --activate --allow-root # To install and activate plugin repository && \
# wp plugin install query-monitor --activate --allow-root # To install and activate plugin repository 
# wp plugin install wp-crontrol --activate --allow-root # To install and activate plugin repository && \
# wp theme install generatepress --activate  --allow-root # To install and activate plugin repository && \
# wp plugin delete hello --allow-root && \
# wp plugin delete akismet --allow-root && \
# wp theme delete twentytwentytwo --allow-root && \
# wp theme delete twentytwentyone --allow-root





# Install nvm and node
# RUN su www-data -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash'
# RUN su www-data -c 'export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm install --lts'
