#!/bin/bash
# This script installs and configures fail2ban for Ubuntu Linux Servers
# The configuration is as follows:
# 
# Enabled Jails: postfix, postfix-sasl, sieve, sshd, dovecot (same from emailwiz)
# Retries Before Ban: 2
# Ban Time: 10 Hours
# Program That Bans: UFW

apt-get install -y fail2ban
[ ! -f /etc/fail2ban/jail.d/jail.local ] && echo "[postfix]
enabled = true
[postfix-sasl]
enabled = true
[sieve]
enabled = true
[sshd]
enabled = true
bantime = 10h
maxretry = 2
findtime = 10m
banaction = ufw
[dovecot]
enabled = true" > /etc/fail2ban/jail.d/jail.local

sed -i "s|^backend = auto$|backend = systemd|" /etc/fail2ban/jail.conf

for x in ufw fail2ban; do
	printf "Restarting %s..." "$x"
	service "$x" restart && printf " ...done\\n"
	systemctl enable "$x"
done

printf "\n\nfail2ban successfully installed.\nYou may check the banned list with sudo fail2ban-client banned"
