# --- Force compinit in unsafe mode (must be first) ---

autoload -Uz compinit
compinit -u
rm -f ~/.zcompdump*  

# --- Powerlevel10k instant prompt (must be at top) ---

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Zinit setup ---

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
mkdir -p "$(dirname $ZINIT_HOME)"
git clone [https://github.com/zdharma-continuum/zinit.git](https://github.com/zdharma-continuum/zinit.git) "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# --- Theme & prompt ---

zinit ice depth=1
zinit light romkatv/powerlevel10k

# --- Plugins (light ones first) ---

zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# --- OMZ snippets ---

zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# --- Powerlevel10k config ---

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- Syntax highlighting (must be last plugin) ---

zinit light zsh-users/zsh-syntax-highlighting

# --- Key bindings ---

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# --- History settings ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
HISTDUP=erase
setopt appendhistory share_history hist_ignore_space hist_ignore_dups hist_save_no_dups hist_find_no_dups extendedhistory

# --- Completion styling ---

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Load fzf key-bindings and completion if available

[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh

# --- Aliases ---

alias ls='eza --group-directories-first --color=auto --icons'
alias ll='eza -l --group-directories-first --color=auto --icons'
alias la='eza -la --group-directories-first --color=auto --icons'
alias lt='eza -T --level=2 --group-directories-first --color=auto --icons'
alias lg='eza -l --git --group-directories-first --color=auto --icons'
alias c='clear'
alias ag='antigravity'

# --- FZF integration ---
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init --cmd cd zsh)"

# --- NVM ---

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# --- PATH ---

export PATH="$HOME/.local/bin:$PATH"

# --- Conda initialize ---

# !! Contents within this block are managed by 'conda init' !!

__conda_setup="$('/home/neutrino/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
eval "$__conda_setup"
else
if [ -f "/home/neutrino/miniconda3/etc/profile.d/conda.sh" ]; then
. "/home/neutrino/miniconda3/etc/profile.d/conda.sh"
else
export PATH="/home/neutrino/miniconda3/bin:$PATH"
fi
fi
unset __conda_setup

# --- Mise environment (if installed) ---

eval "$(mise activate zsh)"
export PATH=/usr/local/cuda-13.0/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-13.0/lib64:$LD_LIBRARY_PATH

# opencode
export PATH=/home/neutrino/.opencode/bin:$PATH

# bun completions
[ -s "/home/neutrino/.bun/_bun" ] && source "/home/neutrino/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
