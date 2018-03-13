# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# set PYTHONSTARTUP so user's initialization file is executed if it exists
if [ -f "$HOME/.pystartup" ]
then
	export PYTHONSTARTUP="$HOME/.pystartup"
fi

#set the PYTHONPATH so Python finds the prebuilt setools4 modules distributed with the AOSP tree
# if [ -d "$HOME/workspace/prebuilts/python/linux-x86/2.7.5/lib/python2.7/site-packages" ]
#then
#        export PYTHONPATH="$PYTHONPATH:$HOME/workspace/prebuilts/python/linux-x86/2.7.5/lib/python2.7/site-packages"
#fi

# Set the pythonpath so Python finds the user local Pip modules
if [ -d "$HOME/.local/lib/python2.7/site-packages" ]
then
	export PYTHONPATH="$HOME/.local/lib/python2.7/site-packages:$PYTHONPATH"
fi

 # Use vim as pager
 #export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
 #    vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
 #    -c 'map <SPACE> <C-D>' -c 'map b <C-U>' -c 'set nonumber'\
 #    -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""
 export MANPAGER='bash -c "vim -mR --noplugin -u ~/.vimrc.pager </dev/tty <(col -b -x)"'
 export GROFF_NO_SGR=1

 # Make these functions, common in other languages, available in the shell
 # Convert a character to its hexadecimal representation
 ord() { printf "0x%x\n" "'$1"; }
 # Convert a character from its hexadecimal representation
 chr() { printf $(printf '\\%03o\\n' "$1"); }

if [ -d "$HOME/.bash-git-prompt" ]
then
	# gitprompt configuration
	# Set config variables first
	GIT_PROMPT_ONLY_IN_REPO=1
	# GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status
	# GIT_PROMPT_SHOW_UPSTREAM=1 # uncomment to show upstream tracking branch
	# GIT_PROMPT_STATUS_COMMAND=gitstatus_pre-1.7.10.sh # uncomment to support Git older than 1.7.10
	# GIT_PROMPT_START=...    # uncomment for custom prompt start sequence
	# GIT_PROMPT_END=...      # uncomment for custom prompt end sequence
	# as last entry source the gitprompt script
	# GIT_PROMPT_THEME=Custom # use custom .git-prompt-colors.sh
	# GIT_PROMPT_THEME=Solarized # use theme optimized for solarized color scheme
	GIT_PROMPT_THEME=Custom
	source ~/.bash-git-prompt/gitprompt.sh
fi

# Override the cd builtin to do some nice things
function cd
{
	# If no arguments (change to ~)
	if [[ $# -eq 0 ]]
	then
		# If we are in a repo and we are not already in the root change to the repo root
		local repo="$(git rev-parse --show-toplevel 2>/dev/null)"
		if [[ -n "$repo" && "$PWD" != "$repo" ]]
		then
			builtin cd $repo
		else
			builtin cd "$@"
		fi
	else
		builtin cd "$@"
	fi
	if [[ $? -eq 0 ]]
	then
		# Print last commit message if we come from outside a git repo
		if git rev-parse --show-toplevel &>/dev/null
		then
			if ! [[ "$OLDPWD" == "$(git rev-parse --show-toplevel)"* ]]
			then
				echo "Last local commit:"
				git log -1
			fi
		fi
	fi
}

function mkcd
{
	mkdir -p "$@" && cd "$@"
}

# Show context-aware TODOs
function todo
{
	# If we are in a git repo
	local repo="$(git rev-parse --show-toplevel 2>/dev/null)"
	if [[ -n "$repo" ]]
	then
		# Search the code for TODOs
		git grep -i "todo"
	elif [[ -f "$PWD/TODO" ]]
	then
		cat "$PWD/TODO"
	fi
}

# Start thefuck with bash [https://github.com/nvbn/thefuck]
if command -v thefuck > /dev/null
then
  eval $(thefuck --alias)
fi

# Open vim pointing at a specific line in the file
function vim
{
  # If no arguments, more than one argument, or the filename
  # does not contain a line number, pass through to VIM
	if [[ $# -eq 0 || $# -gt 1 || ! "$1" =~ ^.*:[0-9]+$ ]]
	then
    command vim "$@"
  else
    lineno="${1##*:}"
    filename="${1%:$lineno}"
    command vim +"$lineno" -c "normal zt" "$filename"
  fi
}
