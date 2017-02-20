**Fork this repo and make it your own!**

clone into home folder ~/

These scripts assume you will place all git repos in $home/projects 
and additional applications such as phpstorm in $home/apps

Search all files for <user_input> and change the values to your needs

files that have <user_input>:
* bashrc
* gitconfig
* wakatime.cfg
* gnome/apps/jetbrains-phpstorm.desktop
* gnome/apps/jetbrains-pycharm.desktop

run make from root directory

this will install the basics. create a new ssh key and add it to github and gerrit, then run the following:

 `
 cd installs/
 make programs
 make apps
 `
 
check the installs/makefile for list of programs apps and programs installs.

**BEFORE RUNNING MAKE DEV UPDATE THE gitBranch VARIABLE IN THE MAKEFILE!**

running make dev from installs will create the projects folder in home and 
download common git repos (chef, voiceaxis, ect..) also adds /projects/sync/ 
where you can run the sync-branch.sh which will pull all broadworks repos 
needed to whatever release specified. 