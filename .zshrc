# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="${ZSH:-${HOME}/.oh-my-zsh}"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# N.B. Using powerlevel10k below
# ZSH_THEME="robbyrussell"

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
plugins=(git brew macos colored-man-pages github docker)

source $ZSH/oh-my-zsh.sh

# By default this is run in the iTerm2 on macOS and the brew plugin form OMZ
# should set the ${HOMEBREW_PREFIX}.  But allow this to be used in a docker
# container like https://github.com/pkryger/docker-images/tree/master/emacs
_prefix=${HOMEBREW_PREFIX:-/opt/nix}

if [ -f ${_prefix}/share/powerlevel10k/powerlevel10k.zsh-theme ]; then
    source ${_prefix}/share/powerlevel10k/powerlevel10k.zsh-theme
else
    echo "Missing powerlevel10k. Install it with 'brew install powerlevel10k'"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
_emacs="${_prefix}/bin/emacs -nw --init-directory=~/.emacs-sanity"
_emacsclient="${_prefix}/bin/emacsclient -t -a "'"'${_emacs}'"'
export ALTERNATE_EDITOR=vi
export EDITOR=${_emacsclient}       # $EDITOR should open in terminal
export VISUAL=${HOME}/bin/emacs     # $VISUAL opens in GUI mode
export HOMEBREW_EDITOR=emacs

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias e=${_emacs}
alias ec=${_emacsclient}
# emacs all night
alias emcas=emacs
alias emasc=emacs
alias eamcs=emacs

alias ls="gls --color=auto"

alias pstation='caffeinate -dis                                                                                         \
                    ssh -t -l pkryger -p 222 192.168.1.67                                                               \
                    env PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/syno/sbin:/usr/syno/bin:/usr/local/sbin:/usr/local/bin  \
                        TERM=xterm-256color                                                                             \
                        SHELL=/usr/local/bin/zsh                                                                        \
                        /usr/local/bin/zsh -l'

if type brew &>/dev/null; then
  FPATH=${_prefix}/share/zsh-completions:${_prefix}/share/zsh/site-functions:${FPATH}

  autoload -Uz compinit
  compinit
fi

export PATH=~/bin:${PATH}

export BAT_THEME="Monokai Extended Light"

eval "$(direnv hook zsh)"

# From installing perl modules in local::lib
# PATH="/Users/pkryger/perl5/bin${PATH:+:${PATH}}"; export PATH;
# PERL5LIB="/Users/pkryger/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
# PERL_LOCAL_LIB_ROOT="/Users/pkryger/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
# PERL_MB_OPT="--install_base \"/Users/pkryger/perl5\""; export PERL_MB_OPT;
# PERL_MM_OPT="INSTALL_BASE=/Users/pkryger/perl5"; export PERL_MM_OPT;

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

if type toe &>/dev/null; then
    [[ $(toe | grep xterm-24bit) ]] && export TERM=xterm-24bit
fi

if [ -f ${_prefix}/share/zsh-autopair/autopair.zsh ]; then
    source ${_prefix}/share/zsh-autopair/autopair.zsh
else
    echo "Missing zsh-autopair. Install it with 'brew install zsh-autopair'"
fi

if [ -f ${_prefix}/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source ${_prefix}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
    echo "Missing zsh-autosuggestions. Install it with 'brew install zsh-autosuggestions'"
fi

# zsh-fast-syntax-highlighting needs to be added after
# zsh-autosuggestions. Otherwise, command highlighting is not updated when a
# suggestion is accepted (for example with C-e or C-f).
if [ -f ${_prefix}/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]; then
    source ${_prefix}/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
else
    echo "Missing zsh-fast-syntax-highlighting. Install it with 'brew install zsh-fast-syntax-highlighting'"
fi
