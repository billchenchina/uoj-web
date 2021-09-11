FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /opt/
COPY 000-uoj.conf /etc/apache2/sites-available/000-uoj.conf
COPY src /opt/uoj/web
RUN \
apt-get -y update && \
apt-get -y install gnupg && \
echo "deb http://ppa.launchpad.net/stesie/libv8/ubuntu bionic main" | tee /etc/apt/sources.list.d/stesie-libv8.list && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D858A0DF && \
apt-get -y update && apt-get -y install vim ntp zip unzip curl wget apache2 libapache2-mod-xsendfile libapache2-mod-php php php-dev php-pear php-zip php-mysql php-mbstring re2c libv8-7.5-dev libyaml-dev git build-essential

RUN \
yes | pecl install yaml && \
git clone https://github.com/phpv8/v8js.git --depth=1 /tmp/pear/download/v8js-master && cd /tmp/pear/download/v8js-master && \
phpize && ./configure --with-php-config=/usr/bin/php-config --with-v8js=/opt/libv8-7.5 && make install && rm -rf /tmp/pear/download/v8js-master

# apt-get -y install mysql-server cmake fp-compiler && \
# apt-get -y install python python3 python3-requests openjdk-8-jdk openjdk-11-jdk && \

RUN \
a2ensite 000-uoj.conf && a2dissite 000-default.conf && \
a2enmod rewrite headers && sed -i -e '172s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf && \
mkdir -p --mode=733 /var/lib/php/uoj_sessions && chmod +t /var/lib/php/uoj_sessions && \
sed -i -e '912a\extension=v8js.so\nextension=yaml.so' /etc/php/7.4/apache2/php.ini && \
ln -sf /opt/uoj/web /var/www/uoj && \
chown -R www-data /var/www/uoj/app/storage

COPY .config.php /var/www/uoj/app
COPY docker-entrypoint.sh /usr/local/bin
WORKDIR /opt/uoj/web/
VOLUME /opt/uoj/web
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apachectl", "-D", "FOREGROUND"]

# \$config = include '/var/www/uoj/app/.default-config.php';
# \$config['database']['password']='$_database_password_';
# \$config['judger']['socket']['port']='$_judger_socket_port_';
# file_put_contents('/var/www/uoj/app/.config.php', "<?php\nreturn ".str_replace('\'_httpHost_\'','UOJContext::httpHost()',var_export(\$config, true)).";\n");