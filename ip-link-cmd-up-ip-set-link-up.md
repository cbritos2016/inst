crisb@debian:~$ ip a
1: lo: mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute
       valid_lft forever preferred_lft forever
2: enp0s31f6: mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether f8:75:a4:28:c8:e2 brd ff:ff:ff:ff:ff:ff
    altname enxf875a428c8e2 --- enp0s31f6 is down how do I bring it back

To bring the interface enp0s31f6 back up:
Bash
sudo ip link set enp0s31f6 up
Then check its status:
Bash
ip a show enp0s31f6
If it still shows as DOWN or has no IP

Check for a carrier / cable
Make sure an Ethernet cable is plugged in and the other end is connected to a working switch/router.
You can verify with:Bashethtool enp0s31f6 | grep -i "Link detected"(or sudo ethtool enp0s31f6)
Get an IP address (if using DHCP)Bashsudo dhclient enp0s31f6or, on systems using NetworkManager:Bashsudo nmcli device connect enp0s31f6
If you use NetworkManager (common on desktop Debian)Bashnmcli device status
sudo nmcli device set enp0s31f6 managed yes
sudo nmcli device connect enp0s31f6
Persistent configuration
If it keeps going down after reboot, check /etc/network/interfaces or NetworkManager connection profiles and make sure the interface is configured to start automatically.

After bringing it up, run ip a again and look for an inet address on enp0s31f6.show ipv4 instead of this: ip a show enp0s31f6To show only the IPv4 address for enp0s31f6:
Bash
ip -4 addr show enp0s31f6
Or the shorter form:
Bash
ip -4 a show enp0s31f6
This filters the output to IPv4 only (no MAC address, no IPv6, no link details).$ ip a show enp0s31f6
2: enp0s31f6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether f8:75:a4:28:c8:e2 brd ff:ff:ff:ff:ff:ff
    altname enxf875a428c8e2
    inet6 2600:e400:11e:7500:fa75:a4ff:fe28:c8e2/64 scope global dynamic mngtmpaddr proto kernel_ra
       valid_lft 13486sec preferred_lft 13486sec
    inet6 fd52:e8ea:f0d9:1:fa75:a4ff:fe28:c8e2/64 scope global dynamic mngtmpaddr proto kernel_ra
       valid_lft 2591977sec preferred_lft 604777sec
    inet6 fe80::fa75:a4ff:fe28:c8e2/64 scope link proto kernel_ll
       valid_lft forever preferred_lft forever

crisb@debian:~$ ip -4 addr show enp0s31f6

crisb@debian:~$ ip -4 a show enp0s31f6

crisb@debian:~$



Your interface is UP, but it has no IPv4 address — only IPv6. That’s why ip -4 shows nothing.
Get an IPv4 address (DHCP)
Try this first:
Bash
sudo dhclient enp0s31f6
Then check:
Bash
ip -4 a show enp0s31f6
If you use NetworkManager (common on desktop Debian)
Bash
sudo nmcli device connect enp0s31f6
or
Bash
sudo nmcli connection up "Wired connection 1"
(You can list connections with nmcli connection show)
Still no IPv4?

Check if DHCP is working / cable is good:Bashsudo ethtool enp0s31f6 | grep -E "Link detected|Speed"
See if anything is listening / blocking DHCP:Bashsudo journalctl -u NetworkManager -b --no-pager | tail -30or (if using classic networking):Bashsudo journalctl -b | grep -i dhcp
Temporary static IP (for testing only):Bashsudo ip addr add 192.168.1.100/24 dev enp0s31f6
sudo ip route add default via 192.168.1.1(Replace the addresses with ones that match your network.)

Run sudo dhclient enp0s31f6 and paste the result of ip -4 a show enp0s31f6 if it still doesn’t get an address.