# Theme
export ZSH=/home/ntc/.oh-my-zsh
ZSH_THEME="agnoster_modified"
autoload -U promptinit
promptinit


# Shell history
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt no_share_history     # Don't share history between separate shells
setopt hist_ignore_all_dups # Remove duplicates from the history
setopt inc_append_history   # Append to histfile as soon as command is entered

# Globbing and autocompletion
setopt extendedglob     # Use the ^, ~, and # for filename globbing
setopt nocaseglob       # Case insensitive filename globbing
setopt nomatch          # Warn if file globbing didn't match any file
setopt completeinword   # Allow autocompletions inside a word

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion::complete:*' use-cache 1
autoload -Uz compinit
compinit

# Misc
setopt nobeep           # Disable terminal bell
setopt autocd           # cd if only a directory name was entered
setopt correct          # Prompt to correct misspelled commands
setopt hash_list_all    # Correct false reports of spelling errors


# Plugins:
#   git: Builtin aliases for common git commands
#   archlinux: Builtin aliases for pacman and yaourt
plugins=(git archlinux history-substring-search)
source $ZSH/oh-my-zsh.sh

bindkey -v # vim mode
export KEYTIMEOUT=1

export VISUAL=vim
export EDITOR=vim
export GIT_EDITOR=vim

function zle-line-init zle-keymap-select {
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

bindkey '^?' backward-delete-char # backspace work after returning from normal mode

export PATH=$PATH:$HOME/bin
alias icat="kitty +kitten icat"

bindkey -v "^[[Z" history-substring-search-up
bindkey -v "^[[A" history-substring-search-up
bindkey -v "^[[B" history-substring-search-down

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
