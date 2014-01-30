# Use vim keybindings
bindkey -v
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.

function zle-line-init () {
    if (( ${+terminfo[smkx]} )); then
        echoti smkx
    fi
}
function zle-line-finish () {
    if (( ${+terminfo[rmkx]} )); then
        echoti rmkx
    fi
}

zle -N zle-line-init
zle -N zle-line-finish

bindkey "\e[3~" delete-char
bindkey "\e[H"  beginning-of-line
bindkey "\e[F"  end-of-line
bindkey "\e[5~" up-line-or-history
bindkey "\e[6~" down-line-or-history

HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.histfile
setopt append_history
setopt share_history
unsetopt beep
setopt interactivecomments

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

### display runtime for every command running at least 10 s

note_remind=0
note_ignore="yes"
note_command="?"

note_report() {
    echo "'$note_command completed in' $1 seconds"
}

preexec() {
    if [ "x$TTY" != "x" ]; then
        note_remind="$SECONDS"
        note_ignore=""
        note_command="$2"
    fi
}

precmd()
{
    local xx
    if [ "x$TTY" != "x" ]; then
        if [ "x$note_ignore" = "x" ]; then
            note_ignore="yes"
            xx=$(($SECONDS-$note_remind))
            if [ $xx -gt 10 ]; then
                if [ $TTYIDLE -gt 10 ]; then
                    note_report $xx
                fi
            fi
        fi
    fi
}

compctl -K moxpoints mox
compctl -K moxpoints umox

unsetopt correct_all 

eval "$(fasd --init auto)"
fortune -s
