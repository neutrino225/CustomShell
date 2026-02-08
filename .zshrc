# --- Powerlevel10k instant prompt (Must stay at the absolute top) ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Zinit setup ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# --- Compinit (Optimized) ---
autoload -Uz compinit
compinit -u
# Periodic cleanup of zcompdump to prevent bloat
[ $(find ~/.zcompdump* -mtime +1) ] && rm -f ~/.zcompdump*

# --- Theme & Prompt ---
zinit ice depth=1
zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- Plugins ---
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# OMZ snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Syntax highlighting (MUST be last)
zinit light zsh-users/zsh-syntax-highlighting

# --- History Settings (Corruption Prevention) ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY          # Append instead of overwrite
setopt INC_APPEND_HISTORY      # Write to file immediately after command execution
setopt SHARE_HISTORY           # Share history across sessions
setopt HIST_IGNORE_DUPS        # Don't record consecutive duplicates
setopt HIST_IGNORE_SPACE       # Don't record lines starting with a space
setopt HIST_REDUCE_BLANKS      # Tidy up the history file
setopt HIST_SAVE_NO_DUPS       # Don't save duplicates to the file
setopt HIST_VERIFY             # Let user edit history expansion before running

# --- Key Bindings ---
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# --- Completion Styling ---
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# FZF integration
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# --- Aliases ---
alias ls='eza --group-directories-first --color=auto --icons'
alias ll='eza -l --group-directories-first --color=auto --icons'
alias la='eza -la --group-directories-first --color=auto --icons'
alias lt='eza -T --level=2 --group-directories-first --color=auto --icons'
alias lg='eza -l --git --group-directories-first --color=auto --icons'
alias c='clear'
alias ag='antigravity'

# --- Tools & Environments ---
eval "$(zoxide init --cmd cd zsh)"
eval "$(mise activate zsh)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Conda
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

# --- PATH & Exports ---
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/cuda-13.0/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda-13.0/lib64:$LD_LIBRARY_PATH"
export PATH="/home/neutrino/.opencode/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "/home/neutrino/.bun/_bun" ] && source "/home/neutrino/.bun/_bun"
