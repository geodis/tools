#!/bin/bash

# Paneles
# +---------------------+-----------------------+
# |     0               |           1           |       
# +---------------------+-----------------------+
# |     2               |                       |   
# +---------------------+           4           |
# |     3               |                       |
# +---------------------+-----------------------+
# |     5               |           6           |
# +---------------------+-----------------------+

connect_ldap="ssh root@ldap-server"
connect_mail="ssh root@mail"
connect_proxy="ssh root@proxy"
time_out=2

tmux has-session 
if [ $? == 0 ]
then
    # Division

    tmux split-window -v -p 30
    tmux select-pane -t 0
    tmux split-window -v -p 60
    tmux select-pane -t 0
    tmux select-pane -t 1
    tmux select-pane -t 2
    tmux select-pane -t 0
    tmux split-window -h -p 50
    tmux select-pane -t 2
    tmux split-window -h -p 50
    tmux select-pane -t 2
    tmux split-window -v -p 20
    tmux select-pane -t 5
    tmux split-window -h -p 50


    tmux display-panes

    # +-------------------+
    # | ldap-server     |
    # +-------------------+
    tmux select-pane -t 0
    tmux send-keys "$connect_ldap"  C-m
    sleep $time_out
    tmux send-keys "glances"  C-m

    # +-------------+
    # |     mail    |
    # +-------------+
    # 
    tmux select-pane -t 2
    tmux send-keys "$connect_mail"  C-m
    sleep $time_out
    tmux send-keys "glances"  C-m
    
    tmux select-pane -t 3
    tmux send-keys "$connect_mail"  C-m
    sleep $time_out
    tmux send-keys 'watch -n100 "ls /var/lib/mailman/data/held*"'  C-m

    tmux select-pane -t 4
    tmux send-keys "$connect_mail"  C-m
    sleep $time_out
    tmux send-keys "mail_queue_watch.sh"  C-m

    # +-------------+
    # |     proxy   |
    # +-------------+
    # 
    tmux select-pane -t 5
    tmux send-keys "$connect_proxy"  C-m
    sleep $time_out
    tmux send-keys 'glances'  C-m

    tmux select-pane -t 6
    tmux send-keys "$connect_proxy"  C-m
    sleep $time_out
    tmux send-keys 'nload'  C-m

    # FIX
    tmux select-pane -t 1
    tmux send-keys "$connect_ldap"  C-m
    sleep $time_out
    tmux send-keys "logout"  C-m
    # /FIX
    
fi


