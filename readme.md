**Fork this repo and make it your own!**

# How to Use

## Configure Variables

Set the following variables in installs/Makefile

```sh
gitBranch - The Git branch to check out for dev updates
appsDir - The directory in which apps managed by this tool will be installed, defaults to ~/apps
sourcesDir - The parent directory of your Git repos, defaults to ~/projects
```

Run make from the base directory of this repo

```sh
make
```

This will install the basics.

Create a new SSH key, add it to Github and Gerrit, then run the following:

```sh
 cd installs/
 make programs
 make apps
```

Check installs/Makefile for a which apps are available for installation.

Running make dev from installs will create your sourcesDir folder if it does not exist and 
clone common git repos (chef, voiceaxis, etc..)

It also adds the sync/ dir which contains sync-branch.sh, used for updating all broadworks repos needed to a specified release.

