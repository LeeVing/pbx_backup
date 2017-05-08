olddir=~/dotfiles_old
files=bash_inc bashrc dockercfg fonts gnome \
      gitconfig gitignore_global git-prompt.sh  profile

all: init directories backup move install global

init:
	read -p "What is your Coredial email address (for Git)? " email; \
	read -p "What is your full name (for Git)? " full_name; \
	read -p "Where do you keep your Git repos (full path please)? " repo_path; \
	read -p "Where would you like to install apps managed by this tool (full path please)? " app_path; \
	read -p "Where would you like to install scripts managed by this tool (full path please)? " script_path; \
	read -p "What is your dev number [in format devXX] or username? " dev_env; \
	read -p "What is your lab Broadworks username? " bw_lab_username; \
	read -p "What is your lab Broadworks password? " bw_lab_password; \
	read -p "What is your Gerrit username? " gerrit_username; \
	sed -i -e "s/<repo_path>/$$repo_path/g" \
	       -e "s/<app_path>/$$app_path/g" \
	       -e "s/<script_path>/$$script_path/g" \
	       -e "s/<dev_env>/$$dev_env/g" \
	       -e "s/<bw_lab_username>/$$bw_lab_username/g" \
	       -e "s/<bw_lab_password>/$$bw_lab_password/g" \
	       -e "s/<gerrit_username>/$$gerrit_username/g" \
	    bashrc; \
	sed -i -e "s/<email>/$$email/g" -e "s/<full_name>/$$full_name/g" gitconfig; \
	sed -i -e "s/<username>/$(whoami)/g" gnome/apps/*; \
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
	. ~/.profile
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
