#!/usr/bin/env bash

BASH_INC="/etc/bash_inc"

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

if [ -f "$BASH_INC/prompt.sh" ]; then
	. "$BASH_INC/prompt.sh"
fi

eval `dircolors $BASH_INC/dircolors.sh`