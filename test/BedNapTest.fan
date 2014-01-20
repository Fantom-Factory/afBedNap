using afButter
using afBounce
using afIoc
using afIocEnv

internal class BedNapTest : Test {
	BedServer? 	server
	BedClient? 	client
	
	override Void setup() {
		server	= BedServer(AppModule#.pod).addModule(WebTestModule#).startup
		server.injectIntoFields(this)
		client = MyBedClient(server.makeClient)
	}

	override Void teardown() {
		server?.shutdown
	}
}

class WebTestModule {
    @Contribute { serviceType=ServiceOverride# }
    static Void contributeServiceOverride(MappedConfig config) {
        config["IocEnv"] = IocEnv.fromStr("Testing")
    }
}

class MyBedClient : BedClient {
	new make(Butter butter) : super(butter) { }
	
	// fixing Bug in Bounce
	override ButterResponse sendRequest(ButterRequest req) {
		if (req.headers.contentLength == null && req.method != "GET") {
			req.headers.contentLength = req.body.size
		}		
		return super.sendRequest(req)
	}
}