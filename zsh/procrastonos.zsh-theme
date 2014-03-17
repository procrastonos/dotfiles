function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '○'
}

#colors
local red_b="%{$fg_bold[red]%}"
local red="%{$fg[red]%}"
local yellow_b="%{$fg_bold[yellow]%}"
local yellow="%{$fg[yellow]%}"
local blue_b="%{$fg_bold[blue]%}"
local blue="%{$fg[blue]%}"
local green_b="%{$fg_bold[green]%}"
local green="%{$fg[green]%}"
local magenta_b="%{$fg_bold[magenta]%}"
local magenta="%{$fg[magenta]%}"
local cyan_b="%{$fg_bold[cyan]%}"
local cyan="%{$fg[cyan]%}"

local r="%{$reset_color%}"

if [ `id -u` -eq "0" ]; then
    user_color="${red_b}"
    host_color="${blue_b}"
elif [ ! -d /var/chroot ]; then
    user_color="${green_b}"
    host_color="${red_b}"
else
    user_color="${yellow_b}"
    host_color="${blue_b}"
fi

local blue_op="${blue}[${r}"
local blue_cp="${blue}]${r}"

#PROMPT="%F{gray}
#╭─╼%f
#[%B${user}%n%f%b]
#[%B%F${domain}%M%f%b]─
#[%F{green}%B%d%b%f]
#%F{gray}╰─╼ %f"

local path_full="${green_b}%d${r}"
local user="${user_color}%n${r}"
local host="${host_color}%m${r}"
local ret_status="${magenta_b}%?${r}"
local hist_no="${cyan_b}%h${r}"
local smiley="%(?,${green_b}:%)${r},${red_b}:(${r})"
local cur_cmd="%_"

ZSH_THEME_GIT_PROMPT_PREFIX="${blue}git${r} ${red_b}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${r}"
ZSH_THEME_GIT_PROMPT_DIRTY="${r} ${yellow}✗${r}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="${green_b}?"
ZSH_THEME_GIT_PROMPT_CLEAN="${r}"

#PROMPT='╭─ $(prompt_char) ${user} ${host} ${ret_status} ${hist_no} ${path_full}% ${cur_cmd} $(git_prompt_info)
#╰─ ${smiley} '

PROMPT='╭─ $(prompt_char) ${user} ${host} ${path_full}% ${cur_cmd} $(git_prompt_info)
╰─ ${smiley} '

PROMPT2="${cur_cmd}> "
RPROMPT="%F{green}%*%f"
