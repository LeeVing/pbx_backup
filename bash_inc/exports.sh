#!/usr/bin/env bash

export HISTIGNORE='&:cd:ls:bin/ss;history *'
export HISTCONTROL='ignoreboth'
export CLICOLOR=1
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS="di=1;34;40:ln=1;36;40:so=1;32;40:pi=1;33;40:ex=1;31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=1;0;42:ow=34;43:"
export BLOCKSIZE=1k

#export ENV_STATUS=''
export ENV_STATUS='local'
#export ENV_STATUS='dev'
#export ENV_STATUS='prod'