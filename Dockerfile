FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get install -y software-properties-common git curl sudo

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y
RUN apt-get update && apt-get install -y apache2 php5.6 libapache2-mod-php5.6 
RUN apt-get update && \
    apt-get install -y \
        php5.6-bcmath \
        php5.6-bz2 \
        php5.6-curl \
        php5.6-intl \
        php5.6-gd \
        php5.6-mbstring \
        php5.6-pgsql \
        php5.6-xml \
        php5.6-soap \
        php5.6-mysql \
        php5.6-zip \
        php5.6-fpm

# replace default Apache config with modified version that sets the document root to /var/www/html/public
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# enable apache modules
RUN a2enmod rewrite

# install composer
RUN curl https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Add a new user "devContainer" with user id 1337
ARG USERNAME=devContainer
RUN groupadd --force -g 1000 $USERNAME
RUN useradd -ms /bin/bash --no-user-group -g 1000 -u 1337 $USERNAME

# allow devContainer use sudo without password
RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]