# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
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

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

export GREP_OPTIONS="--exclude-dir=\.svn"
#export WINGHOME="/usr/local/lib/wingide3.1"

export JAVA_HOME=/usr/lib/jvm/java-6-sun

GREP_OPTIONS="--exclude-dir=\.svn --colour=always"

export PYTHONPATH=/home/channam/Code/causal:/home/channam/Code/tontine/src


PROMPT_COMMAND=prompt_func
WORKON_HOME=/home/channam/Envs
source /usr/local/bin/virtualenvwrapper.sh
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true

export PATH=$PATH:/home/channam/Code/mongodb/bin:/home/channam/bin


# Show current git branch or SVN subfolder in prompt.
      GREEN="\[\033[0;32m\]"
LIGHT_GREEN="\[\033[1;32m\]"
       GRAY="\[\033[1;30m\]"
 LIGHT_BLUE="\[\033[1;34m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
  COLOR_OFF="\[\e[0m\]"
function prompt_func() {
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
  
  branch_pattern="\* ([^$IFS]*)"
  if [[ -d "./.git" && "$(git branch --no-color 2> /dev/null)" =~ $branch_pattern ]]; then
    branch="${BASH_REMATCH[1]}"
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]'
    PS1+=":$GRAY$branch$LIGHT_GRAY@$revision$COLOR_OFF\$ "

  elif [[ -d "./.svn" ]]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]'
    path_pattern="URL: ([^$IFS]*).*Repository Root: ([^$IFS]*).*Revision: ([0-9]*)"
    if [[ "$(svn info 2> /dev/null)" =~ ${path_pattern} ]]; then
      branch=`/usr/bin/ruby -e 'print ARGV[0][ARGV[1].size + 1..-1] || "/"' ${BASH_REMATCH[1]} ${BASH_REMATCH[2]}`
      revision="${BASH_REMATCH[3]}"
      PS1+=":$GRAY$branch$LIGHT_GRAY@$revision$COLOR_OFF\$ "
    fi
  fi
}
PROMPT_COMMAND=prompt_func
