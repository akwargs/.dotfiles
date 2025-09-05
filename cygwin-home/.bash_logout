if [ -x /usr/bin/ssh-pageant ]; then
    eval $(/usr/bin/ssh-pageant -qk 2>/dev/null)
fi
