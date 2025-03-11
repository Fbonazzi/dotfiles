# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export EDITOR=vim

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Start SSH agent
# If the agent is not running, start it, and save the environment to a file
if [ "$(pidof ssh-agent)" = "" ]; then
        ssh_env="$(ssh-agent -s)"
        echo "$ssh_env" | head -n 2 > ~/.ssh_agent_env
	eval "$ssh_env"
	ssh-add
fi

# Load the environment from the file
if [ -f ~/.ssh_agent_env ]; then
        source ~/.ssh_agent_env
fi
