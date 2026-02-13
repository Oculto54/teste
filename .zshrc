#!/usr/bin/env zsh
# zmodload zsh/zprof
# =============================================================================
# Minimal Cross-Platform Zsh Configuration
# =============================================================================

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
# Platform-specific overrides (optional)
# =============================================================================

[[ -f "$HOME/.zsh-plataform" ]] && source "$HOME/.zsh-plataform"


# =============================================================================
# History
# =============================================================================
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE

setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups hist_find_no_dups

# =============================================================================
# Shell Settings
# =============================================================================
export EDITOR=nano

# LS Colors
if command -v dircolors &>/dev/null; then
  eval "$(dircolors -b)" 2>/dev/null
fi

export LS_COLORS="di=1;34:ln=1;36:so=1;35:pi=33:ex=1;32:bd=33;47:cd=33;47:su=37;41:sg=30;43:"

# =============================================================================
# Aliases
# =============================================================================

alias ..='cd ..'
alias ...='cd ../..'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias h='history'
alias c='clear'



# =============================================================================
# iTerm2 integration (source if present)
# =============================================================================
[[ -f "$HOME/.iterm2_shell_integration.zsh" ]] && source "$HOME/.iterm2_shell_integration.zsh"


# =============================================================================
# Zinit (lazy loaded)
# =============================================================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Clone zinit only if missing (skip check on subsequent loads)
if [[ ! -d "$ZINIT_HOME/.git" ]]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" 2>/dev/null
fi

# Load zinit
[[ -f "${ZINIT_HOME}/zinit.zsh" ]] && source "${ZINIT_HOME}/zinit.zsh"

# Load plugins (conditional)
if (( $+functions[zinit] )); then
  zinit light zsh-users/zsh-completions
  zinit light zsh-users/zsh-autosuggestions
  zinit light zsh-users/zsh-syntax-highlighting
  zinit ice depth=1; zinit light romkatv/powerlevel10k
fi

# Completions (cached for 24h)
autoload -Uz compinit
if [[ -f ~/.zcompdump ]]; then
  compinit -i -C  # Use cached
else
  compinit -i
fi
zinit cdreplay -q

# Powerlevel10k
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"


# zprof
