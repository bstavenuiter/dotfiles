# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export BREW_HOME=$(brew --prefix)
export PATH=$PATH:$HOME/.local/bin:$HOME/Library/Python/2.7/bin:$HOME/.cargo/bin
export DOLLAR=$
export DYLD_LIBRARY_PATH=/usr/local/opt/openssl/lib:$DYLD_LIBRARY_PATH
export HISTCONTROL=ignorespace
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export TMPDIR=/tmp
export HOMEBREW_NO_AUTO_UPDATE=1


# For Mac OS
export PATH=$HOME/.config/bin:$HOME/go/bin:$PATH
alias python3=/opt/homebrew/bin/python3

## ENVS, the more private ones
source ~/.zsh_env_vars

eval "$(fnm env --use-on-cd)"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

HISTFILESIZE=10000000
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
export SAVEHIST=$HISTSIZE
setopt SHARE_HISTORY #share history across all sessions
setopt HIST_IGNORE_ALL_DUPS #ignore duplicate commands like ls -latr


_has() {
      return $( whence $1 >/dev/null )
}
# PATH MODIFICATIONS {{{1

# Functions which modify the path given a directory, but only if the directory
# exists and is not already in the path. (Super useful in ~/.zshlocal)

_prepend_to_path() {
    if [ -d $1 -a -z ${path[(r)$1]} ]; then
    path=($1 $path);
    fi
}

_append_to_path() {
    if [ -d $1 -a -z ${path[(r)$1]} ]; then
        path=($1 $path);
    fi
}

_force_prepend_to_path() {
    path=($1 ${(@)path:#$1})
}

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(git docker docker-compose)
plugins=( 
    # other plugins...
    kubectl
)


# User configuration
export PATH=$PATH:/Applications/MySQLWorkbench.app/Contents/MacOS:$HOME/.composer/vendor/bin

export PATH=$PATH:/opt/homebrew/opt/mysql-client@8.4/bin

#export VIMRUNTIME="/Applications/MacVim.app/Contents/Resources/vim/runtime"
#disable auto update for oh-my-zsh
DISABLE_AUTO_UPDATE=true
source $ZSH/oh-my-zsh.sh
source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh
#source $HOME/.oh-my-zsh/custom/plugins/zsh-fzf-history-search/zsh-fzf-history-search.zsh
source $BREW_HOME/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/themes/powerlevel10k/powerlevel10k.zsh-theme
#
##
 
#export NVM_DIR=~/.nvm
#source $(brew --prefix nvm)/nvm.sh

#You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export ANSIBLE_CONFIG="~/code/ansible/ansible.cfg"
export ANSIBLE_SSH_USER="bstavenuiter"
export ACKRC=".acrc"

# Generate 32 chars password
alias pass="openssl rand -base64 32 | tr -dc _A-Z-a-z-0-9 | head -c 32"

# FZF {{{1

 # FZF is the future. This stuff has to be after some of the Zsh stuff above. Not sure why.
if [ -e /usr/local/opt/fzf/shell/completion.zsh ]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
  source /usr/local/opt/fzf/shell/completion.zsh
fi
if [ -e ~/.fzf ]; then
  _append_to_path ~/.fzf/bin
  source ~/.fzf/shell/key-bindings.zsh
  source ~/.fzf/shell/completion.zsh
fi
# if _has fzf && _has ag; then
if _has fzf && _has rg; then
  #export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!{.git/*, node_modules/*, vendor/*}"'
  # --no-ignore // don't respect the gitignore
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
  #DARK
  #export -U FZF_DEFAULT_OPTS="
   #--color fg:242,bg:236,hl:5,fg+:15,bg+:239,hl+:6
   #--color info:108,prompt:109,spinner:108,pointer:168,marker:168
   #"
   # material palenight
 #   export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
 # --color=fg:#cbccc6,bg:#1f2430,hl:#707a8c
 # --color=fg+:#707a8c,bg+:#191e2a,hl+:#ffcc66
 # --color=info:#73d0ff,prompt:#707a8c,pointer:#cbccc6
 # --color=marker:#73d0ff,spinner:#73d0ff,header:#d4bfff'
 export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
fi

## DARK
  # --color fg:242,bg:236,hl:65,fg+:15,bg+:239,hl+:108
  # --color info:108,prompt:109,spinner:108,pointer:168,marker:168
## LIGHT
  # --color light,fg:-1,bg:-1,hl:-1,fg+:-1,bg+:255,hl+:01
  # --color info:-1,prompt:-1,spinner:-1,pointer:-1,marker:-1
  #
# ctrl+f - resume job
_foreground() { CURSOR=0 LBUFFER+=' fg % 2> /dev/null' && zle accept-line }
zle -N _foreground
bindkey '\CF' _foreground

# SOURCE LOCAL CONFIG {{{1
if [ -e ~/.zshlocal ]; then
  . ~/.zshlocal
fi

# }}} Done.

bindkey '^ ' autosuggest-accept
bindkey '^y' autosuggest-accept
bindkey '^n' history-beginning-search-backward
bindkey '^p' history-beginning-search-forward
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source <(fzf --zsh)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/b.stavenuiter/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/b.stavenuiter/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/b.stavenuiter/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/b.stavenuiter/google-cloud-sdk/completion.zsh.inc'; fi

# Check if 'kubectl' is a command in $PATH
if [ $commands[kubectl] ]; then

  # Placeholder 'kubectl' shell function:
  # Will only be executed on the first call to 'kubectl'
  kubectl() {

    # Remove this function, subsequent calls will execute 'kubectl' directly
    unfunction "$0"

    # Load auto-completion
    source <(kubectl completion zsh)

    # Execute 'kubectl' binary
    $0 "$@"
  }
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Added by Antigravity
export PATH="/Users/b.stavenuiter/.antigravity/antigravity/bin:$PATH"

# Pi
export PATH="/Users/b.stavenuiter/.local/share/fnm/node-versions/v24.9.0/installation/bin:$PATH"

# workmux: tmux parses `.` as the window/pane separator, so it can't select a
# window whose name contains one. Derive a dot-free tmux target from the
# worktree handle (shr-1234.sherlock -> shr-1234).
wmo() {
  if [[ -z $1 || $1 == -* ]]; then
    workmux open "$@"
    return
  fi
  local wt=${1%/}
  shift
  workmux open "$wt" --target-name "${wt%.sherlock}" "$@"
}
