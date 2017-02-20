dir = ~/dotfiles
olddir = ~/dotfiles_old
files = bashrc bash_inc atom fonts gnome \
	PyCharm50 wakatime.cfg WebIde100 xonotic \
	profile gitconfig gitignore_global git-prompt.sh dockercfg


all: directories backup move install global

directories:
	echo "Creating $(olddir) for backup of any existing dotfiles in ~" ; \
	mkdir -p $(olddir) ; \
	echo "...done"
	touch directories

backup:
	echo "Moving any existing dotfiles from ~ to $(olddir)" ; \
	for file in $(files) ; do \
		echo "Moving $$file to $(olddir)" ; \
		mv ~/.$$file $(olddir) 2>/dev/null ; \
	done

backupConfigs:
	apm list --installed --bare > atom.packages.list ;

installConfigs:
	apm install `cat atom.packages.list` ;

move:
	cd $(dir) ; \
	for file in $(files) ; do \
		echo "Creating symlink to $$file in home directory." ; \
		ln -s $(dir)/$$file ~/.$$file ; \
	done
	. ~/.profile
	touch move

install:
	cd installs && $(MAKE)

create:
	cd $(dir) ; \
	for file in $(files) ; do \
		echo "Copying .$$file to $(dir)/$$file" ; \
		cp -r ~/.$$file $(dir) ; \
		mv $(dir)/.$$file $(dir)/$$file ; \
	done

global:
	sudo mkdir -p /etc/bash_inc
	sudo cp -Rfu ./bash_inc/* /etc/bash_inc
	echo 'if [ -f "/etc/bash_inc/global.sh" ]; then . "/etc/bash_inc/global.sh"; fi'  | sudo tee -a /root/.profile
