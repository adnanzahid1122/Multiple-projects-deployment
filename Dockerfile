FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    software-properties-common \
    nginx \
    composer \
    curl  \
    nano

RUN apt install -y php7.4-fpm php7.4-bcmath php7.4-cli php7.4-common php7.4-curl php7.4-dev php7.4-fpm php7.4-gd php7.4-imagick php7.4-mbstring php7.4-memcache php7.4-mongodb php7.4-mysql
RUN apt install -y php7.4-opcache php7.4-pgsql php7.4-pspell php7.4-readline php7.4-snmp php7.4-sqlite3 php7.4-ssh2 php7.4-xml php7.4-xmlrpc php7.4-xsl php7.4-zip

RUN apt install -y python3 pip
RUN apt install -y npm
RUN curl -sS https://getcomposer.org/installer | php 
RUN mv composer.phar /usr/local/bin/composer
RUN composer global require laravel/installer
WORKDIR /app
RUN rm /etc/nginx/sites-enabled/default
COPY ./nginx/default.conf /etc/nginx/sites-enabled/default.conf
#COPY ./nginx/python /etc/nginx/sites-enabled/python
#COPY ./nginx/node /etc/nginx/sites-enabled/node
COPY . .
RUN chmod -R 777 /app
#RUN cd /app/Python
RUN pip3 install -r /app/py/requirements.txt
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \ 
 
apt-get update && \
 
apt-get install nodejs -y

WORKDIR /app/vuee
RUN npm install
RUN npm run build

EXPOSE 80
CMD ["sh", "-c", "service php7.4-fpm start & cd /app/py & python3 /app/py/app.py & cd /app/node_pro & npm install & node /app/node_pro/index.js & vuee  cd /app/vuee & npm run serve & nginx -g 'daemon off;'"]

