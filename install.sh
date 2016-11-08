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
perlbrew install-cpanm

cpanm -f DBD::mysql

cpanm JSON::XS JavaScript::Minifier::XS CSS::Minifier::XS Crypt::Eksblowfish::Bcrypt

echo 'export PERLBREW_ROOT=/opt/perl5' >> "/home/vagrant/.bash_profile"
echo 'source ${PERLBREW_ROOT}/etc/bashrc' >> "/home/vagrant/.bash_profile"

chmod 777 -R /opt


