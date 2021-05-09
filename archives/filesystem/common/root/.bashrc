#!/usr/bin/env bash
# ubuntu
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
# If not running interactively, don't do anything
PROMPT_COMMAND=prompt;

case $- in
	*i*) ;;
	*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color|*-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then

	function prompt(){
		TEMPERATURE=$(cat /sys/class/thermal/thermal_zone0/temp)
		RESULT=$(echo -e "scale=1;($TEMPERATURE/1000)"|bc)"°"
		LEFT_PROMPT="\[$(tput setaf 5;)\]\u@\h\[$(tput sgr0;)\]:\[$(tput setaf 12;)\]\w\[$(tput sgr0;)\]"
		RIGHT_PROMPT="\[$(tput setaf 4;)\]|\$(date +'%T')|$RESULT|\[$(tput sgr0;)\]"
		GIT_BRANCH="\[$(tput setaf 60;)\]$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/')\[$(tput sgr0;)\]"
		#MEMFREE="$(awk '/MemFree/{print $2}' /proc/meminfo)"
		PS1="${debian_chroot:+($debian_chroot)}$LEFT_PROMPT$RIGHT_PROMPT$GIT_BRANCH# \[$(tput setaf 4;)\]\[$(tput sgr0;)\]\[$(tput setaf 240;)\]"
	}

else
	PS1="${debian_chroot:+($debian_chroot)}\u@\h:\w\""

fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="${STOP};${debian_chroot:+($debian_chroot)}\u@\h: \w\a$PS1"
		;;
	*)
		;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias dir='dir --color=auto'
	alias dmesg='dmesg --color=auto'
	alias egrep='egrep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias gcc='gcc -fdiagnostics-color=auto'
	alias grep='grep --color=always'
	alias ls='ls --color=auto'
	alias pacman='pacman --color=auto'
	alias vdir='vdir --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

#alias bat='bat --theme="The New"'
#alias batup='bat cache --build'

# functions

# regexopt
function reo (){
	string="poseidon|son|poison|sonic"
	regex=$(regex-opt $string);
	output="(?:$regex)"
	echo "$output"
	echo -e "$(tput bold;)Size: $(tput sgr0;)$(tput setaf 85;)${#regex}$(tput sgr0;)$(tput setaf 83;)Byte"
	res="${output//[^:]}"
	echo -e "$(tput setaf 81;)Non capturing group:$(tput sgr0;) $(tput smul; tput setaf 29)${#res}$(tput sgr0;)"
}

