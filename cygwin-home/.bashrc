[[ "$-" != *i* ]] && return
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls:ll:lla:la'
export MANPAGER='less -XRF'
export PAGER='less -XRF'
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

PS1='\n$ '

stty -ixon
set -o notify
set -o ignoreeof

alias cp='cp -i'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color'
alias g='grep -i'
alias la='ls -A'
alias ll='ls -lhgG'
alias lla='ls -AlhgG'
alias m='less -XRF'
alias mv='mv -i'
alias rm='rm -i'
alias rmrf='rm -rf'
alias startagent='eval $(/usr/bin/ssh-pageant -q)'
alias killagent='eval $(/usr/bin/ssh-pageant -qk 2>/dev/null)'

scr ()
{
  # screen -t $(date +%Y%m%d_T%H%M%S%Z)_$1 ssh $@;
  screen -t $1 ssh $@;
}

# if you start me up, i'll never stop
if [ -x /usr/bin/ssh-pageant ]; then
  eval $(/usr/bin/ssh-pageant -q)
fi
trap logout HUP

# stop it cuz .bash_logout doesn't always work in cygwin
exit ()
{
  if [ -x /usr/bin/ssh-pageant ]; then
      eval $(/usr/bin/ssh-pageant -qk 2>/dev/null)
  fi
  builtin exit
}
#eof
