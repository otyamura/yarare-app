FROM centos:centos8

RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum install -y epel-release && yum clean all

RUN yum -y update && yum clean all

# yum
RUN yum -y update && yum clean all
RUN yum -y install httpd
RUN yum -y install php
# ssh接続
RUN yum install -y openssh-server

RUN sed -i 's/#\?PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#Port 22/Port 20022/' /etc/ssh/sshd_config
RUN ssh-keygen -t rsa -N "" -f /etc/ssh/ssh_host_rsa_key
EXPOSE 20022

# user作成
COPY useradd.sh .
RUN chmod +x useradd.sh
RUN ./useradd.sh
RUN echo 'root:root' | chpasswd

# httpd
RUN chown -R apache:apache /var/www/html

RUN sed -i 's/;listen.owner \= nobody/listen.owner \= apache/' /etc/php-fpm.d/www.conf
RUN sed -i 's/;listen.group \= nobody/listen.group \= apache/' /etc/php-fpm.d/www.conf
RUN sed -i 's/listen.acl_users \= apache,nginx/;listen.acl_users \= apache,nginx/' /etc/php-fpm.d/www.conf
RUN sed -i 's/AllowOverride none/AllowOverride All/g' /etc/httpd/conf/httpd.conf
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/httpd/conf/httpd.conf

RUN sed -i 's/^#LogLevel INFO/LogLevel INFO/' /etc/ssh/sshd_config


RUN systemctl enable php-fpm
RUN systemctl enable httpd
CMD ["sleep", "infinity"]
