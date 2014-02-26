#!/bin/zsh

#essentials
alias dl='cd ~/dl'
alias rm='mv --target-directory ~/.trash'
alias neo='setxkbmap de neo'
alias jfg='setxkbmap de neo' # 'neo' written in neo on de ;)
alias de='setxkbmap de'
alias da='du -ach --max-depth=1'
alias dh='du -ch --max-depth=1'
alias du='du -ch'
alias df='df -h'
alias grepnc='grep -n --color=none'
alias grep='grep -n --color=auto'
alias ls='ls --color=always --group-directories-first'
alias lsa='ls -Ca --color=always --group-directories-first'
alias ll='ls -lh --color=always --group-directories-first' 
alias la='ls -la --color=always --group-directories-first'
alias lh='ls -lh --color=always --group-directories-first'
alias man="TERMINFO=~/.terminfo/ LESS=C TERM=mostlike PAGER=less man"

# alias -s
alias -s pdf='background mupdf'
alias -s {mkv,mpg}='background mplayer'
alias -s {jpg,png}='background qiv'

#os
alias pm='sudo pm-suspend'

#network
alias ifup='sudo wpa_supplicant -Dwext -iwlp3s0 -c/etc/wpa_supplicant/wpa_supplicant.conf -B && sudo dhcpcd wlp3s0'
alias ifupd='sudo wpa_supplicant -Dwext -iwlp3s0 -c/etc/wpa_supplicant/wpa_supplicant.conf -d && sudo dhcpcd wlan0'
alias ifdown='sudo wpa_cli terminate && sudo killall dhcpcd'
alias iwtop='sudo iftop -B -i wlp3s0'
alias ietop='sudo iftop -B -i enp0s25'

# arandr scripts
alias vga="sh ~/.screenlayout/vga_only.sh"
alias lvds="sh ~/.screenlayout/lvds_only.sh"
alias beam="sh ~/.screenlayout/beamer.sh"

#media
alias ncmphasi="ncmpcpp -h atlas.hasi" 
alias mplayer="mplayer -af scaletempo"
