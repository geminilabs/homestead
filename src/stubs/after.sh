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
    cp /vagrant/src/stubs/zshrc /home/vagrant/.zshrc
	/bin/bash --login
	chsh -s /usr/bin/zsh vagrant
	/usr/bin/zsh --login

    #
    # copy files
    #
    cp /vagrant/src/stubs/pgpass /home/vagrant/.pgpass
    cp /vagrant/src/stubs/postgresql /home/vagrant/.postgresql

    #
    # set permissions
    #
    sudo chown -R vagrant:vagrant /home/vagrant
    sudo chmod 600 /home/vagrant/.pgpass

    #
    # remember that the extra software is installed
    #
    touch /usr/local/custom_homestead
else
	echo "$(tput setaf 7)Homestead has already been already updated. Moving on..."
fi
