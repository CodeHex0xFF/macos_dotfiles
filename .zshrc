# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions  fast-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
LOCALIP=$(ifconfig en0 | grep '\<inet\> ' | cut -d' ' -f2)
export PATH=$PATH:/opt/homebrew/bin
source ~/.cargo/env
_ssh() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="$(cat ${HOME}/.ssh/config | awk '/Host \w+/{print $2}' | xargs)"
    if [[ ${cur} == * ]]; then
        COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
        return 0
    fi
    COMPREPLY=( $(compgen -f -- "$cur") )
    return 0
}
_ws(){
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="$(cat ${HOME}/.repo | xargs)"
    if [[ ${cur} == * ]]; then
        COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
        return 0
    fi
    COMPREPLY=( $(compgen -f -- "$cur") )
    return 0
}

Kill(){
    TASKID=($(ps -a | cut -d' ' -f1,7 | sed '1d' | fzf))
    kill -s KILL  ${TASKID[1]}
}

complete -F _ssh ssh
complete -F _ws ws

ws() {
	  git clone ssh://repo/sw/"$1"
}

ws2push(){
    scp -r "$1" workstation@ws2:/home/workstation/workspace/sdk3.0
}

ws2pull(){
    scp -r workstation@ws2:/home/workstation/workspace/sdk3.0/$1 $(pwd)
}

ws2c(){
    ssh ws2 -- "$@"
}

ws1c(){
    ssh ws1 -- "$@"
}

sw1(){
    ssh ws1
}

sw2(){
    ssh ws2
}

tzr(){
if [ $# -eq 2 ] ; then
case "$1" in
    *.zip)
zip -r "$1" "$2"
        ;;
*.tar.gz)
  tar cvzf "$1" "$2"
;;
*.7z) 7z a "$1" "$2"
  ;;
*.tar.xz)
  tar cvJf "$1" "$2"
  ;;
*.rar)
  rar a "$1" "$2" ;;
*)
esac
elif [ $# -eq 1 ] ; then
 case "$1" in
*.tar.gz)
  tar xvzf "$1"
;;
*.7z) 7z x "$1"
  ;;
*.tar.xz)
  tar xvJf "$1";;
*.rar)
  rar x "$1" ;;
*.zip)
    unzip "$1";;
*)
esac
else
    echo "Usage: tzr [ filename.compressed] [ filename]"
fi
}

wk(){
    cd /Volumes/macbookdisk
}

if [ ${LOCALIP} = "192.168.8." ] ; then
  ssh repo 2>/dev/null | cut -f2 | cut -d'/' -f2 | sed '1d' | grep -v '^sw' | grep '\w\+' > ${HOME}/.repo
fi

export PATH=${PATH}:/Users/hongdayu/workspace/scripts
eval "$(zoxide init zsh)"
alias vim='/opt/homebrew/bin/nvim'
alias nvim='neovide'
alias ws1-vim='neovide --neovim-bin="ssh ws1 -- nvim" >/dev/null 2>/dev/null &'
alias ws2-vim='neovide --neovim-bin="ssh ws2 -- nvim" >/dev/null 2>/dev/null &'
alias lwv1='neovide --neovim-bin="ssh lan-ws1 -- nvim" >/dev/null 2>/dev/null &'
alias icat='kitty +kitten icat'
alias explore='open $(pwd)'
alias ssh='kitty +kitten ssh'
alias ss='/usr/bin/ssh'
alias cd='z'
alias code='/Applications/Visual\ Studio\ Code.app/Contents/MacOS/Electron >/dev/null 2>/dev/null &'
alias ws1='ssh ws1'
alias ws2='ssh ws2'
alias  kd='kitty +kitten diff'
export EDITOR=/opt/homebrew/bin/nvim
