
# Dark 256 color solarized theme for the color GNU ls utility.
# Used and tested with dircolors (GNU coreutils) 8.5
#
# @author  {@link http://sebastian.tramp.name Sebastian Tramp}
# @license http://sam.zoy.org/wtfpl/  Do What The Fuck You Want To Public License (WTFPL)
#
# More Information at
# https://github.com/seebi/dircolors-solarized

# Term Section
TERM Eterm
TERM ansi
TERM color-xterm
TERM con132x25
TERM con132x30
TERM con132x43
TERM con132x60
TERM con80x25
TERM con80x28
TERM con80x30
TERM con80x43
TERM con80x50
TERM con80x60
TERM cons25
TERM console
TERM cygwin
TERM dtterm
TERM dvtm
TERM dvtm-256color
TERM eterm-color
TERM fbterm
TERM gnome
TERM gnome-256color
TERM jfbterm
TERM konsole
TERM konsole-256color
TERM kterm
TERM linux
TERM linux-c
TERM mach-color
TERM mlterm
TERM putty
TERM putty-256color
TERM rxvt
TERM rxvt-256color
TERM rxvt-cygwin
TERM rxvt-cygwin-native
TERM rxvt-unicode
TERM rxvt-unicode256
TERM rxvt-unicode-256color
TERM screen
TERM screen-16color
TERM screen-16color-bce
TERM screen-16color-s
TERM screen-16color-bce-s
TERM screen-256color
TERM screen-256color-bce
TERM screen-256color-s
TERM screen-256color-bce-s
TERM screen-256color-italic
TERM screen-bce
TERM screen-w
TERM screen.linux
TERM screen.xterm-256color
TERM st
TERM st-meta
TERM st-256color
TERM st-meta-256color
TERM tmux
TERM tmux-256color
TERM vt100
TERM xterm
TERM xterm-16color
TERM xterm-256color
TERM xterm-256color-italic
TERM xterm-88color
TERM xterm-color
TERM xterm-debian
TERM xterm-termite

## Documentation
#
# standard colors
#
# Below are the color init strings for the basic file types. A color init
# string consists of one or more of the following numeric codes:
# Attribute codes:
# 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
# Text color codes:
# 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
# Background color codes:
# 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
#
#
# 256 color support
# see here: http://www.mail-archive.com/bug-coreutils@gnu.org/msg11030.html)
#
# Text 256 color coding:
# 38;5;COLOR_NUMBER
# Background 256 color coding:
# 48;5;COLOR_NUMBER

## Special files

NORMAL 00;38;5;255 # no color code at all
#FILE 00 # regular file: use no color at all
RESET 0 # reset to "normal" color
DIR 00;38;5;39 # directory 01;34
LINK 00;38;5;87 # symbolic link. (If you set this to 'target' instead of a
 # numerical value, the color is as for the file pointed to.)
MULTIHARDLINK 00 # regular file with more than one link
FIFO 48;5;230;38;5;136;01 # pipe
SOCK 48;5;230;38;5;136;01 # socket
DOOR 48;5;230;38;5;136;01 # door
BLK 48;5;230;45;5;244;01 # block device driver
CHR 48;5;230;45;5;244;01 # character device driver
ORPHAN 48;5;247;38;5;196 # symlink to nonexistent file, or non-stat'able file
SETUID 48;5;160;38;5;230 # file that is setuid (u+s)
SETGID 48;5;136;38;5;230 # file that is setgid (g+s)
CAPABILITY 30;41 # file with capability
STICKY_OTHER_WRITABLE 48;5;64;38;5;230 # dir that is sticky and other-writable (+t,o+w)
OTHER_WRITABLE 48;5;235;38;5;33 # dir that is other-writable (o+w) and not sticky
STICKY 48;5;33;38;5;230 # dir with the sticky bit set (+t) and not other-writable
# This is for files with execute permission:
EXEC 00;38;5;164

## Archives or compressed (violet + bold for compression)
.tar    00;38;5;141
.tgz    00;38;5;141
.arj    00;38;5;141
.taz    00;38;5;141
.lzh    00;38;5;141
.lzma   00;38;5;141
.tlz    00;38;5;141
.txz    00;38;5;141
.zip    00;38;5;141
.z      00;38;5;141
.Z      00;38;5;141
.dz     00;38;5;141
.gz     00;38;5;141
.lz     00;38;5;141
.xz     00;38;5;141
.bz2    00;38;5;141
.bz     00;38;5;141
.tbz    00;38;5;141
.tbz2   00;38;5;141
.tz     00;38;5;141
.deb    00;38;5;141
.rpm    00;38;5;141
.jar    00;38;5;141
.rar    00;38;5;141
.ace    00;38;5;141
.zoo    00;38;5;141
.cpio   00;38;5;141
.7z     00;38;5;141
.rz     00;38;5;141
.apk    00;38;5;141
.gem    00;38;5;141

