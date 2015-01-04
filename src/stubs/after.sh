#!/usr/bin/env bash

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

if [ ! -f /usr/local/custom_homestead ]; then

    #
    # install imagemagick
    #
    echo "$(tput setaf 7)Installing Imagemagick"
    sudo apt-get install imagemagick -y
    sudo apt-get install php5-imagick -y

    #
    # install rvm
    #
    echo "$(tput setaf 7)Installing RVM"
    gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
    curl -L https://get.rvm.io | bash -s stable

    #
    # install ruby 2.1.5
    #
    echo "$(tput setaf 7)Installing Ruby 2.1.5"
    /usr/local/rvm/bin/rvm install ruby-2.1.5
	/usr/local/rvm/bin/rvm alias create default 2.1.5
	echo "source /usr/local/rvm/environments/default" >> ~/.bashrc
    /bin/bash --login
	sudo chgrp -R vagrant /usr/local/rvm/gems/ruby-2.1.5/bin
    sudo chmod -R 770 /usr/local/rvm/gems/ruby-2.1.5/bin
    sudo chgrp -R vagrant /usr/local/rvm/user
    sudo chmod -R 770 /usr/local/rvm/user

	#
	# install gems
	#
    echo "$(tput setaf 7)Installing Ruby Gems"
	/usr/local/rvm/bin/rvm @global do gem install sass
	/usr/local/rvm/bin/rvm @global do gem install compass
	/usr/local/rvm/bin/rvm @global do gem install autoprefixer-rails
	/usr/local/rvm/bin/rvm @global do gem install animation --pre

	#
	# update node
	#
    echo "$(tput setaf 7)Updating Node and NPM"
	sudo npm cache clean -f
	sudo npm install -g n
	sudo n stable
	sudo npm install -g npm

    #
    # install mongodb
    # https://github.com/DoSomething/ds-homestead/blob/master/scripts/mongodb.sh
    #
    echo "$(tput setaf 7)Installing MongoDB"
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
    sudo apt-get update
    sudo apt-get install -qq mongodb-org

    if [ "$1" == "true" ]; then
        sed -i "s/bind_ip = */bind_ip = 0.0.0.0/" /etc/mongod.conf
    fi

    sudo apt-get -y install php-pear php5-dev
    echo 'no' | sudo tee /home/vagrant/answers.txt
    sudo pecl install mongo < /home/vagrant/answers.txt
    rm /home/vagrant/answers.txt
    echo 'extension=mongo.so' | sudo tee /etc/php5/mods-available/mongo.ini
    ln -s /etc/php5/mods-available/mongo.ini /etc/php5/fpm/conf.d/mongo.ini
    ln -s /etc/php5/mods-available/mongo.ini /etc/php5/cli/conf.d/mongo.ini
    sudo service php5-fpm restart

	#
	# install mc
	#
    echo "$(tput setaf 7)Installing Midnight Commander"
	sudo apt-get install mc -y

	#
	# install zsh / oh-my-zsh
	# (after.sh is run as the root user, but ssh is the vagrant user)
	#
    echo "$(tput setaf 7)Installing Zsh"
	apt-get install zsh -y
	git clone git://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh
    cp /vagrant/src/stubs/aliases /home/vagrant/.zshrc
	chsh -s /usr/bin/zsh vagrant
	/usr/bin/zsh --login

    #
    # remember that the extra software is installed
    #
    touch /usr/local/custom_homestead
else
	echo "$(tput setaf 7)Homestead has already been already updated. Moving on..."
fi
