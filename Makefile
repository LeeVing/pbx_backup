olddir=~/dotfiles_old
files=bash_inc bashrc dockercfg fonts gnome \
      gitconfig gitignore_global git-prompt.sh  profile
default_repo=~/projects
default_apps=~/apps
default_scripts=~/scripts

all: init directories backup move

init:
	@read -p "What is your Gerrit username? " gerrit_username; \
	read -p "What is your full name (for Git)? " full_name; \
	read -p "What is your dev number [format: XX]? " dev_env; \
	read -p "Where do you keep your Git repos (Default: ~/projects)? " repo_path; \
	read -p "Where would you like to install apps managed by this tool (Default: ~/apps)? " app_path; \
	read -p "Where would you like to install bash scripts managed by this tool (Default: ~/scripts)? " script_path; \
	echo "$${repo_path:=$(default_repo)}"; \
	sed -i -e "s|<repo_path>|$${repo_path:=$(default_repo)}|g" \
	       -e "s|<app_path>|$${app_path:=$(default_apps)}|g" \
	       -e "s|<script_path>|$${script_path:=$(default_scripts)}|g" \
	       -e "s|<dev_env>|dev$${dev_env}|g" \
	       -e "s|<gerrit_username>|$${gerrit_username}|g" \
	    bashrc; \
	sed -i -e "s|<email>|$${gerrit_username}@coredial.com|g" -e "s|<full_name>|$${full_name}|g" gitconfig
	touch init

directories:
	echo "Creating $(olddir) for backup of any existing dotfiles in ~" ; \
	mkdir -p $(olddir) ; \
	echo "...done"
	touch directories

backup:
	echo "Moving any existing dotfiles from ~ to $(olddir)" ; \
	for file in $(files) ; do \
		if [ -f "$$file" ]; then \
			echo "Moving $$file to $(olddir)" ; \
			mv ~/.$$file $(olddir) 2>/dev/null ; \
		fi \
	done
	touch backup

backupConfigs:
	apm list --installed --bare > atom.packages.list ;

installConfigs:
	apm install `cat atom.packages.list` ;

move:
	for file in $(files) ; do \
		if [ ! -L "~/.$$file" ]; then \
			echo "Creating symlink to $$file in home directory." ; \
			ln -s `pwd`/$$file ~/.$$file ; \
		fi \
	done
	touch move

install:
	cd installs && $(MAKE)

create:
	for file in $(files) ; do \
		echo "Copying .$$file to $$file" ; \
		cp -r ~/.$$file . ; \
		mv .$$file $$file ; \
	done

global:
	sudo mkdir -p /etc/bash_inc
	sudo cp -Rfu ./bash_inc/* /etc/bash_inc
	echo 'if [ -f "/etc/bash_inc/global.sh" ]; then . "/etc/bash_inc/global.sh"; fi'  | sudo tee -a /root/.profile
