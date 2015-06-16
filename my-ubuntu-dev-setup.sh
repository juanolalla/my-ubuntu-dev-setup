#
# PHP Drupal Development Install Guide
#
# Inspired by https://github.com/drubb/docker-drupal-lamp55/blob/master/Dockerfile
#


#
# Step 1: Installation
#

# Install SSH client
sudo apt-get -yqq install openssh-client

# Install ssmtp MTA
sudo apt-get -yqq install ssmtp

# Install Apache web server
sudo apt-get -yqq install apache2-mpm-prefork

# Install MySQL server and save initial configuration
sudo apt-get -yqq install mysql-server

# Install PHP5 with Xdebug and other modules
sudo apt-get -yqq install libapache2-mod-php5 php5-mcrypt php5-dev php5-mysql php5-curl php5-gd php5-intl php5-xdebug

# Install PEAR package manager
sudo apt-get -yqq install php-pear
pear channel-update pear.php.net
pear upgrade-all

# Install PECL package manager
sudo apt-get -yqq install libpcre3-dev

# Install PECL uploadprogress extension
sudo pecl install uploadprogress

# Install memcached service
sudo apt-get -yqq install memcached php5-memcached

# Install GIT (latest version)
sudo apt-get -yqq install git

# Install composer (latest version)
sudo curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Install PhpMyAdmin (latest version)
wget -q -O phpmyadmin.zip http://sourceforge.net/projects/phpmyadmin/files/latest/download
unzip -qq phpmyadmin.zip
sudo rm phpmyadmin.zip
sudo mv phpMyAdmin*.* /opt/phpmyadmin

# Install zsh / OH-MY-ZSH
sudo apt-get -yqq install zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh

# Install some useful cli tools
sudo apt-get -yqq install mc htop vim

# Cleanup some things
sudo apt-get -yqq autoremove
sudo apt-get -yqq autoclean
sudo apt-get clean

# Install drush
git clone https://github.com/drush-ops/drush.git
mv drush /path/to/drush
cd /path/to/drush
chmod u+x drush
sudo ln -s /path/to/drush/drush /usr/bin/drush
which drush
composer install

# Install Oracle JDK
sudo apt-add-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer

# Install OpenVPN
sudo apt-get install openvpn

# Install Ruby with rvm, Sass and Compass
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
sudo curl -sSL https://get.rvm.io | bash -s stable --ruby
source ~/.rvm/scripts/rvm
gem install sass
gem update --system
gem install compass

#
# Step 2: Configuration
#

# Add apache web server configuration file
sudo cp config/httpd.conf /etc/apache2/conf-available/httpd.conf

# Configure needed apache modules, disable default sites and enable custom site
sudo a2enmod rewrite headers expires
sudo a2dismod autoindex status
sudo a2dissite 000-default
sudo a2enconf httpd
sudo service apache2 restart

# Add additional php configuration file
sudo cp config/php.ini /etc/php5/mods-available/php.ini
sudo php5enmod php

# Add additional mysql configuration file
sudo cp config/mysql.cnf /etc/mysql/conf.d/mysql.cnf

# Add memcached configuration file
sudo cp config/memcached.conf /etc/memcached.conf

# Add ssmtp configuration file
sudo cp config/ssmtp.conf /etc/ssmtp/ssmtp.conf

# Add phpmyadmin configuration file
sudo cp config/config.inc.php /opt/phpmyadmin/config.inc.php

# Add git global configuration files
cp config/.gitconfig $HOME/.gitconfig
cp config/.gitignore $HOME/.gitignore

# Add drush global configuration file
cp config/drushrc.php $HOME/.drush/drushrc.php

# Add zsh configuration
cp config/.zshrc $HOME/.zshrc
# Make ZSH the default shell for current user, need to re-login
chsh -s /bin/zsh
