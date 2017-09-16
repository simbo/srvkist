#!/bin/sh

# flush rules
iptables -F
ip6tables -F

# allow localhost connections to the loopback interface
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT ! -i lo -d 127.0.0.0/8 -j REJECT

# allow connections which are already established
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
ip6tables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# allow all outbound connections
iptables -A OUTPUT -j ACCEPT
ip6tables -A OUTPUT -j ACCEPT

# allow access from all hosts to specific ports
for PORT in 22 80 443; do
  iptables -A INPUT -p tcp -m state --state NEW,ESTABLISHED,RELATED --dport $PORT -j ACCEPT
  ip6tables -A INPUT -p tcp -m state --state NEW,ESTABLISHED,RELATED --dport $PORT -j ACCEPT
done

# allow ping
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT
ip6tables -A INPUT -p icmpv6 -j ACCEPT
ip6tables -A OUTPUT -p icmpv6 -j ACCEPT

# drop all other inbound traffic (including ICMP, UDP etc.)
iptables -A INPUT -j DROP
ip6tables -A INPUT -j DROP
