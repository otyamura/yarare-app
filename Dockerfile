FROM php:7.2-apache

RUN apt-get update
RUN apt-get install -y vim
RUN docker-php-ext-install mbstring

COPY app/* /var/www/html/
COPY backup_app/* /var/www/backup_html/
# ssh接続
RUN apt-get install -y --no-install-recommends openssh-server
RUN mkdir /var/run/sshd

# ARG ROOT_PASS
RUN echo root:root | chpasswd

RUN sed -i 's/#\?PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#Port 22/Port 20022/' /etc/ssh/sshd_config

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 20022
RUN a2enmod rewrite
CMD ["/usr/sbin/sshd", "-D"]


# make user
# ARG UID=1000
# RUN useradd -m -u ${UID} suzuki
