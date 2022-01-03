# Sample .bashrc for SuSE Linux
# Copyright (c) SuSE GmbH Nuernberg

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

# Some applications read the EDITOR variable to determine your favourite text
# editor. So uncomment the line below and enter the editor of your choice :-)
export EDITOR=/usr/bin/vim
#export EDITOR=/usr/bin/mcedit

# For some news readers it makes sense to specify the NEWSSERVER variable here
#export NEWSSERVER=your.news.server

# If you want to use a Palm device with Linux, uncomment the two lines below.
# For some (older) Palm Pilots, you might need to set a lower baud rate
# e.g. 57600 or 38400; lowest is 9600 (very slow!)
#
#export PILOTPORT=/dev/pilot
#export PILOTRATE=115200

test -s ~/.alias && . ~/.alias || true

# Don't execute history commands directly, just place them on the command line
shopt -s histverify

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

