FROM ubuntu:16.04
ENV HOME=/home/isucon
ENV PATH $HOME/local/go/bin:$HOME/go/bin:$PATH
RUN useradd -ms /bin/bash isucon
RUN echo 'mysql-server mysql-server/root_password password root' | debconf-set-selections
RUN echo 'mysql-server mysql-server/root_password_again password root' | debconf-set-selections
RUN apt-get update && \
    apt-get install -y git nginx mysql-server curl libreadline-dev pkg-config autoconf automake build-essential \
    libmysqlclient-dev libssl-dev python3 python3-dev python3-venv openjdk-8-jdk-headless libxml2-dev libcurl4-openssl-dev \
    libxslt1-dev re2c bison libbz2-dev libreadline-dev libssl-dev gettext libgettextpo-dev libicu-dev libmhash-dev \
    libmcrypt-dev libgd-dev libtidy-dev jq
RUN usermod -d /var/lib/mysql mysql
WORKDIR $HOME
RUN git clone https://github.com/isucon/isucon7-qualify.git isubata
RUN git clone https://github.com/tagomoris/xbuild.git
RUN mkdir local && xbuild/go-install -f 1.9 $HOME/local/go && go get github.com/constabulary/gb/...
WORKDIR $HOME/isubata/bench
RUN gb vendor restore && make && ./bin/gen-initial-dataset
RUN cp ~/isubata/files/app/nginx.* /etc/nginx/sites-available
WORKDIR /etc/nginx/sites-enabled
RUN unlink default && ln -s ../sites-available/nginx.conf
WORKDIR $HOME/isubata
ADD start.sh $HOME/isubata
CMD ./start.sh
