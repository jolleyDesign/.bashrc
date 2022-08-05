# .bashrc

# setting simple custom PS1 user prompt
PS1="\w > "

# Source global definitions

# adding path to sbin directory
export PATH="$PATH:/sbin"
# adding path to android-studio
export PATH="$PATH:/home/jolley/tools/android-studio/bin/"

if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

neofetch

### aliases and functions set by @jolley

# easier and quicker exiting from terminal
alias x='exit'
# setting a global alias for topgrade (global upgrade suite) without putting in PATH
alias tgrade='sudo ~/tools/topgrade'
# making it easier to open something in gedit
alias ee='sudo gedit'
# check NetworkManager status (quickly)
alias netstatus='sudo systemctl status NetworkManager'
# opens file explorer to directory
alias explore='xdg-open'
# expanding the ll operation
alias ll='ls -lah'
# alias for opening android studio
alias studio='studio.sh'

# macchanger, with disabling and re-enabling of the interface
# first argument should be interface identifier (ex: wlo1, wlan0)
randmac() {
    sudo ifconfig $1 down
    sudo macchanger -r $1
    sudo ifconfig $1 up
}


# PRIVatize network information
# prereqs: Private Internet Access cli (piactl) and macchanger
# randomizes mac address using my randmac() function, and enables PIA VPN
# verbose information on IP and Mac before and after changes made
# first argument should be interface identifier (ex: wlo1, wlan1)
PRIV() {
	
	if [ $1 == "help" ]; then
		echo "First argument should be interface identifier (ex: wlo1, wlan1, etc). No other arguments should be provided."
		return 0
	elif [ -z "$1" ]; then
		echo "First argument should be interface identifier (ex: wlo1, wlan1, etc). No other arguments should be provided."
		return 0
	fi

	echo "Current IP conf: "
	ifconfig $1 | grep inet
	piactl connect
	randmac $1
	echo "Getting new IP information: "
	sleep 4
	piactl get pubip && piactl get vpnip
	ifconfig $1 | grep inet
}
