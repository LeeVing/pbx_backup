aptInstall = sudo apt-get install -y
aptRepo = sudo add-apt-repository -y
aptUpdate = sudo apt-get update
npm = sudo npm install -g
pycharm = pycharm-professional-2016.2.3
phpstorm = PhpStorm-2016.3.2
hipchat = HipChat4-4.28.0.1659-Linux
gitBranch = release/5.26.0
vag = USER=$(DEV_ENV) COREDIAL_ENV=dev VAGRANT_CWD=${VAGRANT} vagrant

all: update basics

programs: composer node atom virtual docker-compose compass

apps: chrome phpstorm pycharm hipchat sublime

dev: dev/sync dev/chef dev/voiceaxis dev/envup

update:
	$(aptUpdate)
	touch update

basics: update
	$(aptInstall) curl wget git
	touch basics

video: update
	$(aptInstall) nvidia-current-updates

php: basics
	$(aptInstall) php5-cli
	$(aptInstall) php5-curl
	$(aptInstall) php5-mysql
	$(aptInstall) php5-pgsql
	$(aptInstall) php5-sqlite
	touch php

composer: php
	curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
	touch composer

node: basics
	curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
	$(aptInstall) nodejs
	sudo ln -s /usr/bin/nodejs /usr/bin/node
	touch node

node/aglio: node
	$(npm) aglio

atom: basics
	wget https://atom-installer.github.com/v1.6.0/atom-amd64.deb
	sudo dpkg --install atom-amd64.deb
	sudo rm atom-amd64.deb
	apm install `cat ../atom.packages.list`
	touch atom

virtual:
	$(aptInstall) virtualbox
	touch virtual

docker:
	wget -qO- https://get.docker.com/ | sh
	sudo service docker start
	sudo usermod -aG docker $(whoami)
	touch docker

docker-compose: docker
	 $(aptInstall) python-pip
	 sudo pip install docker-compose
	 sudo usermod -aG docker $(whoami)
	 echo "please logout in order to run docker"
	 touch docker-compose

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

~/apps:
	mkdir -p ~/apps

filewatch:
	echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
	touch filewatch

phpstorm: ~/apps jdk filewatch
	cd ~/apps ; \
		wget http://download-cf.jetbrains.com/webide/$(phpstorm).tar.gz ; \
		tar -xvf $(phpstorm).tar.gz ; \
		rm $(phpstorm).tar.gz ; \
		cd PhpStorm-*/bin ; \
			./phpstorm.sh ; \
	touch phpstorm

pycharm: ~/apps jdk filewatch
	cd ~/apps ; \
		wget https://download-cf.jetbrains.com/python/$(pycharm).tar.gz ; \
		tar -xvf $(pycharm).tar.gz ; \
		rm $(pycharm).tar.gz ; \
		cd pycharm-*/bin ; \
			./pycharm.sh
	touch pycharm

hipchat:
	wget https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client/pool/$(hipchat).deb
	sudo dpkg -i $(hipchat).deb
	rm $(hipchat).deb
	touch hipchat

sublime:
	$(aptRepo) ppa:webupd8team/sublime-text-3
	$(aptUpdate)
	$(aptInstall) sublime-text-installer
	touch sublime

~/projects:
	mkdir -p ~/projects

dev/sync: ~/projects
	mkdir -p ~/projects/sync
	cp -f sync-branch.sh ~/projects/sync/

chefpulgins:
	vagrant plugin install rack buff-extensions --plugin-version "<2.0"
	touch chefpulgins

dev/chef: ~/projects chefpulgins
	cd ~/projects ; \
		if [ -d "~/Dropbox" ]; then echo "Dir exists"; fi
		if [ ! -d "chef-repo" ]; then git clone git@github.com:CoreDial/chef-repo.git; fi ; \
		cd chef-repo ; \
			git checkout origin/$(gitBranch) -b $(gitBranch)

dev/voiceaxis: ~/projects
	cd ~/projects ; \
		git clone git@github.com:CoreDial/voiceaxis.git ; \
		cd voiceaxis ; \
			git checkout origin/$(gitBranch) -b $(gitBranch)

dev/envup: dev/chef dev/sync
	$(vag) up chef_server web api_web agents app_mq1 app_mq2
	cd ~/projects/sync && bash sync-branch.sh --branch $(gitBranch)
	cd ~/projects/service-pbx && $(MAKE) dev/build && $(MAKE) dev/up
