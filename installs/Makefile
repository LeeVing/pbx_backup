aptRepo = sudo add-apt-repository -y
aptUpdate = $(call run, update, sudo apt-get update)
npm = sudo npm install -g
pycharm = pycharm-professional-2017.1.4
phpstorm = PhpStorm-2017.1.4
gitBranch = release/5.31.0
BLUE=\033[1;34m
NC=\033[0m

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

OK_STRING=$(OK_COLOR)[OK]$(NO_COLOR)
ERROR_STRING=$(ERROR_COLOR)[ERRORS]$(NO_COLOR)
WARN_STRING=$(WARN_COLOR)[WARNINGS]$(NO_COLOR)

AWK_CMD = awk '{ printf "%-5s %-30s %-10s\n", $$1, $$2, $$3; }'
PRINT_ERROR = printf "$(BLUE)$@ $(1) $(ERROR_STRING)\n" | $(AWK_CMD) && printf "$(ERROR_COLOR)$(CMD)\n$$LOG\n$(NO_COLOR)" && false
PRINT_WARNING = printf "$(BLUE)$@ $(1) $(WARN_STRING)\n" | $(AWK_CMD) && printf "$(WARN_COLOR)$(CMD)\n$$LOG\n$(NO_COLOR)"
PRINT_OK = printf "$(BLUE)$@ $(1) $(OK_STRING)\n" | $(AWK_CMD)
BUILD_CMD = LOG=$$($(CMD) 2>&1) ; if [ $$? -eq 1 ]; then $(PRINT_ERROR); elif [ "$$LOG" != "" ] ; then $(PRINT_WARNING); else $(PRINT_OK); fi;

define aptInstall
	$(call run, install, sudo apt-get install -y $(1))
endef

define dpkgInstall
	$(call run, install, sudo dpkg --install $(1))
endef

define section
	@echo "$(BLUE)--- Running $@$(1)---$(NC)"
endef

define run
	$(call section,$(1))
	LOG=$$($(2) 3>&1 1>&2 2>&3) ; if [ $$? -eq 1 ]; then $(PRINT_ERROR); elif [ "$$LOG" != "" ] ; then $(PRINT_WARNING); else $(PRINT_OK); fi;
endef

all: update basics scripts programs dev/sync

programs: composer node virtual virtualenvwrapper docker-compose

apps: chrome phpstorm pycharm hipchat sublime atom

dev: dev/sync dev/envup

update:
	$(aptUpdate)
	touch update

basics: update
	$(section)
	$(call aptInstall, curl wget git pv)
	touch basics

mksrcdir:
	$(section)
	mkdir -p $(SRCHOME)
	touch mksrcdir

mkappsdir:
	$(section)
	mkdir -p $(APPSHOME)
	touch mkappsdir

mkbindir:
	$(section)
	mkdir -p $(SCRIPTHOME)
	touch mkbindir

video: update
	$(section)
	$(call aptInstall, nvidia-current-updates)

php: basics
	$(section)
	$(aptRepo) ppa:ondrej/php
	$(aptUpdate)
	$(call aptInstall, php5.6)
	$(call aptInstall, php5.6-cli)
	$(call aptInstall, php5.6-curl)
	$(call aptInstall, php5.6-mysql)
	$(call aptInstall, php5.6-pgsql)
	$(call aptInstall, php5.6-sqlite)
	touch php

composer: php
	$(section)
	curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
	touch composer

ruby: basics
	$(section)
	sudo apt-add-repository -y ppa:brightbox/ruby-ng; \
	sudo apt-get update; \
	sudo apt-get install -y ruby2.2 ruby2.2-dev; \

node: basics
	$(section)
	curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
	$(call aptInstall, nodejs)
	touch node

scripts: mkbindir
	$(section)
	cp dev_scripts/* $(SCRIPTHOME)
	chmod +x $(SCRIPTHOME)/*
	mkdir -p $(SRCHOME)/sync
	cp -f dev_scripts/* $(SRCHOME)/sync
	chmod +x $(SRCHOME)/sync/*
	touch scripts

node/aglio: node
	$(section)
	$(npm) aglio

atom: basics
	$(section)
	wget https://atom-installer.github.com/v1.6.0/atom-amd64.deb
	$(call dpkgInstall, atom-amd64.deb)
	rm atom-amd64.deb
	apm install `cat ../atom.packages.list`
	touch atom

emacs: basics
	$(section)
	$(call aptInstall, build-essential) ; \
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
	$(section)
	mv ~/.emacs.d ~/old_emacs_d
	git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

byobu:
	$(section)
	$(call aptInstall, byobu)
	touch byobu

gitreview:
	$(section)
	$(call aptInstall, git-review)
	touch gitreview

virtual:
	$(section)
	$(call aptInstall, virtualbox)
	touch virtual

pip:
	$(section)
	$(call aptInstall, python-pip python-dev)
	$(call run, update, sudo pip install --upgrade pip)
	touch pip

virtualenvwrapper: pip
	$(section)
	sudo pip install virtualenv
	sudo pip install virtualenvwrapper
	echo "source ~/.bashrc to activate virtualenvwrapper"
	touch virtualenvwrapper

docker:
	$(section)
	wget -qO- https://get.docker.com/ | sh
	sudo service docker start
	touch docker
	sudo usermod -aG docker $$(whoami)
	echo "please logout and log back in before using Docker"

docker-compose: docker pip
	$(section)
	 sudo pip install docker-compose
	 touch docker-compose

kubectl:
	$(section)
	curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
	sudo mv kubectl /usr/local/bin
	sudo chmod +x /usr/local/bin/kubectl
	touch kubectl

chrome: update
	$(section)
	$(call aptInstall, libxss1 libappindicator1 libindicator7)
	wget -nv https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	$(call dpkgInstall, google-chrome*.deb)
	rm google-chrome*.deb
	touch chrome

jdk:
	$(section)
	sudo apt-get purge openjdk*
	$(call aptRepo) ppa:webupd8team/java
	$(aptUpdate)
	echo 'debconf shared/accepted-oracle-license-v1-1 select true' | sudo debconf-set-selections
	echo 'debconf shared/accepted-oracle-license-v1-1 seen true' | sudo debconf-set-selections
	$(call aptInstall, oracle-java8-installer)
	touch jdk

compass:
	$(section)
	sudo gem install compass -v 0.12.7

filewatch:
	$(section)
	echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
	touch filewatch

phpstorm: mkappsdir jdk filewatch
	$(section)
	cd $(APPSHOME) ; \
		wget http://download-cf.jetbrains.com/webide/$(phpstorm).tar.gz ; \
		pv $(phpstorm).tar.gz | tar xzf - ; \
		rm $(phpstorm).tar.gz ;
		cd $(APPSHOME)/PhpStorm-*/bin ; \
			./phpstorm.sh
	touch phpstorm

pycharm: mkappsdir jdk filewatch
	$(section)
	cd $(APPSHOME) ; \
		wget https://download-cf.jetbrains.com/python/$(pycharm).tar.gz ; \
		tar -xvf $(pycharm).tar.gz ; \
		rm $(pycharm).tar.gz ;
		cd pycharm-*/bin ; \
			./pycharm.sh
	touch pycharm

hipchat:
	$(section)
	sudo sh -c 'echo "deb [arch=amd64] https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client $$(lsb_release -c -s) main" > /etc/apt/sources.list.d/atlassian-hipchat4.list'
	wget -O - https://atlassian.artifactoryonline.com/atlassian/api/gpg/key/public | sudo apt-key add -
	$(aptUpdate)
	$(call aptInstall hipchat4)
	touch hipchat

sublime:
	$(section)
	$(aptRepo) ppa:webupd8team/sublime-text-3
	$(aptUpdate)
	$(call aptInstall, sublime-text-installer)
	touch sublime

fonts:
	$(section)
	[ -d /usr/share/fonts/opentype ] || sudo mkdir /usr/share/fonts/opentype
	sudo git clone https://github.com/adobe-fonts/source-code-pro.git /usr/share/fonts/opentype/scp
	sudo fc-cache -f -v
	touch fonts

chefplugins:
	$(section)
	vagrant plugin install rack buff-extensions --plugin-version "<2.0"
	touch chefplugins

ssh_key:
	$(section)
	if [ ! -f ~/.ssh/id_rsa ] ; \
	then \
		ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa ; \
	fi;
	touch ssh_key

dev/sync: mksrcdir ssh_key
	$(section)
	echo "please add your public ssh key to gerrit." ; \
	echo "" ; \
	cat ~/.ssh/id_rsa.pub ; \
	echo "" ; \
	read -p "Press [ENTER] when complete. or ctrl-c now and rerun make" ent ;
	cd $(SRCHOME)/sync && bash sync-branch.sh -f --branch $(gitBranch)
	touch dev/sync

dev/envup: dev/sync node docker-compose
	$(section)
	sed -i -e 's|"revision": "develop"|"revision": "$(gitBranch)"|g' $(SRCHOME)/chef-repo/environments/dev.json
	$(call section, vagrant)
	v up chef_server sbc app_mq1 web api_web agents ; \
	cd $(SRCHOME)/sync && bash fix-api-web
	$(call section, docker)
	cd $(SRCHOME)/sync && bash sync-branch.sh --branch $(gitBranch) ; \
	cd $(SRCHOME)/service-pbx && $(MAKE) dev/build && $(MAKE) dev/database/upgrade && $(MAKE) dev/up
