From ubuntu:12.04

RUN echo "deb http://au.archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update -qq
RUN apt-get install -y rubygems libsqlite3-dev libreadline-dev libncurses5-dev zlib1g-dev liblzma-dev libgdbm-dev libbz2-dev build-essential libssl-dev wget

RUN gem install --verbose fpm

RUN wget http://www.python.org/ftp/python/3.3.3/Python-3.3.3.tgz 2>&1 > /dev/null
RUN tar xf Python-3.3.3.tgz
RUN cd Python-3.3.3/ && ./configure --prefix=/usr/local
RUN cd Python-3.3.3/ && make -j2
RUN mkdir /tmp/installdir
RUN cd Python-3.3.3/ && make install DESTDIR=/tmp/installdir

RUN wget --no-check-certificate https://raw.github.com/pypa/pip/master/contrib/get-pip.py
RUN /tmp/installdir/usr/local/bin/python3 /get-pip.py
RUN rm /tmp/installdir/usr/local/bin/pip
RUN rm /tmp/installdir/usr/local/bin/easy_install

RUN cd /tmp/installdir/usr/local/bin/ \
 && sed -ri '1 s/^.*$/\#!\/usr\/local\/bin\/python3.3/g' pip3 pip3.3 easy_install-3.3

RUN mkdir /packages

# Genreate a python3-full environment package
RUN echo 'cd /packages && fpm -s dir -t deb -n python3-full -v 3.3.3 -C /tmp/installdir -p python3-full-VERSION_ARCH.deb -d "libc6 (>= 2.15)" -d  "libexpat1 (>= 1.95.8)" -d "libffi6 (>= 3.0.4)" -d "libssl1.0.0 (>= 1.0.0)" -d "zlib1g (>= 1:1.2.0)" -d "gcc (>= 0)" -d "libc-dev (>= 0)" usr/local/bin  usr/local/lib  usr/local/share/man' > /build.sh

#
RUN chmod a+x /build.sh

CMD /build.sh
