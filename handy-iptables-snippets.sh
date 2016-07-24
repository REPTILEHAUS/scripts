#!/bin/bash

# Get a list of recent ssh login IP addresses
zgrep sshd /var/log/auth.log* | grep rhost | sed -re 's/.*rhost=([^ ]+).*/\1/' | sort -u


# allow 2 IP's that you regularly SSH from
iptables -A INPUT -p tcp --dport 22 -s 89.100.239.94,89.122.254.82 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j REJECT

# Check current IPTABLES rules
iptables -L

# Running this ensures that all IP table Rules are removed whenever its executed
# Worth writing as a standalone script running via cron every 2 minutes if you
# are setting up rules that could potentially lock you out.
iptables-save | awk '/^[*]/ { print $1 }
                     /^:[A-Z]+ [^-]/ { print $1 " ACCEPT" ; }
                     /COMMIT/ { print $0; }' | sudo iptables-restore
