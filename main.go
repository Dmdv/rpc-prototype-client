package main

import (
	"context"
	"flag"
	"log"
	"time"

	"github.com/dmdv/rpc-prototype-server/pkg"
	"github.com/smallnest/rpcx/client"
	"github.com/smallnest/rpcx/protocol"
)

var (
	addr = flag.String("addr", "rpcx-server:8972", "server address")
)

func main() {
	flag.Parse()

	d, _ := client.NewPeer2PeerDiscovery("tcp@"+*addr, "")
	//d, _ := client.NewDNSDiscovery("rpcx-server-demo-dns-service", "tcp", 8972, time.Minute)

	opt := client.DefaultOption
	opt.SerializeType = protocol.JSON

	xclient := client.NewXClient("Arith", client.Failtry, client.RandomSelect, d, opt)
	//goland:noinspection GoUnhandledErrorResult
	defer xclient.Close()

	args := pkg.Args{
		A: 10,
		B: 20,
	}

	for {
		reply := &pkg.Reply{}
		err := xclient.Call(context.Background(), "Mul", args, reply)
		if err != nil {
			log.Fatalf("failed to call: %v", err)
		}

		log.Printf("%d * %d = %d", args.A, args.B, reply.C)
		time.Sleep(time.Second)
	}
}