# node regexgen
function regn (){
	string="poseidon son poison sonic"
	regex=$(regexgen $string);
	echo -e ${regex//\//}
	echo -e "$(tput bold;)Size: $(tput sgr0;)$(tput setaf 237;)${#regex}Byte$(tput sgr0;)"
	res="${regex//[^:]}"
	echo -e "$(tput setaf 8;)$(tput bold;)Non capturing group:$(tput sgr0;)$(tput setaf 237;) ${#res}"
}

# building transmission
function tbuild () {
	echo -e "$(tput setaf 210;)Installing necessary packages$(tput sgr0;)$(tput setaf 239;)"
	apt install cmake libcurl4-gnutls-dev zlib1g-dev libevent-dev gcc nasm libssl-dev -y

	cd ../tmp || exit
	dir_name="build"

	if [ -d $dir_name ]
	then
		echo -e "$(tput setaf 72;)Entering to '$dir_name' directory$(tput sgr0;)$(tput setaf 239;)"
		cd $dir_name
	else
		echo -e "$(tput setaf 72;)Creating and entering to '$dir_name' directory$(tput sgr0;)$(tput setaf 239;)"
		mkdir $dir_name && cd $dir_name
	fi

	directory_name="Transmission"

	if [ -d $directory_name ]
	then
		rm -r $directory_name
		echo "$(tput setaf 9;)Removing '$directory_name' directory$(tput sgr0;)$(tput setaf 239;)"
elif [ ! -d $directory_name ]
	then
		echo "$(tput setaf 73;)Directory '$directory_name' will be made $(tput sgr0;)$(tput setaf 239;)"
	else
		rm -r $directory_name
		echo "Removing old '$directory_name' directory"
	fi

	git clone https://github.com/transmission/transmission Transmission && cd Transmission && git submodule update --init && mkdir build && cd build && cmake .. && make -j && cp daemon/transmission-daemon /usr/local/bin

}

# building mozjpeg
function mbuild () {
	echo -e "$(tput setaf 210;)Installing necessary packages$(tput sgr0;)$(tput setaf 239;)"
	apt install gcc nasm cmake libpng-dev -y
	cd ../tmp || exit
	dir_name="build"

	if [ -d $dir_name ]
	then
		echo -e "$(tput setaf 72;)Entering to '$dir_name' directory$(tput sgr0;)$(tput setaf 239;)"
		cd $dir_name
	else
		echo -e "$(tput setaf 72;)Creating and entering to '$dir_name' directory$(tput sgr0;)$(tput setaf 239;)"
		mkdir $dir_name && cd $dir_name
	fi

	directory_name="mozjpeg"

	if [ -d $directory_name ]
	then
		rm -r $directory_name
		echo "$(tput setaf 9;)Removing old '$directory_name' directory$(tput sgr0;)$(tput setaf 239;)"
elif [ ! -d $directory_name ]

	then
		echo "$(tput setaf 73;)Directory '$directory_name' will be made $(tput sgr0;)$(tput setaf 239;)"
	else
		rm -r $directory_name
		echo "Removing old '$directory_name' directory"
	fi

	git clone https://github.com/mozilla/mozjpeg && cd mozjpeg && cmake -G"Unix Makefiles" && make -j && cp jpegtran-static /usr/local/bin

}

# building brunsli
function bbuild () {
	echo -e "$(tput setaf 210;)Installing necessary packages$(tput sgr0;)$(tput setaf 239;)"
	cd ../tmp || exit
	dir_name="build"

	if [ -d $dir_name ]
	then
		echo -e "$(tput setaf 72;)Entering to '$dir_name' directory$(tput sgr0;)$(tput setaf 239;)"
		cd $dir_name
	else
		echo -e "$(tput setaf 72;)Creating and entering to '$dir_name' directory$(tput sgr0;)$(tput setaf 239;)"
		mkdir $dir_name && cd $dir_name
	fi

	directory_name="brunsli"

	if [ -d $directory_name ]
	then
		rm -r $directory_name
		echo "$(tput setaf 9;)Removing old '$directory_name' directory$(tput sgr0;)$(tput setaf 239;)"
elif [ ! -d $directory_name ]

	then
		echo "$(tput setaf 73;)Directory '$directory_name' will be made $(tput sgr0;)$(tput setaf 239;)"
	else
		rm -r $directory_name
		echo "Removing old '$directory_name' directory"
	fi

	git clone --depth=1 https://github.com/google/brunsli.git && cd brunsli && git submodule update --init --recursive && mkdir bin && cd bin && cmake .. && make -j && cp cbrunsli /usr/local/bin && cp dbrunsli /usr/local/bin

}

# building oxipng
function obuild () {
	cd ../tmp || exit
	dir_name="build"
	apt install cargo -y

	if [ -d $dir_name ]
	then
		echo -e "$(tput setaf 72;)Entering to '$dir_name' directory$(tput sgr0;)$(tput setaf 239;)"
		cd $dir_name

	else
		echo -e "$(tput setaf 72;)Creating and entering to '$dir_name' directory$(tput sgr0;)$(tput setaf 239;)"
		mkdir $dir_name && cd $dir_name
	fi

	directory_name="oxipng"

	if [ -d $directory_name ]
	then
		rm -r $directory_name
		echo "$(tput setaf 9;)Removing old '$directory_name' directory$(tput sgr0;)$(tput setaf 239;)"
elif [ ! -d $directory_name ]

	then
		echo "$(tput setaf 73;)Directory '$directory_name' will be made $(tput sgr0;)$(tput setaf 239;)"
	else
		rm -r $directory_name
		echo "Removing old '$directory_name' directory"
	fi

	git clone https://github.com/shssoichiro/oxipng.git && cd oxipng && cargo build --release && cp target/release/oxipng /usr/local/bin

}

# building regex-opt
function rbuild () {
	echo -e "$(tput setaf 210;)Installing necessary packages$(tput sgr0;)$(tput setaf 239;)"
	apt install make g++ -y

	cd ../tmp || exit
	dir_name="build"
	if [ -d $dir_name ]
	then
		echo -e "$(tput setaf 72;)Entering to '$dir_name' directory$(tput sgr0;)$(tput setaf 239;)"
		cd $dir_name
	else
		echo -e "$(tput setaf 72;)Creating and entering to '$dir_name' directory$(tput sgr0;)$(tput setaf 239;)"
		mkdir $dir_name && cd $dir_name
	fi

	directory_name="regex-opt"

	if [ -d $directory_name ]
	then
		rm -r $directory_name
		echo "$(tput setaf 9;)Removing '$directory_name' directory$(tput sgr0;)$(tput setaf 239;)"
elif [ ! -d $directory_name ]
	then
		echo "$(tput setaf 73;)Directory '$directory_name' will be made $(tput sgr0;)$(tput setaf 239;)"
	else
		rm -r $directory_name
		echo "Removing old '$directory_name' directory"
	fi

	git clone git://bisqwit.iki.fi/regex-opt.git && cd regex-opt && sudo make -j && cp regex-opt /usr/local/bin

}

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

# cd with la
function cl() {
	DIR="$*";
	# if no DIR given, go home
	if [ $# -lt 1 ]; then
		DIR=$HOME;
	fi;
	builtin cd "${DIR}" && \
		# use your preferred ls command
	ls -F --color=auto
}

function hlp (){
	read line <&1;
	echo -e "${line} --help > /tmp/help.txt | textastic /tmp/help.txt" < /dev/stdin
}

function help (){
	echo -e "$(tput setaf 146;)What package help you need?$(tput sgr0;)";
	read help_name
	${help_name} --help > /tmp/$help_name.hlp | textastic /tmp/$help_name.hlp;
}

function hostname (){
	echo -e "$(tput setaf 146;)Enter new hostname here$(tput sgr0;)";
	read hostname;
	sed -i "s/.*/"$hostname"/g" /etc/hostname
}

function soft(){
	apt update && apt upgrade -y && apt install iperf3 lighttpd pixz ruby-full samba shellcheck transmission-daemon python3-pip -y && pip3 install beautysh && curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash - && sudo apt install -y nodejs && npm install -g npm@latest regexgen regexp-tree browserify prettier && npm install regexgen regexp-tree tinyify && curl -L https://cpanmin.us | perl - --sudo App::cpanminus && cpanm --self-upgrade --sudo && cpanm Regexp::Optimizer Regexp::Trie Regex::PreSuf Perl::Tidy && gem ins regexp_optimized_union && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && ln -s /usr/bin/python3 /usr/bin/python 2> /dev/null;
}

# samba passwdord
function samba() {
	pass=ghost;
	(echo "$pass"; echo "$pass") | smbpasswd -s -a $(whoami);
}

# lighttod stop
function lstop() {
if systemctl --quiet is-active lighttpd;
	then systemctl stop lighttpd && echo -e $(tput setaf 103;)"lighttpd" $(tput sgr0;)$(tput setaf 9;)"stopping"$(tput sgr0;);
else
	systemctl status lighttpd | grep -q inactive && echo -e $(tput setaf 103;)"lighttpd" $(tput sgr0;)$(tput setaf 3;)"already" $(tput sgr0;)$(tput setaf 9;)"stopped"$(tput sgr0;);
fi
}

# lighttpd start
function lstart() {
if systemctl --quiet is-active lighttpd;
	then systemctl restart lighttpd && echo -e $(tput setaf 103;)"lighttpd" $(tput sgr0;)$(tput setaf 3;)"already running:" $(tput sgr0;)$(tput setaf 2;)"restarting"$(tput sgr0;);
else
	systemctl status lighttpd | grep -q inactive && systemctl start lighttpd && echo -e $(tput setaf 103;)"lighttpd" $(tput sgr0;)$(tput setaf 2;)"starting"$(tput sgr0;);
fi
}

# ssh stop
function sshstop() {
if systemctl --quiet is-active sshd;
	then systemctl stop sshd && echo -e $(tput setaf 103;)"ssh" $(tput sgr0;)$(tput setaf 9;)"stopping"$(tput sgr0;);
else
	systemctl status sshd | grep -q inactive && echo -e $(tput setaf 103;)"ssh" $(tput sgr0;)$(tput setaf 3;)"already" $(tput sgr0;)$(tput setaf 9;)"stopped"$(tput sgr0;);
fi
}

# ssh start
function sshstart() {
if systemctl --quiet is-active sshd;
	then systemctl restart ssh && echo -e $(tput setaf 103;)"ssh" $(tput sgr0;)$(tput setaf 3;)"already running:" $(tput sgr0;)$(tput setaf 2;)"restarting"$(tput sgr0;);
else
	systemctl status sshd | grep -q inactive && systemctl start sshd && echo -e $(tput setaf 103;)"ssh" $(tput sgr0;)$(tput setaf 2;)"starting"$(tput sgr0;);
fi
}

# samba stop
function sstop() {
if systemctl --quiet is-active smbd;
	then systemctl stop smbd && echo -e $(tput setaf 103;)"samba" $(tput sgr0;)$(tput setaf 9;)"stopping"$(tput sgr0;);
else
	systemctl status smbd | grep -q inactive && echo -e $(tput setaf 103;)"samba" $(tput sgr0;)$(tput setaf 3;)"already" $(tput sgr0;)$(tput setaf 9;)"stopped"$(tput sgr0;);
fi
}

# samba start
function sstart() {
if systemctl --quiet is-active smbd;
	then systemctl restart smbd && echo -e $(tput setaf 103;)"samba" $(tput sgr0;)$(tput setaf 3;)"already running:" $(tput sgr0;)$(tput setaf 2;)"restarting"$(tput sgr0;);
else
	systemctl status smbd | grep -q inactive && systemctl start smbd && echo -e $(tput setaf 103;)"samba" $(tput sgr0;)$(tput setaf 2;)"starting"$(tput sgr0;);
fi
}

# transmission start
function tstart() {
if systemctl --quiet is-active transmission-daemon;
	then systemctl restart transmission-daemon && echo -e $(tput setaf 103;)"transmission" $(tput sgr0;)$(tput setaf 3;)"already running:" $(tput sgr0;)$(tput setaf 2;)"restarting"$(tput sgr0;);
else
	systemctl status transmission-daemon | grep -q inactive && systemctl start transmission-daemon && echo -e $(tput setaf 103;)"transmission" $(tput sgr0;)$(tput setaf 2;)"starting"$(tput sgr0;);
fi
}

# transmission stop
function tstop() {
if systemctl --quiet is-active transmission-daemon;
	then systemctl stop transmission-daemon && echo -e $(tput setaf 103;)"transmission" $(tput sgr0;)$(tput setaf 9;)"stopping"$(tput sgr0;);
else
	systemctl status transmission-daemon | grep -q inactive && echo -e $(tput setaf 103;)"transmission" $(tput sgr0;)$(tput setaf 3;)"already" $(tput sgr0;)$(tput setaf 9;)"stopped"$(tput sgr0;);
fi
}

function list() {
	dpkg-query -f '${binary:Package}\n' -W  && dpkg-query -f '${binary:Package}\n' -W | wc -l;
}

function sft() {
	PKG="lighttpd pixz ruby-full samba shellcheck transmission-daemon python3-pip pixz"
if	dpkg-query -l "$PK" > /dev/null || sudo apt install $PKG -y;
then echo -e $(tput setaf 103;)"$PKG"$(tput sgr0;) $(tput setaf 2;)"already installed"$(tput sgr0;)	&& pip3 install beautysh && curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash - && sudo apt install -y nodejs && npm install -g npm@latest regexgen regexp-tree browserify prettier && npm install regexgen regexp-tree tinyify && curl -L https://cpanmin.us | perl - --sudo App::cpanminus && cpanm --self-upgrade --sudo && cpanm Regexp::Optimizer Regexp::Trie Regex::PreSuf Perl::Tidy && gem ins regexp_optimized_union && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && ln -s /usr/bin/python3 /usr/bin/python 2> /dev/null;
fi
}

function df() {
	command df -h | GREP_COLORS="mt=38;5;242" grep -E "([0-9][G|M])|" | GREP_COLORS="mt=38;5;189" grep -E "(tmpfs)|$" | GREP_COLORS="mt=38;5;181" grep -E "(udev)|$" | GREP_COLORS="mt=38;5;104" grep -E "(\/dev\/mmcblk[0-9])|$" | GREP_COLORS="mt=00;32" grep -P "(\s\d%)|([0-4][0-9]%)|$" | GREP_COLORS="mt=38;5;183" grep -E "(\/dev\/(sd[a-z][0-9])|\/dev\/(sd[a-z]))|$" | GREP_COLORS="mt=00;31" grep -E "([8-9][0-9]100%)|$" | GREP_COLORS="mt=38;5;220" grep -E "([5-7][0-9]%)|$";
}

function mkcd()
{
  mkdir -p -- "$1" && cd -P -- "$1"
}

function noty() {
	notify "ghost" "$(command -p date)"
}

function shell() {
	shellcheck -f diff .bashrc > bash.diff | textastic bash.diff
}

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# scripts aliases
alias 256='256.sh'
alias bro='browserify.sh'
alias bru='brunsli.sh'
alias bsh='beautysh.sh'
alias burn='burn.sh'
alias col='color.sh'
alias css='css.sh'
alias csso='csso.sh'
alias font='fontname.py'
alias moz='mozjpeg.sh'
alias opng='oxipng.sh'
alias pi='pip3 install'
alias pipup='pip3 install --upgrade pip'
alias rp='regex-presuf.pl'
alias rps='stty -icanon && regex-presuf-stdin.pl && textastic /tmp/regexp.re 2> /dev/null'
alias regexgenpy='python /usr/local/lib/python3.8/dist-packages/regexgen/regex.py'
alias regpy='regexgen.py'
alias ro='regexp-optimizer.pl'
alias rou='regexp-optimized-union.rb'
alias rt='regexp-trie.pl'
alias sre='python /usr/local/lib/python3.8/dist-packages/sre_yield/sre.py'
alias svgo='svgo.sh'

#chmod some dir & folders
alias chm='chmod +x scripts/*'

#find
alias find='find -iname'

# miscellaneous
#alias df='df -h | GREP_COLORS="mt=38;5;242" grep -E "([0-9][G|M])|$"  | GREP_COLORS="mt=38;5;189" grep -E "(tmpfs)|$" | GREP_COLORS="mt=38;5;181" grep -E "(udev)|$" | GREP_COLORS="mt=38;5;104" grep -E "(\/dev\/mmcblk[0-9])|$"  | GREP_COLORS="mt=00;32" grep -P "(\s\d%)|([0-4][0-9]%)|$" | GREP_COLORS="mt=38;5;183" grep -E "(\/dev\/(sd[a-z][0-9])|\/dev\/(sd[a-z]))|$" | GREP_COLORS="mt=00;31" grep -E "([8-9][0-9]100%)|$" | GREP_COLORS="mt=38;5;220" grep -E "([5-7][0-9]%)|$"'
alias c='clear'
alias cat='batcat --paging=never'
alias clh='sort .bash_history | uniq >> .bash_history'
alias cll='shopt -s dotglob | rm -rfv /var/log/*'
alias clt='shopt -s dotglob | rm -rfv /tmp/*'
alias cpv='rsync -ah --info=progress2'
alias disk='lsblk | GREP_COLORS="mt=38;5;189" grep -E "(├─|└─|sda|sda[0-9])|$"'
alias dist='lsb_release -a | GREP_COLORS="mt=38;5;189" grep -E "(Distributor ID|Description|Release|Codename)|$" | GREP_COLORS="mt=38;5;101" grep -P "(\:\s.*$)"'
alias fenix='which do-fenix-full-upgrade && apt update && apt full-upgrade && do-fenix-full-upgrade'
alias h='htop'
alias ip='ip -c'
alias iperf='iperf3 -s -D && echo -e $(tput setaf 103;)"server" $(tput sgr0;) $(tput setaf 2;)"started"$(tput sgr0;)'
alias last='cat /var/log/dpkg.log* | GREP_COLORS="mt=38;5;3" grep -Po "\b(?<=installed)\b(.*)(?<=:)" | sort -t: -u -k1,1'
alias po='poweroff'
alias ports='netstat -tulanp'
alias rd='rm -r'
alias re='reboot'
alias rsr='dd if=/tmp/zero of=/dev/null bs=4k count=100000'
alias rss='dd if=/dev/zero of=/var/log/zero bs=4k count=100000'
alias temp='grep "[0-9]" /sys/class/thermal/thermal_zone0/temp'
alias tsmb='testparm -s /etc/samba/smb.conf'
alias u='cd ..'
alias un='uname -a'
alias wsr='dd if=/dev/zero of=/tmp/zero bs=4k count=100000'

# help
alias hlp='--help > /tmp/help.txt | textastic /tmp/help.txt'

# archives
alias 7z='p7zip -d -k'
alias gzc='gzip -f'
alias gzd='gzip -fd'
alias tarc='tar -zcvf'
alias tard='tar -zxvf'
alias xzd='pixz -d -p 6'

# shortcut  for iptables and pass it via sudo#
alias ipt='sudo /sbin/iptables'

# clipboard
alias setclip="xclip -selection c"
alias getclip="xclip -selection c -o"

# npm
alias ni='npm install'
alias nig='npm install -g'
alias nr='npm remove'
alias nu='npm update'
alias nug='npm update -g'

# git
alias gc='git clone'

# make
alias make='make -j'

# app versions
alias bv='bash --version'
alias cv='cmake --version'
alias lv='lighttpd -V'
alias mozv='jpegtran-static -version'
alias npmv='npm -v'
alias nv='node -v'
alias ov='oxipng -V'
alias perlv='perl -v'
alias pipv='pip3 --version'
alias rubyv='ruby -v'
alias rustv='rustc --version'
alias smbv='samba -V'
alias sshv='ssh –V'
alias tv='transmission-daemon -V'

# prettier
alias pjs='prettier --write --use-tabs --single-quote --no-bracket-spacing'

# display all rules
alias firewall=iptlist
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'

# apt aliases
alias ai='apt install'
alias fup='sudo sed -i 's/focal/hirsute/g' /etc/apt/sources.list && apt -qq update && apt -qq full-upgrade'
alias ar='apt remove'
alias up='apt -qq update && apt -qq upgrade -y && apt -qq autoremove -y'

# secureshell
alias shs='sharesheet'

# perl shell
alias cpan='perl -MCPAN -e shell'

# Add an "alert" alias for long running commands.  Use like so:
# sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# different input color
#trap 'printf "\e[0m" "$_"' DEBUG

# Enter to specific directory
#cd "$HOME"/sandbox
LC_CTYPE=en_US.UTF-8
export DISPLAY=:0
# System-wide variable
export PATH="$PATH:$HOME/scripts/"
# grep colors
export GREP_COLORS='ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'
# colored LC
export LS_COLORS='rs=0:di=01;95:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*.json=01;93:*.js=01;93:*.css=01;93:*.md=01;93:*.html=00;93:*.rb=00;93:*.py=00;93:*.pl=00;93:*.sh=00;93:*.re=00;93:*.ttf=01;35:'

test -e "$HOME/.shellfishrc" && source "$HOME/.shellfishrc"
source "$HOME/.cargo/env"
