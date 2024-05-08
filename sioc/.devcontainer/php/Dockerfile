FROM php:7.2.24-apache

# proxy
# TODO: create a file to set proxy
ARG HTTP_PROXY
ARG NO_PROXY
ENV HTTPS_PROXY ${HTTP_PROXY}
ENV HTTP_PROXY ${HTTP_PROXY}
ENV FTP_PROXY ${HTTP_PROXY}
RUN if [ ! -z "$HTTP_PROXY" ] ; then echo "Acquire::https::Proxy \"$HTTP_PROXY\";" >> /etc/apt/apt.conf ; fi
RUN if [ ! -z "$HTTP_PROXY" ] ; then echo "Acquire::http::Proxy \"$HTTP_PROXY\";" >> /etc/apt/apt.conf ; fi
RUN if [ ! -z "$HTTP_PROXY" ] ; then echo "Acquire::ftp::Proxy \"$HTTP_PROXY\";" >> /etc/apt/apt.conf ; fi
RUN if [ ! -z "$HTTP_PROXY" ] ; then pear config-set http_proxy ${HTTP_PROXY} ; fi

# update and instalations
RUN apt update && apt upgrade -y
RUN apt install -y openssh-client git nano sudo

# Install locales
RUN apt-get update && apt-get install -y locales
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN sed -i -e 's/# pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG pt_BR.UTF-8
ENV LANGUAGE pt_BR:pt
ENV LC_ALL pt_BR.UTF-8

# configure php
COPY conf.d/php.ini "${PHP_INI_DIR}/conf.d/my-php.ini"

# install php extensions
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions @fix_letsencrypt && \
    install-php-extensions pdo_pgsql pgsql pdo_mysql mysqli\
    calendar exif gettext pcntl shmop sockets sysvmsg sysvsem sysvshm\
    wddx xsl bcmath bz2 intl gd soap zip xdebug

# configure xdebug
COPY conf.d/xdebug.ini "${PHP_INI_DIR}/conf.d"

RUN chmod -R 777 /var/www/html 

# TODO:describe
RUN a2enmod rewrite
RUN sed -i 's/Options -Indexes/Options Indexes FollowSymLinks/' /etc/apache2/conf-available/docker-php.conf 

# install composer
RUN curl https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Add a new user "devUser" with user id 1337
ARG USERNAME=devUser
RUN groupadd --force -g 1000 $USERNAME
RUN useradd -ms /bin/bash --no-user-group -g 1000 -u 1337 $USERNAME

# allow devUser use sudo without password
RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# custom bash
COPY cli/.mybashrc "/home/$USERNAME/.mybashrc"
RUN ["/bin/bash", "-c", "echo \"$(cat /home/$USERNAME/.mybashrc)\" >> /home/$USERNAME/.bashrc"]