# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# https://github.com/ohmyzsh/ohmyzsh/issues/8205
ZSH_DISABLE_COMPFIX="true"

plugins=(git virtualenv zsh-syntax-highlighting zsh-autosuggestions poetry)

source $ZSH/oh-my-zsh.sh

export FZF_DEFAULT_OPTS="--reverse --height=50% --border"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
