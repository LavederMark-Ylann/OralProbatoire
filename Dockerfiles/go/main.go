package main

import (
	"log"
	"net"
	"os"

	"github.com/google/gopacket"
	"github.com/google/gopacket/layers"
	"github.com/google/gopacket/pcap"
	"github.com/google/gopacket/pcapgo"
)

func main() {
	// Check if the input file and destination IP were provided as command-line arguments
	if len(os.Args) < 3 {
		log.Fatal("Input file and destination IP must be provided as command-line arguments\nExample : go run main.go input.pcap 10.0.0.1")
	}
	inputFile := os.Args[1]
	dstIP := os.Args[2]

	// Parse the destination IP
	ip := net.ParseIP(dstIP)
	if ip == nil {
		log.Fatal("Invalid destination IP")
	}

	// Open the input PCAP file
	inHandle, err := pcap.OpenOffline(inputFile)
	if err != nil {
		log.Fatal(err)
	}
	defer inHandle.Close()

	// Create a new PCAP file for the modified packets
	outFile, err := os.Create("output.pcap")
	if err != nil {
		log.Fatal(err)
	}
	defer outFile.Close()
	outHandle := pcapgo.NewWriter(outFile)
	defer outFile.Close()

	// Set up a packet source and a packet iterator
	packetSource := gopacket.NewPacketSource(inHandle, inHandle.LinkType())
	packetIter := packetSource.Packets()

	// Iterate through the packets in the input PCAP
	for packet := range packetIter {
		// Get the IP layer
		ipLayer := packet.Layer(layers.LayerTypeIPv4)
		if ipLayer == nil {
			continue
		}

		// Cast the IP layer to a IPv4 layer
		ipv4, ok := ipLayer.(*layers.IPv4)
		if !ok {
			continue
		}

		// Modify the destination IP
		ipv4.DstIP = ip

		// Write the modified packet to the output PCAP
		if err := outHandle.WritePacket(packet.Metadata().CaptureInfo, packet.Data()); err != nil {
			log.Fatal(err)
		}
	}
}
