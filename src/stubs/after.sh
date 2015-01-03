#!/bin/bash

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

if [ ! -f /usr/local/custom_homestead ]; then
	echo "$(tput bold)$(tput setaf 4)==> $(tput setaf 7)Updating Homestead"
    
    #
    # install imagemagick
    #
    sudo apt-get install imagemagick -y
    sudo apt-get install php5-imagick -y
    	
    #
    # install rvm
    #
    gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
    curl -L https://get.rvm.io | bash -s stable
	
    #
    # install ruby 2.1.5
    #
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
	/usr/local/rvm/bin/rvm @global do gem install sass
	/usr/local/rvm/bin/rvm @global do gem install compass
	/usr/local/rvm/bin/rvm @global do gem install autoprefixer-rails
	/usr/local/rvm/bin/rvm @global do gem install animation --pre

	#
	# update node
	#
	sudo npm cache clean -f
	sudo npm install -g n
	sudo n latest
	sudo npm install -g npm

	#
	# install mc
	#
	sudo apt-get install mc -y

	#
	# install zsh / oh-my-zsh
	# (after.sh is run as the root user, but ssh is the vagrant user)
	#
	apt-get install zsh -y
	git clone git://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh
	cp /home/vagrant/.oh-my-zsh/templates/zshrc.zsh-template /home/vagrant/.zshrc
	chsh -s /usr/bin/zsh vagrant
	echo "source /usr/local/rvm/environments/default" >> /home/vagrant/.zshrc
	/usr/bin/zsh --login

	echo "\

donpm()
{
    if [ ! ${1} ]; then

        SITE=${1:-"default"}

        if [ ! -f /home/vagrant/Greenzones/$SITE/artisan ]; then
            echo \"Not a laravel project [/home/vagrant/Greenzones/$SITE]\"
            exit 0
        fi

        if [ ! -d /usr/local/npm/$SITE ]; then
            sudo mkdir -p /usr/local/npm/$SITE
        fi

        if [ ! -f /usr/local/npm/$SITE/package.json ]; then
            sudo cp -f /home/vagrant/Greenzones/$SITE/package.json /usr/local/npm/$SITE/
        fi

        cd /usr/local/npm/$SITE
        sudo npm install

        if [ ! -L /home/vagrant/Code/Greenzones/$SITE/node_modules ]; then
            sudo ln -s /usr/local/npm/$SITE/node_modules /home/vagrant/Greenzones/$SITE/node_modules
        fi

        cd /home/vagrant/Greenzones/$SITE
    else
        echo 'You must supply the project dir name (e.g. winpm splash-page).'
    fi
}

alias winpm=donpm
" | tee -a /home/vagrant/.zshrc

    #
    # remember that the extra software is installed
    #    
    touch /usr/local/custom_homestead
else
	echo "$(tput bold)$(tput setaf 4)==> $(tput setaf 7)Homestead has already been already updated. Moving on..."
fi