# Image formats (yellow)
.jpg    00;38;5;208
.JPG    00;38;5;208 #stupid but needed
.jpeg   00;38;5;208
.gif    00;38;5;208
.bmp    00;38;5;208
.pbm    00;38;5;208
.pgm    00;38;5;208
.ppm    00;38;5;208
.tga    00;38;5;208
.xbm    00;38;5;208
.xpm    00;38;5;208
.tif    00;38;5;208
.tiff   00;38;5;208
.png    00;38;5;208
.PNG    00;38;5;208
.svg    00;38;5;208
.svgz   00;38;5;208
.mng    00;38;5;208
.pcx    00;38;5;208
.dl     00;38;5;208
.xcf    00;38;5;208
.xwd    00;38;5;208
.yuv    00;38;5;208
.cgm    00;38;5;208
.emf    00;38;5;208
.eps    00;38;5;208
.CR2    00;38;5;208
.ico    00;38;5;208

# Files of special interest (base1)
.txt             00;38;5;226
.tex             00;38;5;226
.rdf             00;38;5;226
.owl             00;38;5;226
.n3              00;38;5;226
.ttl             00;38;5;226
.nt              00;38;5;226
.torrent         00;38;5;226
.xml             00;38;5;226
*Rakefile        00;38;5;226
*build.xml       00;38;5;226
*rc              00;38;5;226
.nfo             00;38;5;226
.c               00;38;5;226
.cpp             00;38;5;226
.cc              00;38;5;226
.sqlite          00;38;5;226
.go              00;38;5;226
.csv             00;38;5;226

# dev files (green)
.py              00;38;5;48
.php             00;38;5;48
.js              00;38;5;48
.html            00;38;5;48
.sql             00;38;5;48
.apib            00;38;5;48
*Makefile        00;38;5;48
*Dockerfile      00;38;5;48
*README          00;38;5;48
*README.txt      00;38;5;48
*readme.txt      00;38;5;48
.md              00;38;5;48
*README.markdown 00;38;5;48
.ini             00;38;5;48
.yml             00;38;5;48
.json            00;38;5;48
.cfg             00;38;5;48
.conf            00;38;5;48


# "unimportant" files as logs and backups (base01)
*1          00;38;5;246
.log        00;38;5;246
.bak        00;38;5;246
.old        00;38;5;246
.aux        00;38;5;246
.lof        00;38;5;246
.lol        00;38;5;246
.lot        00;38;5;246
.out        00;38;5;246
.toc        00;38;5;246
.bbl        00;38;5;246
.blg        00;38;5;246
*~          00;38;5;246
*#          00;38;5;246
.part       00;38;5;246
.incomplete 00;38;5;246
.swp        00;38;5;246
.tmp        00;38;5;246
.temp       00;38;5;246
.o          00;38;5;246
.pyc        00;38;5;246
.class      00;38;5;246
.cache      00;38;5;246

# Audio formats (orange)
.aac    00;38;5;166
.au     00;38;5;166
.flac   00;38;5;166
.mid    00;38;5;166
.midi   00;38;5;166
.mka    00;38;5;166
.mp3    00;38;5;166
.mpc    00;38;5;166
.ogg    00;38;5;166
.opus   00;38;5;166
.ra     00;38;5;166
.wav    00;38;5;166
.m4a    00;38;5;166
# http://wiki.xiph.org/index.php/MIME_Types_and_File_Extensions
.axa    00;38;5;166
.oga    00;38;5;166
.spx    00;38;5;166
.xspf   00;38;5;166

# Video formats (as audio + bold)
.mov    00;38;5;214
.MOV    00;38;5;214
.mpg    00;38;5;214
.mpeg   00;38;5;214
.m2v    00;38;5;214
.mkv    00;38;5;214
.ogm    00;38;5;214
.mp4    00;38;5;214
.m4v    00;38;5;214
.mp4v   00;38;5;214
.vob    00;38;5;214
.qt     00;38;5;214
.nuv    00;38;5;214
.wmv    00;38;5;214
.asf    00;38;5;214
.rm     00;38;5;214
.rmvb   00;38;5;214
.flc    00;38;5;214
.avi    00;38;5;214
.fli    00;38;5;214
.flv    00;38;5;214
.gl     00;38;5;214
.m2ts   00;38;5;214
.divx   00;38;5;214
.webm   00;38;5;214
# http://wiki.xiph.org/index.php/MIME_Types_and_File_Extensions
.axv 00;38;5;166
.anx 00;38;5;166
.ogv 00;38;5;166
.ogx 00;38;5;166

