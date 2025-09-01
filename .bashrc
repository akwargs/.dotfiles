[[ "$-" != *i* ]] && return
# cygwin will read $Env:HOME/.bashrc
# instead switch to cygwin home and source separate bashrc
export HOME=/home/$USERNAME
cd ~ && source ~/.bashrc
