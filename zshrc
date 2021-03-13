# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
export VISUAL="vim"
export EDITOR="vim"
export LC_CTYPE="en_US.UTF-8"
export TERM="xterm-256color"

build_dir="/opt"

# https://github.com/xxh/xxh
# https://github.com/xxh/xxh-plugin-zsh-powerlevel10k
# Antigen
# Installed - https://github.com/zsh-users/antigen
source $build_dir/antigen.zsh
#antigen theme bhilburn/powerlevel9k powerlevel9k
antigen theme romkatv/powerlevel10k

# Plugins
# highlighting in - https://github.com/zsh-users/zsh-syntax-highlighting
source $build_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# autocomplete - https://github.com/zsh-users/zsh-autosuggestions
source $build_dir/zsh-autosuggestions/zsh-autosuggestions.zsh
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator history time battery)
POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_USER_ROOT_ICON=$'\uF198'
antigen apply

#Othersls
bindkey -e

setopt appendhistory
setopt autocd
setopt nobeep
setopt extendedglob
setopt nomatch
setopt notify
setopt share_history
setopt histignorespace
setopt globdots
setopt NO_CASE_GLOB
setopt EXTENDED_HISTORY
setopt CORRECT
setopt CORRECT_ALL

unsetopt nomatch

# Completions
autoload -Uz compinit
compinit

set LSCOLORS
export CLICOLOR=1
export CLICOLOR_FORCE=1

bindkey  "^[[1~"  beginning-of-line
bindkey  "^[[4~"  end-of-line
bindkey  "^[[3~"  delete-char
bindkey	 "^[[H"   beginning-of-line
bindkey	 "^[[F"   end-of-line

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix
# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:low
er:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Up from history
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

bindkey "\e[1;3D" backward-word
bindkey "\e[1;3C" forward-word

function list_all() {
    emulate -L zsh
    ls -la --color=always
}
chpwd_functions=(${chpwd_functions[@]} "list_all")

#   extract:  Extract most know archives with one command
#   ---------------------------------------------------------
extract () {
if [ -f $1 ] ; then
  case $1 in
    *.tar.bz2)   tar xjf $1     ;;
    *.tar.gz)    tar xzf $1     ;;
    *.bz2)       bunzip2 $1     ;;
    *.rar)       unrar e $1     ;;
    *.gz)        gunzip $1      ;;
    *.tar)       tar xf $1      ;;
    *.tbz2)      tar xjf $1     ;;
    *.tgz)       tar xzf $1     ;;
    *.zip)       unzip $1       ;;
    *.Z)         uncompress $1  ;;
    *.7z)        7z x $1        ;;
    *.xz)        xz -d $1       ;;
    *)     echo "'$1' cannot be extracted via extract()" ;;
     esac
 else
     echo "'$1' is not a valid file"
 fi
}


# signing APKs
function signapk {
  if [ "$1" != "" ]; then
    jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ~/.androkey/my-release-key.keystore $1 key
  else
    echo "Please add apk file as arg 1"
  fi
}

# Source aliases
source $build_dir/.zsh_alias

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $build_dir/.p10k.zsh ]] || source $build_dir/.p10k.zsh

sudo run-parts /etc/update-motd.d
