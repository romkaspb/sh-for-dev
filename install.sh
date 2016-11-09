#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "First, update repos and install git"
sudo apt-get update
sudo apt-get install git

echo "Enter your git username:"
read GIT_NAME
echo "Enter your git email:"
read GIT_EMAIL

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

echo "Then, install perl and packages"

locale-gen en_US en_US.UTF-8 ru_RU ru_RU.UTF-8
dpkg-reconfigure locales

echo 'LC_ALL=ru_RU.UTF-8' >> /etc/environment
echo 'LANG=ru_RU.UTF-8' >> /etc/environment
echo 'LANGUAGE=ru_RU.UTF-8' >> /etc/environment

apt-get install curl  bzip2 patch build-essential libmysqlclient-dev

export PERLBREW_ROOT=/opt/perl5
curl -kL http://install.perlbrew.pl | bash

echo 'source /opt/perl5/etc/bashrc' >> /home/vagrant/.bash_profile
source /home/vagrant/.bash_profile

perlbrew --notest install perl-5.20.2 -Dcccdlflags=-fPIC -Duseshrplib -Duse64bitall -Duselargefiles

perlbrew switch perl-5.20.2
source /home/vagrant/.bash_profile
perlbrew install-cpanm

cpanm -f DBD::mysql

cpanm JSON::XS JavaScript::Minifier::XS CSS::Minifier::XS Crypt::Eksblowfish::Bcrypt

echo "Install special modules for PERL"
cpan install URI::Escape CGI::Carp

echo 'export PERLBREW_ROOT=/opt/perl5' >> "/home/vagrant/.bash_profile"
echo 'source ${PERLBREW_ROOT}/etc/bashrc' >> "/home/vagrant/.bash_profile"

chmod 777 -R /opt

sudo apt-get install mysql-server

sudo apt-get install build-essential checkinstall libx11-dev libxext-dev zlib1g-dev libpng12-dev libjpeg-dev
sudo apt-get install libjpeg62-dev libpng-dev libfreetype6-dev libfreetype6-dev libtiff5-dev liblcms1-dev

echo "Install sendmail"
sudo apt-get install sendmail

TOP="$HOME/local"

if [ -n "$1" ]; then
    TOP=$1
fi

mkdir -p $TOP
cd "$TOP"
wget -c http://www.imagemagick.org/download/ImageMagick.tar.gz
tar xzvf ImageMagick.tar.gz
cd ImageMagick* # this isn't exactly clean


PERL_CORE=$(perl -e 'print grep { -d } map { "$_/CORE" } @INC')
PERL_BIN=$(which perl)

PERL_THREADS=$(perl -V | grep -c 'useithreads=define')

THREAD_FLAG="--with-threads"

if [ $PERL_THREADS = 0 ]; then
    THREAD_FLAG="--without-threads"
fi

LDFLAGS=-L$PERL_CORE \
    ./configure --with-jpeg=yes --with-png=yes  --with-jp2=yes --prefix $TOP \
    --with-perl=$PERL_BIN --with-gslib --with-fontconfig=yes \
    --with-freetype=yes --with-webp=yes --with-ghostscript=yes --with-jasper=yes --with-librsvg=yes --with-libtiff=yes \
        --with-webp=yes \
    --enable-shared $THREAD_FLAG

make install

