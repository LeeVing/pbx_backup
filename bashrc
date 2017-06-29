# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export ALTERNATE_EDITOR=""

# Tell grep to highlight matches
export TERM=xterm-256color

# Workaround for Intellij IDEA not liking old IBus versions
export IBUS_ENABLE_SYNC_MODE=1

# The parent directory of your git repos
export SRCHOME=<repo_path>

# The parent directory of your apps
export APPSHOME=<app_path>

# The parent directory of your scripts
export SCRIPTHOME=<script_path>

# Vagrant
export VAGRANT=$SRCHOME/chef-repo/resources/vagrant/environment
alias v="USER=<dev_env> COREDIAL_ENV=dev VAGRANT_CWD=${VAGRANT} vagrant"

# Dev Env Configs
export DEV_ENV=<dev_env>
export GERRIT_USERNAME=<gerrit_username>

# Docker env vars
export BW_PROV_AGENT_USERNAME=''
export BW_PROV_AGENT_PASSWORD=''
export SERVICE_PBX_DB_URL="mysql://service_pbx:dr0az3eh@<dev_env>-agents.dev.coredial.com/service_pbx"
export SERVICE_PBX_READONLY_PORTAL_URL="mysql://voiceaxis:dr0az3eh@<dev_env>-web.dev.coredial.com/voiceaxis"

BASH_INC="$HOME/.bash_inc"

if [ -f "$BASH_INC/colors.sh" ]; then
	. "$BASH_INC/colors.sh"
fi

if [ -f "$BASH_INC/alias.sh" ]; then
	. "$BASH_INC/alias.sh"
fi

if [ -f "$BASH_INC/exports.sh" ]; then
	. "$BASH_INC/exports.sh"
fi

if [ -f "$BASH_INC/git.sh" ]; then
	. "$BASH_INC/git.sh"
fi

if [ -f "$BASH_INC/venv.sh" ]; then
	. "$BASH_INC/venv.sh"
fi

if [ -f "$BASH_INC/prompt.sh" ]; then
	. "$BASH_INC/prompt.sh"
fi

eval `dircolors $BASH_INC/dircolors.sh`
