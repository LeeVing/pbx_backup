aptInstall = sudo apt-get install -y
aptRepo = sudo add-apt-repository -y
aptUpdate = sudo apt-get update
npm = sudo npm install -g
pycharm = pycharm-professional-2017.1.4
phpstorm = PhpStorm-2017.1.4
gitBranch = release/5.31.0

all: update basics scripts programs dev/sync

programs: composer node virtual virtualenvwrapper docker-compose

apps: chrome phpstorm pycharm hipchat sublime atom

dev: dev/sync dev/envup

update:
	$(aptUpdate)
	touch update

basics: update
	$(aptInstall) curl wget git
	touch basics

mksrcdir:
	mkdir -p $(SRCHOME)
	touch mksrcdir

mkappsdir:
	mkdir -p $(APPSHOME)
	touch mkappsdir

mkbindir:
	mkdir -p $(SCRIPTHOME)
	touch mkbindir

video: update
	$(aptInstall) nvidia-current-updates

php: basics
	$(aptRepo) ppa:ondrej/php
	$(aptUpdate)
	$(aptInstall) php5.6
	$(aptInstall) php5.6-cli
	$(aptInstall) php5.6-curl
	$(aptInstall) php5.6-mysql
	$(aptInstall) php5.6-pgsql
	$(aptInstall) php5.6-sqlite
	touch php

composer: php
	curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
	touch composer

ruby: basics
	sudo apt-add-repository -y ppa:brightbox/ruby-ng; \
	sudo apt-get update; \
	sudo apt-get install -y ruby2.2 ruby2.2-dev; \

node: basics
	curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
	$(aptInstall) nodejs
	touch node

scripts: mkbindir
	cp dev_scripts/* $(SCRIPTHOME)
	chmod +x $(SCRIPTHOME)/*
	mkdir -p $(SRCHOME)/sync
	cp -f dev_scripts/* $(SRCHOME)/sync
	chmod +x $(SRCHOME)/sync/*
	touch scripts

node/aglio: node
	$(npm) aglio

atom: basics
	wget https://atom-installer.github.com/v1.6.0/atom-amd64.deb
	sudo dpkg --install atom-amd64.deb
	sudo rm atom-amd64.deb
	apm install `cat ../atom.packages.list`
	touch atom

emacs: basics
	$(aptInstall) build-essential ; \
	sudo apt-get build-dep emacs24 ; \
	cd $(SRCHOME) ; \
	wget http://ftp.gnu.org/gnu/emacs/emacs-24.4.tar.gz ; \
	tar -xzvf emacs-24.4.tar.gz ; \
	rm emacs-24.4.tar.gz ; \
	cd emacs-24.4 ; \
	./configure --prefix=$(APPSHOME) ; \
	make ; \
	make install || sudo make install ; \
	make clean ; \
	if [ ! -f "/usr/local/bin/emacs" ]; then \
		sudo ln -s $(APPSHOME)/bin/emacs /usr/local/bin/emacs ; \
	fi ;\
	touch emacs

spacemacs: emacs
	mv ~/.emacs.d ~/old_emacs_d
	git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

byobu:
	$(aptInstall) byobu
	touch byobu

gitreview:
	$(aptInstall) git-review
	touch gitreview

virtual:
	$(aptInstall) virtualbox
	touch virtual

pip:
	$(aptInstall) python-pip python-dev
	sudo pip install --upgrade pip
	touch pip

virtualenvwrapper: pip
	sudo pip install virtualenv
	sudo pip install virtualenvwrapper
	echo "source ~/.bashrc to activate virtualenvwrapper"

docker:
	wget -qO- https://get.docker.com/ | sh
	sudo service docker start
	sudo usermod -aG docker $(whoami)
	echo "please logout and log back in before using Docker"
	touch docker

docker-compose: docker pip
	 sudo pip install docker-compose
	 touch docker-compose

kubectl:
	curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
	sudo mv kubectl /usr/local/bin
	sudo chmod +x /usr/local/bin/kubectl
	touch kubectl

chrome: update
	$(aptInstall) libxss1 libappindicator1 libindicator7
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo dpkg -i google-chrome*.deb
	rm google-chrome*.deb
	touch chrome

jdk:
	sudo apt-get purge openjdk*
	$(aptRepo) ppa:webupd8team/java
	$(aptUpdate)
	echo 'debconf shared/accepted-oracle-license-v1-1 select true' | sudo debconf-set-selections
	echo 'debconf shared/accepted-oracle-license-v1-1 seen true' | sudo debconf-set-selections
	$(aptInstall) oracle-java8-installer
	touch jdk

compass:
	sudo gem install compass -v 0.12.7

filewatch:
	echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
	touch filewatch

phpstorm: mkappsdir jdk filewatch
	cd $(APPSHOME) ; \
		wget http://download-cf.jetbrains.com/webide/$(phpstorm).tar.gz ; \
		tar -xvf $(phpstorm).tar.gz ; \
		rm $(phpstorm).tar.gz ; \
		cd PhpStorm-*/bin ; \
			./phpstorm.sh ; \
	touch phpstorm

pycharm: mkappsdir jdk filewatch
	cd $(APPSHOME) ; \
		wget https://download-cf.jetbrains.com/python/$(pycharm).tar.gz ; \
		tar -xvf $(pycharm).tar.gz ; \
		rm $(pycharm).tar.gz ; \
		cd pycharm-*/bin ; \
			./pycharm.sh
	touch pycharm

hipchat:
	sudo sh -c 'echo "deb https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client $(lsb_release -c -s) main" > /etc/apt/sources.list.d/atlassian-hipchat4.list'
	wget -O - https://atlassian.artifactoryonline.com/atlassian/api/gpg/key/public | sudo apt-key add -
	sudo apt-get update
	sudo apt-get install hipchat4
	touch hipchat

sublime:
	$(aptRepo) ppa:webupd8team/sublime-text-3
	$(aptUpdate)
	$(aptInstall) sublime-text-installer
	touch sublime

fonts:
	[ -d /usr/share/fonts/opentype ] || sudo mkdir /usr/share/fonts/opentype
	sudo git clone https://github.com/adobe-fonts/source-code-pro.git /usr/share/fonts/opentype/scp
	sudo fc-cache -f -v
	touch fonts

chefplugins:
	vagrant plugin install rack buff-extensions --plugin-version "<2.0"
	touch chefplugins

dev/sync: mksrcdir
	echo "please add your public ssh key to gerrit." ; \
	echo "" ; \
	cat ~/.ssh/id_rsa.pub ; \
	echo "" ; \
	read -p "Press [ENTER] when complete. or ctrl-c now and rerun make" ent ;
	cd $(SRCHOME)/sync && bash sync-branch.sh -f --branch $(gitBranch)
	touch sync

dev/envup: chef sync node docker-compose
	v up --no-provision chef_server && \
	v provision chef_server && \
	v up sbc app_mq1 app_mq2 agents web api_web ; \
	cd $(SRCHOME)/sync && bash sync-branch.sh --branch $(gitBranch) ; \
	cd $(SRCHOME)/service-pbx && $(MAKE) dev/build && $(MAKE) dev/up
