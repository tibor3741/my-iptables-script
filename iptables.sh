#!/bin/sh

err()
{
echo >&2 "$(tput bold; tput setaf 1)[-] ERROR: ${*}$(tput sgr0)"
}
check_priv()
{
  if [ "$(id -u)" -ne 0 ]; then
    err "Ezt Root-ként kell futtatnod!"
    exit 1
  fi
}

check_priv
echo ----------------------------
echo A Tűzfal parancsok beálítása
echo ----------------------------

iptables -F
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
iptables -P INPUT ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT  -m tcp -p tcp --dport 6864 -j ACCEPT
iptables -I INPUT  -m tcp -p tcp --dport 12345 -j ACCEPT
iptables -A INPUT  -p udp --sport 53 -j ACCEPT
iptables -A INPUT  -p tcp --sport 443 -j ACCEPT
iptables -A INPUT -p tcp --sport 80 -j ACCEPT


iptables -A INPUT -j LOG --log-prefix '[iptables] '
#iptables -A INPUT -j LOG --log-prefix '[netfilter]'  -/var/log/iptables.log

iptables -A INPUT -j DROP
iptables -L

echo
echo -------------------------
echo A Tűzfal beálítás kész!
echo -------------------------
echo
