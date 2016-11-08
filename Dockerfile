FROM christianaiddigital/ca_base
MAINTAINER Robin Andrew <randrew@christian-aid.org>
ENV DEBIAN_FRONTEND noninteractive
#DEVELOPMENT SETUP 

#all tools from here are non essential
RUN apt-get update && \
    apt-get -y upgrade

# Install tools for documenting.
RUN apt-get -y install python-sphinx python-pip doxygen && \
    pip install sphinx_rtd_theme breathe

# XML needed by PHPCodeSniffer 2.3+
# AST and SQLite needed by Phan
RUN apt-get -y install php-xml php-sqlite3 php-ast


# Install JRE (needed for some testing tools like sitespeed.io) and libs for PhantomJS.
RUN apt-get -y install default-jre libfreetype6 libfontconfig

# Install Node 6 LTS (https://nodejs.org/)
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g bower
RUN npm install -g gulp

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY shared /var/www/html/

RUN service apache2 restart
RUN service php7.0-fpm restart

WORKDIR /var/www
# Expose additional ports for test tools.
EXPOSE 8080 9876 9000 

CMD ["/usr/local/bin/run"]