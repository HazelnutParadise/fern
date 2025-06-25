#!/bin/bash
set -e

echo "[FIG] Enabling IPv4 forwarding..."
sudo sysctl -w net.ipv4.ip_forward=1
sudo sed -i 's/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf

echo "[FIG] Configuring wlan0 (AP interface)..."
sudo cp configs/hostapd.conf /etc/hostapd/hostapd.conf
sudo cp configs/dnsmasq.conf /etc/dnsmasq.conf
sudo rfkill unblock wlan
sudo ip link set wlan0 down
sudo ip addr flush dev wlan0
sudo ip addr add 192.168.4.1/24 dev wlan0
sudo ip link set wlan0 up

echo "[FIG] Setting hostapd default config path..."
sudo sed -i 's|#DAEMON_CONF="|DAEMON_CONF="/etc/hostapd/hostapd.conf"|' /etc/default/hostapd

echo "[FIG] Restarting services..."
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl enable dnsmasq
sudo systemctl restart hostapd
sudo systemctl restart dnsmasq

echo "[FIG] Setting up BATMAN mesh..."
sudo modprobe batman-adv
sudo ip link set wlan1 down
sudo iw dev wlan1 set type ibss
sudo ip link set wlan1 up
sudo iw dev wlan1 ibss join fig-mesh 5180 HT20
sudo batctl if add wlan1
sudo ip link set up dev bat0
sudo ip addr add 10.10.10.$(shuf -i 2-254 -n 1)/24 dev bat0

echo "[FIG] Setup complete."
