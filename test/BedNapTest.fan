using afButter
using afBounce
using afIoc
using afIocEnv

internal abstract class BedNapTest : Test {
	BedServer? 	server
	BedClient? 	client
	
	override Void setup() {
		server	= BedServer(AppModule#.pod).addModule(WebTestModule#).startup
		server.inject(this)
		client = server.makeClient
	}

	override Void teardown() {
		server?.shutdown
	}
}

internal const class WebTestModule {
	@Override
	IocEnv overrideIocEnv() {
        IocEnv.fromStr("Testing")
    }
}
