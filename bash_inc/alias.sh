#!/usr/bin/env bash


#dirsize - finds directory sizes and lists them for the current directory
dirsize ()
{
du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
egrep '^ *[0-9.]*M' /tmp/list
egrep '^ *[0-9.]*G' /tmp/list
rm -rf /tmp/list
}

if [ "$(uname)" == "Darwin" ]; then
    alias ls='ls'
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    alias ls='ls --color=auto'
    alias grep='grep  --color=auto --exclude=*\.svn*'
    alias fgrep='fgrep --color=auto --exclude=*\.svn*'
    alias egrep='egrep --color=auto --exclude=*\.svn*'
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
fi


alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias edit='subl'                           # edit:         Opens any file in sublime editor
alias ~="cd ~"                              # ~:            Go Home
alias which='type -all'                     # which:        Find executables
#   lr:  Full Recursive Directory Listing
#   ------------------------------------------
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

#   cpuHogs:  Find CPU hogs
#   -----------------------------------------------------
    alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

#   my_ps: List processes owned by my user:
#   ------------------------------------------------------------
    my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }

#   ---------------------------
#   6.  NETWORKING
#   ---------------------------

alias myip='curl ip.appspot.com'                    # myip:         Public facing IP Address
alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

COREDIAL_LOCAL=true

if [[ -n "$COREDIAL_LOCAL" ]]; then
	alias v="USER=${DEV_ENV} COREDIAL_ENV=dev VAGRANT_CWD=${VAGRANT} vagrant"
	alias vp="v provision"
	alias vssh="v ssh"
	alias vup="v up"
	alias vdest="v destroy"
	alias vstat="v status"
	alias vdir="cd ~/projects/chef-repo/resources/vagrant"
else
	alias vp="vagrant provision"
	alias vssh="vagrant ssh"
	alias vup="vagrant up"
	alias vdest="vagrant destroy"
	alias vstat="vagrant status"
fi


#   ii:  display useful host related informaton
#   -------------------------------------------------------------------
    ii() {
        echo -e "\nYou are logged on ${RED}$HOST"
        echo -e "\nAdditionnal information:$NC " ; uname -a
        echo -e "\n${RED}Users logged on:$NC " ; w -h
        echo -e "\n${RED}Current date :$NC " ; date
        echo -e "\n${RED}Machine stats :$NC " ; uptime
        echo -e "\n${RED}Current network location :$NC " ; scselect
        echo -e "\n${RED}Public facing IP Address :$NC " ;myip
        #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
        echo
    }

alias vfix-api="fix-api-web"
alias kc='kubectl --kubeconfig=./kube_config'
