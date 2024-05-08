FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# proxy
ARG HTTP_PROXY
ARG NO_PROXY
ENV HTTPS_PROXY ${HTTP_PROXY}
ENV HTTP_PROXY ${HTTP_PROXY}
ENV FTP_PROXY ${HTTP_PROXY}
RUN if [ ! -z "$HTTP_PROXY" ] ; then echo "Acquire::https::Proxy \"$HTTP_PROXY\";" >> /etc/apt/apt.conf ; fi
RUN if [ ! -z "$HTTP_PROXY" ] ; then echo "Acquire::http::Proxy \"$HTTP_PROXY\";" >> /etc/apt/apt.conf ; fi
RUN if [ ! -z "$HTTP_PROXY" ] ; then echo "Acquire::ftp::Proxy \"$HTTP_PROXY\";" >> /etc/apt/apt.conf ; fi


RUN apt-get update && \
    apt-get install -y software-properties-common git curl sudo \
    gnupg gosu curl ca-certificates zip unzip git supervisor sqlite3 libcap2-bin libpng-dev python2 dnsutils librsvg2-bin

# php default: 7.4
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y
RUN apt-get update && apt-get install -y apache2 php7.4 libapache2-mod-php7.4 
RUN apt-get update && \
    apt-get install -y \
        php7.4-bcmath \
        php7.4-bz2 \
        php7.4-curl \
        php7.4-intl \
        php7.4-gd \
        php7.4-mbstring \
        php7.4-pgsql \
        php7.4-xml \
        php7.4-soap \
        php7.4-mysql \
        php7.4-zip \
        php7.4-fpm \
        php7.4-xdebug

# replace default Apache config with modified version that sets the document root to /var/www/html/public
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
COPY conf.d/apache-config.conf /etc/apache2/sites-available/000-default.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# enable apache modules
RUN a2enmod rewrite

# configure php
COPY conf.d/php.ini /etc/php/7.4/mods-available/custom.ini
RUN phpenmod custom
RUN /etc/init.d/apache2 restart
RUN /etc/init.d/php7.4-fpm restart

# install composer
RUN curl https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Add a new user "devContainer" with user id 1337
ARG USERNAME=devContainer
RUN groupadd --force -g 1000 $USERNAME
RUN useradd -ms /bin/bash --no-user-group -g 1000 -u 1337 $USERNAME

# allow devContainer use sudo without password
RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# TODO: Custom configs in bash: Show git branch
COPY start-container /usr/local/bin/start-container
RUN chmod +x /usr/local/bin/start-container
RUN /usr/local/bin/start-container

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]