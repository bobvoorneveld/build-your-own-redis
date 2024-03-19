import NIO

@main
public struct RedisServer {

    public static func main() throws {

        // You can use print statements as follows for debugging, they'll be visible when running tests.
    	print("Logs from your program will appear here!\n");

        let eventLoopGroup = MultiThreadedEventLoopGroup(
            numberOfThreads: System.coreCount
        )

        defer {
            try! eventLoopGroup.syncShutdownGracefully()
        }

        let serverBootstrap = ServerBootstrap(
            group: eventLoopGroup
        )
        .serverChannelOption(
            ChannelOptions.backlog,
            value: 256
        )
        .serverChannelOption(
            ChannelOptions.socketOption(.so_reuseaddr),
            value: 1
        )
        .childChannelInitializer { channel in
            channel.pipeline.addHandlers([
                BackPressureHandler(),
                RedisHandler(),
            ])
        }
        .childChannelOption(
            ChannelOptions.socketOption(.so_reuseaddr),
            value: 1
        )
        .childChannelOption(
            ChannelOptions.maxMessagesPerRead,
            value: 16
        )
        .childChannelOption(
            ChannelOptions.recvAllocator,
            value: AdaptiveRecvByteBufferAllocator()
        )

        let defaultHost = "127.0.0.1" // or ::1 for IPv6
        let defaultPort = 6379

    	// Uncomment this block to pass the first stage
        //
        //  let channel = try serverBootstrap.bind(
        //      host: defaultHost,
        //      port: defaultPort
        //  )
        //  .wait()
        // 
        //  print("Server started and listening on \(channel.localAddress!)")
        //  try channel.closeFuture.wait()
        //  print("Server closed")
    }
}