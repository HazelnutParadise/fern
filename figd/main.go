package main

import (
	"fmt"
	"log"
	"os/exec"

	"github.com/BurntSushi/toml"
)

type Config struct {
	Mesh struct {
		Interface    string `toml:"interface"`
		SSID         string `toml:"ssid"`
		Frequency    int    `toml:"frequency"`
		ChannelWidth string `toml:"channel_width"`
		IPAddress    string `toml:"ip_address"`
		Netmask      int    `toml:"netmask"`
	} `toml:"mesh"`

	AP struct {
		Interface   string `toml:"interface"`
		IPAddress   string `toml:"ip_address"`
		Netmask     int    `toml:"netmask"`
		HostapdConf string `toml:"hostapd_conf"`
		DnsmasqConf string `toml:"dnsmasq_conf"`
	} `toml:"ap"`
}

func run(cmd string, args ...string) {
	fmt.Printf("[FIGD] %s %v\n", cmd, args)
	out, err := exec.Command(cmd, args...).CombinedOutput()
	if err != nil {
		log.Fatalf("Error: %v\nOutput: %s", err, string(out))
	}
}

func main() {
	var config Config
	if _, err := toml.DecodeFile("config.toml", &config); err != nil {
		log.Fatalf("Failed to load config.toml: %v", err)
	}

	run("rfkill", "unblock", "wlan")
	run("ip", "link", "set", config.AP.Interface, "down")
	run("ip", "addr", "flush", "dev", config.AP.Interface)
	run("ip", "addr", "add", fmt.Sprintf("%s/%d", config.AP.IPAddress, config.AP.Netmask), "dev", config.AP.Interface)
	run("ip", "link", "set", config.AP.Interface, "up")

	run("cp", config.AP.HostapdConf, "/etc/hostapd/hostapd.conf")
	run("cp", config.AP.DnsmasqConf, "/etc/dnsmasq.conf")
	run("systemctl", "unmask", "hostapd")
	run("systemctl", "enable", "hostapd")
	run("systemctl", "enable", "dnsmasq")
	run("systemctl", "restart", "hostapd")
	run("systemctl", "restart", "dnsmasq")

	run("modprobe", "batman-adv")
	run("ip", "link", "set", config.Mesh.Interface, "down")
	run("iw", "dev", config.Mesh.Interface, "set", "type", "ibss")
	run("ip", "link", "set", config.Mesh.Interface, "up")
	run("iw", "dev", config.Mesh.Interface, "ibss", "join", config.Mesh.SSID, fmt.Sprintf("%d", config.Mesh.Frequency), config.Mesh.ChannelWidth)
	run("batctl", "if", "add", config.Mesh.Interface)
	run("ip", "link", "set", "up", "dev", "bat0")
	run("ip", "addr", "add", fmt.Sprintf("%s/%d", config.Mesh.IPAddress, config.Mesh.Netmask), "dev", "bat0")

	fmt.Println("[FIGD] Initialization complete.")
}
