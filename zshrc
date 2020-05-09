HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

export VISUAL="vim"
export EDITOR="vim"

export LANG=en_US.UTF-8
#export LC_ALL=en_US.UTF-8
export LC_CTYPE="en_US.UTF-8"
export TERM="xterm-256color"


#Antigen
source /opt/antigen/antigen.zsh
antigen theme bhilburn/powerlevel9k powerlevel9k
#antigen theme romkatv/powerlevel10k

# Plugins
source /opt/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/zsh-autosuggestions/zsh-autosuggestions.zsh
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator history time battery)
POWERLEVEL9K_BATTERY_ICON=$'\uF240'
POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_USER_ROOT_ICON=$'\uF198'


#PROMPT='%F{red}%1~%f %# '
#RPROMPT='%F{green}%*'
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


zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix
# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'


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
    ls -lacf
}
chpwd_functions=(${chpwd_functions[@]} "list_all")

# some more ls aliases
alias ls="ls -G"
alias la='ls -A'
alias l='ls -CF'
# taken from https://natelandau.com/my-mac-osx-bash_profile/
alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
alias less='less -FSRXc'                    # Preferred 'less' implementation
#cd() { builtin cd "$@"; ll -FGlAhp; }       # Always list directory contents upon 'cd'
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias which='type -a'                     # which:        Find executables
#alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
alias myip='curl ip.appspot.com'                    # myip:         Public facing IP Address
alias gpull='git pull --rebase && git submodule update --init --recursive'

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
    *.xz)	 xz -d $1	;;
    *)     echo "'$1' cannot be extracted via extract()" ;;
     esac
 else
     echo "'$1' is not a valid file"
 fi
}



function subl {
  if [ "$1" != "" ]; then
    sublime $1
  else
    sublime $PWD
  fi
}

function signapk {
  if [ "$1" != "" ]; then
    jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ~/.androkey/my-release-key.keystore $1 key
  else
    echo "Please add apk file as arg 1"
  fi
}    


#alias
alias reload='source ~/.zshrc'
alias ghidra="/opt/ghidra_9.0.4/ghidraRun &"
alias bytecodeviwer="java -jar /opt/Bytecode-Viewer*"
alias lsof="lsof -n"
alias top="htop"

