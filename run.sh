sudo ls ./
sudo clear
sudo ./tun2socks -device tun://utun6 -proxy socks5://127.0.0.1:1080 -interface en0 -stats 127.0.0.1:8810  -loglevel debug  &
PID=$!
sudo ifconfig utun6 10.0.0.2 netmask 255.255.255.0 10.0.0.1
sudo ifconfig utun6 10.0.0.1 10.0.0.2 up
sudo route delete default
sudo route delete default -ifscope en0
sudo route add default 10.0.0.1
sudo route add default 192.168.18.254  -ifscope en0
networksetup -setdnsservers "Ethernet" 8.8.8.8
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
wait ${PID}
sudo route delete default
sudo route add default 192.168.18.254
sudo route add default 192.168.18.254  -ifscope en0
#networksetup -listallnetworkservices
#scutil --dns | grep 'nameserver\[[0-9]*\]'
networksetup -setdnsservers Ethernet "Empty"
echo "DONE"
